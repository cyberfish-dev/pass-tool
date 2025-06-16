
use rand_core::OsRng;
use pass_tool_core::encrypted_sync::*;
use x25519_dalek::{EphemeralSecret, PublicKey};

#[test]
fn test_encrypt_decrypt_sync_payload() {
    let payload = b"Test sync payload";
    let shared_key = [0u8; 32]; // Example shared key (all zeros for simplicity)

    // Encrypt the payload
    let (nonce_b64, ciphertext_b64) =
        encrypt_sync_payload(payload, &shared_key).expect("Encryption failed");

    // Decrypt the payload
    let decrypted_payload =
        decrypt_sync_payload(&nonce_b64, &ciphertext_b64, &shared_key).expect("Decryption failed");

    // Ensure the decrypted payload matches the original
    assert_eq!(decrypted_payload, payload);
}

#[test]
fn test_encrypt_sync_payload_invalid_key_length() {
    let payload = b"Test sync payload";
    let invalid_key = [0u8; 16]; // Invalid key length (16 bytes instead of 32)

    // Attempt to encrypt with an invalid key length
    let result = encrypt_sync_payload(payload, &invalid_key);

    // Ensure the result is an error
    assert!(result.is_err());
    assert_eq!(
        result.unwrap_err(),
        "Invalid shared key length: must be 32 bytes".to_string()
    );
}

#[test]
fn test_decrypt_sync_payload_invalid_nonce() {
    let payload = b"Test sync payload";
    let shared_key = [0u8; 32]; // Example shared key (all zeros for simplicity)

    // Encrypt the payload
    let (_, ciphertext_b64) =
        encrypt_sync_payload(payload, &shared_key).expect("Encryption failed");

    // Corrupt the nonce
    let invalid_nonce_b64 = "invalid_nonce";

    // Attempt to decrypt with an invalid nonce
    let result = decrypt_sync_payload(invalid_nonce_b64, &ciphertext_b64, &shared_key);

    // Ensure the result is an error
    assert!(result.is_err());
    assert_eq!(
        result.unwrap_err(),
        "Invalid Base64 encoding for nonce".to_string()
    );
}

#[test]
fn test_decrypt_sync_payload_invalid_ciphertext() {
    let payload = b"Test sync payload";
    let shared_key = [0u8; 32]; // Example shared key (all zeros for simplicity)

    // Encrypt the payload
    let (nonce_b64, _) = encrypt_sync_payload(payload, &shared_key).expect("Encryption failed");

    // Corrupt the ciphertext
    let invalid_ciphertext_b64 = "invalid_ciphertext";

    // Attempt to decrypt with an invalid ciphertext
    let result = decrypt_sync_payload(&nonce_b64, invalid_ciphertext_b64, &shared_key);

    // Ensure the result is an error
    assert!(result.is_err());
    assert_eq!(
        result.unwrap_err(),
        "Invalid Base64 encoding for ciphertext".to_string()
    );
}

#[test]
fn test_derive_shared_key() {
    // Generate two X25519 key pairs
    let private_key1 = EphemeralSecret::random_from_rng(&mut OsRng);
    let public_key1 = PublicKey::from(&private_key1);

    let private_key2 = EphemeralSecret::random_from_rng(&mut OsRng);
    let public_key2 = PublicKey::from(&private_key2);

    // Derive shared keys
    let shared_key1 = derive_shared_key(private_key1, public_key2);
    let shared_key2 = derive_shared_key(private_key2, public_key1);

    // Ensure the shared keys are identical
    assert_eq!(shared_key1, shared_key2);
}
