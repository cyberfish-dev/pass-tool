use ed25519_dalek::{SigningKey, VerifyingKey, Signature, Signer, Verifier};
use base64::{engine::general_purpose::STANDARD, Engine as _};

use crate::crypto::generate_key;


/// Generates a new signing (private) + verifying (public) keypair.
/// Uses a secure random number generator (OsRng).
pub fn generate_keypair() -> (SigningKey, VerifyingKey) {
    
    let key_bytes = generate_key();

    let signing_key = SigningKey::from_bytes(&key_bytes);
    let verify_key = signing_key.verifying_key();
    (signing_key, verify_key)
}

/// Base64-encode a public key (for sharing/fingerprint).
pub fn encode_public_key(key: &VerifyingKey) -> String {
    STANDARD.encode(key.to_bytes())
}

/// Decode a base64-encoded public key.
/// Returns an error if the Base64 decoding or key parsing fails.
pub fn decode_public_key(b64: &str) -> Result<VerifyingKey, String> {
    let bytes = STANDARD
        .decode(b64)
        .map_err(|_| "Failed to decode Base64 public key".to_string())?;
    VerifyingKey::from_bytes(&bytes.try_into().map_err(|_| "Invalid key length".to_string())?)
        .map_err(|_| "Failed to parse public key from bytes".to_string())
}

/// Sign a message with a private key.
/// Returns the Base64-encoded signature.
pub fn sign_message(sk: &SigningKey, message: &[u8]) -> String {
    let sig = sk.sign(message);
    STANDARD.encode(sig.to_bytes())
}

/// Verify a message signature with a public key.
pub fn verify_signature(pk: &VerifyingKey, message: &[u8], sig_b64: &str) -> bool {
    let sig_bytes = match STANDARD.decode(sig_b64) {
        Ok(bytes) => bytes,
        Err(_) => return false,
    };

    if sig_bytes.len() != 64 {
        return false;
    }

    let mut fixed_bytes = [0u8; 64];
    fixed_bytes.copy_from_slice(&sig_bytes);

    let signature = Signature::from_bytes(&fixed_bytes);
    pk.verify(message, &signature).is_ok()
}