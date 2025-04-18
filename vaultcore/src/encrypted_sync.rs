use x25519_dalek::{EphemeralSecret, PublicKey};
use chacha20poly1305::{aead::{Aead, KeyInit}, XChaCha20Poly1305, XNonce};
use rand::rngs::OsRng;
use rand::RngCore;
use base64::{engine::general_purpose::STANDARD, Engine as _};
use hkdf::Hkdf;
use sha2::Sha256;

/// Encrypt a sync payload using a shared secret
pub fn encrypt_sync_payload(payload: &[u8], shared_key: &[u8]) -> Result<(String, String), String> {
    if shared_key.len() != 32 {
        return Err("Invalid shared key length: must be 32 bytes".to_string());
    }

    let cipher = XChaCha20Poly1305::new(shared_key.into());

    let mut nonce = [0u8; 24];
    OsRng.fill_bytes(&mut nonce);

    let ciphertext = cipher
        .encrypt(XNonce::from_slice(&nonce), payload)
        .map_err(|_| "Failed to encrypt sync payload".to_string())?;

    Ok((
        STANDARD.encode(&nonce),
        STANDARD.encode(&ciphertext),
    ))
}

/// Decrypt a sync payload using shared secret and base64 inputs
pub fn decrypt_sync_payload(
    nonce_b64: &str,
    cipher_b64: &str,
    shared_key: &[u8],
) -> Result<Vec<u8>, String> {
    if shared_key.len() != 32 {
        return Err("Invalid shared key length: must be 32 bytes".to_string());
    }

    let cipher = XChaCha20Poly1305::new(shared_key.into());

    let nonce = STANDARD
        .decode(nonce_b64)
        .map_err(|_| "Invalid Base64 encoding for nonce".to_string())?;
    if nonce.len() != 24 {
        return Err("Invalid nonce length".to_string());
    }

    let ciphertext = STANDARD
        .decode(cipher_b64)
        .map_err(|_| "Invalid Base64 encoding for ciphertext".to_string())?;

    cipher
        .decrypt(XNonce::from_slice(&nonce), ciphertext.as_ref())
        .map_err(|_| "Failed to decrypt sync payload".to_string())
}

/// Derive a shared key from two X25519 keys
pub fn derive_shared_key(private: EphemeralSecret, peer_public: PublicKey) -> [u8; 32] {
    let shared = private.diffie_hellman(&peer_public);
    let raw_shared = shared.to_bytes();

    // Use HKDF to derive a 256-bit key
    let hkdf = Hkdf::<Sha256>::new(None, &raw_shared);
    let mut shared_key = [0u8; 32];
    hkdf.expand(b"X25519 shared key", &mut shared_key)
        .expect("HKDF expansion failed");
    shared_key
}