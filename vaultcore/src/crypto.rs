use chacha20poly1305::{
    aead::{Aead, KeyInit, Payload},
    XChaCha20Poly1305, XNonce, Key,
};
use rand::rngs::OsRng;
use rand::RngCore;
use base64::{engine::general_purpose, Engine as _};
use zeroize::Zeroize;

/// Generates a secure 256-bit key for encryption.
pub fn generate_key() -> [u8; 32] {
    let mut key = [0u8; 32];
    OsRng.fill_bytes(&mut key); // Use OS-level RNG for secure key generation
    key
}

/// Generates a secure 128-bit (16-byte) salt for cryptographic purposes.
pub fn generate_salt() -> [u8; 16] {
    let mut salt = [0u8; 16];
    OsRng.fill_bytes(&mut salt); // Use OS-level RNG for secure salt generation
    salt
}

/// Encrypts the given plaintext using the provided key.
/// Returns the base64-encoded nonce and ciphertext.
pub fn encrypt_entry(
    plaintext: &[u8],
    associated_data: Option<&[u8]>,
) -> Result<(String, String, [u8; 32]), String> {
    // Generate a secure key
    let mut key = generate_key();
    let cipher = XChaCha20Poly1305::new(Key::from_slice(&key));
    let mut nonce = [0u8; 24];
    OsRng.fill_bytes(&mut nonce); // Securely generate a unique nonce

    let payload = Payload {
        msg: plaintext,
        aad: associated_data.unwrap_or(&[]),
    };

    let ciphertext = cipher.encrypt(XNonce::from_slice(&nonce), payload);

    match ciphertext {
        Ok(ciphertext) => {
            let result = Ok((
                general_purpose::STANDARD.encode(nonce),
                general_purpose::STANDARD.encode(ciphertext),
                key,
            ));
            key.zeroize(); // Securely clear the key from memory
            result
        }
        Err(_) => {
            key.zeroize(); // Ensure the key is cleared even on failure
            Err("Encryption failed".to_string())
        }
    }
}

/// Decrypts the given base64-encoded nonce and ciphertext using the provided key.
/// Returns the plaintext if successful.
pub fn decrypt_entry(
    key: &[u8],
    nonce_b64: &str,
    ciphertext_b64: &str,
    associated_data: Option<&[u8]>,
) -> Result<Vec<u8>, String> {
    let cipher = XChaCha20Poly1305::new(Key::from_slice(key));
    let nonce = general_purpose::STANDARD
        .decode(nonce_b64)
        .map_err(|_| "Invalid nonce encoding".to_string())?;
    let ciphertext = general_purpose::STANDARD
        .decode(ciphertext_b64)
        .map_err(|_| "Invalid ciphertext encoding".to_string())?;

    let payload = Payload {
        msg: &ciphertext,
        aad: associated_data.unwrap_or(&[]),
    };

    let plaintext = cipher.decrypt(XNonce::from_slice(&nonce), payload);

    plaintext.map_err(|_| "Decryption failed".to_string())
}