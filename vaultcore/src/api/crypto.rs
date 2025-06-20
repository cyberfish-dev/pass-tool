// --- Imports ---
use aes_gcm::{
    aead::{Aead, KeyInit, Payload},
    Aes256Gcm, Nonce,
};
use argon2::{
    password_hash::{PasswordHasher, SaltString},
    Argon2, Params,
};
use base64::{engine::general_purpose, Engine};
use chrono::Utc;
use rand::RngCore;
use rand_core::OsRng;
use serde::{Deserialize, Serialize};
use zeroize::Zeroize;

/// Custom error type for crypto operations.
#[derive(Debug)]
pub enum CryptoError {
    SerdeJson(serde_json::Error),
    Base64(base64::DecodeError),
    AesGcm(aes_gcm::Error),
    Argon2(argon2::password_hash::Error),
    InvalidSalt,
    InvalidKeyLength,
    InvalidEncryptedKeyFormat,
    MissingHash,
    ShortDerivedKey,
    Other(String),
}

impl std::fmt::Display for CryptoError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        use CryptoError::*;
        match self {
            SerdeJson(e) => write!(f, "Serde JSON error: {}", e),
            Base64(e) => write!(f, "Base64 decode error: {}", e),
            AesGcm(e) => write!(f, "AES-GCM error: {}", e),
            Argon2(e) => write!(f, "Argon2 error: {}", e),
            InvalidSalt => write!(f, "Salt must be exactly 16 bytes for Argon2 compatibility."),
            InvalidKeyLength => write!(f, "Decrypted key has invalid length."),
            InvalidEncryptedKeyFormat => write!(f, "Invalid encrypted key format: too short."),
            MissingHash => write!(f, "Missing hash output in Argon2 result."),
            ShortDerivedKey => write!(f, "Derived hash is shorter than 64 bytes."),
            Other(msg) => write!(f, "{}", msg),
        }
    }
}

impl std::error::Error for CryptoError {}

impl From<serde_json::Error> for CryptoError {
    fn from(e: serde_json::Error) -> Self {
        CryptoError::SerdeJson(e)
    }
}
impl From<base64::DecodeError> for CryptoError {
    fn from(e: base64::DecodeError) -> Self {
        CryptoError::Base64(e)
    }
}
impl From<aes_gcm::Error> for CryptoError {
    fn from(e: aes_gcm::Error) -> Self {
        CryptoError::AesGcm(e)
    }
}
impl From<argon2::password_hash::Error> for CryptoError {
    fn from(e: argon2::password_hash::Error) -> Self {
        CryptoError::Argon2(e)
    }
}

/// Encrypts a payload using a randomly generated submaster key, which is itself encrypted with the master key.
/// Uses AAD (Additional Authenticated Data) for extra integrity.
/// Returns a JSON-encoded struct containing both encrypted submaster key and encrypted payload.
pub fn encrypt_payload<T>(payload: T, master_key: &[u8; 32]) -> Result<Vec<u8>, CryptoError>
where
    T: serde::Serialize,
{
    // Generate a random 32-byte submaster key for encrypting the payload
    let mut submaster_key = generate_submaster_key();

    // Get current timestamp (seconds since epoch)
    let now = Utc::now().timestamp();

    // Prepare AAD (authenticated data) as the timestamp in bytes
    let aad = now.to_le_bytes();

    // Encrypt the submaster key with the master key (key wrapping), using AAD
    let file_meta = encrypt_it(&submaster_key[..], master_key, &aad)?;

    // Convert the payload to JSON bytes
    let json_data = serde_json::to_vec(&payload)?;

    // Encrypt the payload with the submaster key, using AAD
    let file_data = encrypt_it(&json_data, &submaster_key, &aad)?;

    // Zeroize submaster key after use
    submaster_key.zeroize();

    // Encode both encrypted blobs as base64 for safe JSON storage
    let encoded_meta = general_purpose::STANDARD.encode(file_meta);
    let encoded_data = general_purpose::STANDARD.encode(file_data);

    // Construct the record struct
    let record = EncryptedRecordFile {
        enc_item_key: encoded_meta,
        enc_data: encoded_data,
        created_at: now,
        updated_at: now,
    };

    // Serialize the struct to JSON bytes
    let json_bytes = serde_json::to_vec(&record)?;
    Ok(json_bytes)
}

/// Decrypts a JSON-encoded encrypted record using the master key.
/// Uses AAD (Additional Authenticated Data) for extra integrity.
pub fn decrypt_payload<T>(
    encrypted_json_bytes: &[u8],
    master_key: &[u8; 32],
) -> Result<T, CryptoError>
where
    T: serde::de::DeserializeOwned,
{
    // Parse JSON to struct
    let record: EncryptedRecordFile = serde_json::from_slice(encrypted_json_bytes)?;

    // Prepare AAD (authenticated data) as the timestamp in bytes
    let aad = record.created_at.to_le_bytes();

    // Decode base64-encoded encrypted submaster key
    let enc_item_key = general_purpose::STANDARD.decode(&record.enc_item_key)?;

    // Decode base64-encoded encrypted payload
    let enc_data = general_purpose::STANDARD.decode(&record.enc_data)?;

    // Decrypt submaster key with master key, using AAD
    let mut item_key = decrypt_it(&enc_item_key, master_key, &aad)?;

    // Decrypt payload with submaster key, using AAD
    let plaintext = decrypt_it(&enc_data, &item_key, &aad)?;

    // Zeroize the item key after use
    item_key.zeroize();

    // Deserialize the plaintext bytes into the expected type T
    let plaintext: T = serde_json::from_slice(&plaintext).map_err(|e| CryptoError::SerdeJson(e))?;

    Ok(plaintext)
}

/// Derives a 64-byte master key from a password and salt using Argon2id.
/// Zeroizes password after use.
pub fn derive_master_key(password: &str, salt: &[u8]) -> Result<[u8; 64], CryptoError> {
    if salt.len() != 16 {
        return Err(CryptoError::InvalidSalt);
    }

    // Recommended Argon2id parameters for interactive login (OWASP 2024)
    let params = Params::new(131072, 4, 1, Some(64))
        .map_err(|_| CryptoError::Other("Invalid Argon2 parameters".to_string()))?;

    let argon2 = Argon2::new(argon2::Algorithm::Argon2id, argon2::Version::V0x13, params);
    let salt_str = SaltString::encode_b64(salt)
        .map_err(|_| CryptoError::Other("Invalid salt bytes".to_string()))?;

    // Copy password to a mutable buffer for zeroization
    let mut pw_buf = password.as_bytes().to_vec();

    // Perform key derivation
    let hash = argon2
        .hash_password(&pw_buf, &salt_str)
        .map_err(CryptoError::Argon2)?
        .hash
        .ok_or(CryptoError::MissingHash)?;

    // Zeroize password buffer
    pw_buf.zeroize();

    let bytes = hash.as_bytes();

    if bytes.len() < 64 {
        return Err(CryptoError::ShortDerivedKey);
    }

    let mut key = [0u8; 64];
    key.copy_from_slice(&bytes[..64]);
    Ok(key)
}

/// Splits a 64-byte master key into two 32-byte keys (encryption and MAC).
pub fn split_master_key(master_key: &[u8; 64]) -> ([u8; 32], [u8; 32]) {
    let mut enc_key = [0u8; 32];
    let mut mac_key = [0u8; 32];
    enc_key.copy_from_slice(&master_key[..32]);
    mac_key.copy_from_slice(&master_key[32..64]);
    (enc_key, mac_key)
}

/// Generates a cryptographically secure random 16-byte salt.
pub fn generate_salt() -> [u8; 16] {
    let mut salt = [0u8; 16];
    OsRng.fill_bytes(&mut salt);
    salt
}

/// Struct representing an encrypted record file.
/// Contains base64-encoded encrypted submaster key, encrypted data, and timestamps.
#[derive(Serialize, Deserialize)]
pub struct EncryptedRecordFile {
    pub enc_item_key: String, // base64(nonce + ciphertext) of submaster key
    pub enc_data: String,     // base64(nonce + ciphertext) of payload
    pub created_at: i64,
    pub updated_at: i64,
}

/// Generates a cryptographically secure random 32-byte submaster key.
pub fn generate_submaster_key() -> [u8; 32] {
    let mut key = [0u8; 32];
    OsRng.fill_bytes(&mut key);
    key
}

/// Encrypts data using AES-256-GCM with a random nonce and AAD.
/// Output is nonce || ciphertext.
pub fn encrypt_it(data: &[u8], enc_key: &[u8; 32], aad: &[u8]) -> Result<Vec<u8>, CryptoError> {
    let cipher = Aes256Gcm::new_from_slice(enc_key).map_err(|_| CryptoError::InvalidKeyLength)?;

    // Generate a random 12-byte nonce (recommended for AES-GCM)
    let mut nonce = [0u8; 12];
    OsRng.fill_bytes(&mut nonce);

    // Encrypt the data with AAD
    let ciphertext = cipher.encrypt(Nonce::from_slice(&nonce), Payload { msg: data, aad })?;

    // Output is nonce || ciphertext
    let mut out = Vec::with_capacity(12 + ciphertext.len());
    out.extend_from_slice(&nonce);
    out.extend_from_slice(&ciphertext);

    Ok(out)
}

/// Decrypts an encrypted submaster key using AES-256-GCM and AAD.
/// Returns the decrypted submaster key.
pub fn decrypt_it(enc_data: &[u8], enc_key: &[u8], aad: &[u8]) -> Result<Vec<u8>, CryptoError> {
    if enc_data.len() < 12 {
        return Err(CryptoError::InvalidEncryptedKeyFormat);
    }

    let (nonce_bytes, ciphertext) = enc_data.split_at(12);

    let cipher = Aes256Gcm::new_from_slice(enc_key).map_err(|_| CryptoError::InvalidKeyLength)?;

    let plaintext = cipher
        .decrypt(
            Nonce::from_slice(nonce_bytes),
            Payload {
                msg: ciphertext,
                aad,
            },
        )
        .map_err(CryptoError::AesGcm)?;

    Ok(plaintext)
}
