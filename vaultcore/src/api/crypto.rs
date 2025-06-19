use aes_gcm::{
    aead::{Aead, KeyInit},
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

pub fn encrypt_payload(payload: Vec<u8>, master_key: &[u8; 32]) -> Result<Vec<u8>, String> {
    let submaster_key = generate_submaster_key();

    let file_meta = encrypt_it(&submaster_key[..], master_key)?;
    let file_data = encrypt_it(&payload, &submaster_key)?;

    let encoded_meta = general_purpose::STANDARD.encode(file_meta);
    let encoded_data = general_purpose::STANDARD.encode(file_data);

    let now = Utc::now().timestamp();

    let record = EncryptedRecordFile {
        enc_item_key: encoded_meta,
        enc_data: encoded_data,
        created_at: now,
        updated_at: now,
    };

    let json_bytes = serde_json::to_vec(&record).map_err(|e| e.to_string())?;
    Ok(json_bytes)
}

pub fn decrypt_payload(
    encrypted_json_bytes: &[u8],
    master_key: &[u8; 32],
) -> Result<Vec<u8>, String> {
    // Parse JSON to struct
    let record: EncryptedRecordFile = serde_json::from_slice(encrypted_json_bytes)
        .map_err(|e| format!("Failed to parse encrypted record: {}", e))?;

    // Decode base64-encoded blobs
    let enc_item_key = general_purpose::STANDARD
        .decode(&record.enc_item_key)
        .map_err(|e| format!("Failed to decode item key: {}", e))?;

    let enc_data = general_purpose::STANDARD
        .decode(&record.enc_data)
        .map_err(|e| format!("Failed to decode record data: {}", e))?;

    // Decrypt item_key with master_key
    let item_key = decrypt_it(&enc_item_key, master_key)?;

    // Decrypt data with item_key
    let (nonce_bytes, ciphertext) = enc_data.split_at(12);
    let cipher = Aes256Gcm::new_from_slice(&item_key).map_err(|e| e.to_string())?;
    let plaintext = cipher
        .decrypt(Nonce::from_slice(nonce_bytes), ciphertext)
        .map_err(|e| format!("Failed to decrypt payload: {}", e))?;

    Ok(plaintext)
}

pub fn derive_master_key(password: &str, salt: &[u8]) -> Result<[u8; 64], String> {
    if salt.len() != 16 {
        return Err("Salt must be exactly 16 bytes for Argon2 compatibility.".to_string());
    }

    let params =
        Params::new(131072, 4, 1, Some(64)).map_err(|_| "Invalid Argon2 parameters".to_string())?;

    let argon2 = Argon2::new(argon2::Algorithm::Argon2id, argon2::Version::V0x13, params);
    let salt_str = SaltString::encode_b64(salt).map_err(|_| "Invalid salt bytes".to_string())?;

    // Perform key derivation
    let hash = argon2
        .hash_password(password.as_bytes(), &salt_str)
        .map_err(|_| "Argon2 hashing failed".to_string())?
        .hash
        .ok_or("Missing hash output in Argon2 result".to_string())?;

    let bytes = hash.as_bytes();

    if bytes.len() < 64 {
        return Err("Derived hash is shorter than 64 bytes.".into());
    }

    let mut key = [0u8; 64];
    key.copy_from_slice(&bytes[..64]);

    Ok(key)
}

pub fn split_master_key(master_key: &[u8; 64]) -> ([u8; 32], [u8; 32]) {
    let mut enc_key = [0u8; 32];
    let mut mac_key = [0u8; 32];
    enc_key.copy_from_slice(&master_key[..32]);
    mac_key.copy_from_slice(&master_key[32..64]);
    (enc_key, mac_key)
}

pub fn generate_salt() -> [u8; 16] {
    let mut salt = [0u8; 16];
    OsRng.fill_bytes(&mut salt);
    salt
}

#[derive(Serialize, Deserialize)]
struct EncryptedRecordFile {
    pub enc_item_key: String, // base64(nonce + ciphertext)
    pub enc_data: String,     // base64(nonce + ciphertext)
    pub created_at: i64,
    pub updated_at: i64,
}

fn generate_submaster_key() -> [u8; 32] {
    let mut key = [0u8; 32];
    OsRng.fill_bytes(&mut key);
    key
}

fn encrypt_it(data: &[u8], enc_key: &[u8; 32]) -> Result<Vec<u8>, String> {
    let cipher = Aes256Gcm::new_from_slice(enc_key).map_err(|e| e.to_string())?;

    let mut nonce = [0u8; 12];
    OsRng.fill_bytes(&mut nonce);
    let nonce = Nonce::from_slice(&nonce);

    let ciphertext = cipher.encrypt(nonce, data).map_err(|e| e.to_string())?;

    let mut out = Vec::with_capacity(12 + ciphertext.len());
    out.extend_from_slice(nonce);
    out.extend_from_slice(&ciphertext);

    Ok(out)
}

fn decrypt_it(enc_data: &[u8], enc_key: &[u8]) -> Result<[u8; 32], String> {
    if enc_data.len() < 12 {
        return Err("Invalid encrypted key format: too short".to_string());
    }

    let (nonce_bytes, ciphertext) = enc_data.split_at(12);

    let cipher = Aes256Gcm::new_from_slice(enc_key)
        .map_err(|e| format!("Failed to initialize cipher: {}", e))?;

    let plaintext = cipher
        .decrypt(Nonce::from_slice(nonce_bytes), ciphertext)
        .map_err(|e| format!("Failed to decrypt key: {}", e))?;

    if plaintext.len() != 32 {
        return Err("Decrypted key has invalid length".to_string());
    }

    let mut out = [0u8; 32];
    out.copy_from_slice(&plaintext);
    Ok(out)
}
