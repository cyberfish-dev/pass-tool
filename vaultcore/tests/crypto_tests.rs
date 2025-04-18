use vaultcore::crypto::{encrypt_entry, decrypt_entry, generate_key};

#[test]
fn test_encrypt_decrypt_success() {
    let plaintext = b"Sensitive data";
    let associated_data = b"example-context";

    // Encrypt the plaintext
    let (nonce_b64, ciphertext_b64, key) =
        encrypt_entry(plaintext, Some(associated_data)).expect("Encryption failed");

    // Decrypt the ciphertext
    let decrypted = decrypt_entry(&key, &nonce_b64, &ciphertext_b64, Some(associated_data))
        .expect("Decryption failed");

    // Verify that the decrypted text matches the original plaintext
    assert_eq!(decrypted, plaintext);
}

#[test]
fn test_encrypt_decrypt_without_associated_data() {
    let plaintext = b"Sensitive data";

    // Encrypt the plaintext without associated data
    let (nonce_b64, ciphertext_b64, key) =
        encrypt_entry(plaintext, None).expect("Encryption failed");

    // Decrypt the ciphertext without associated data
    let decrypted = decrypt_entry(&key, &nonce_b64, &ciphertext_b64, None)
        .expect("Decryption failed");

    // Verify that the decrypted text matches the original plaintext
    assert_eq!(decrypted, plaintext);
}

#[test]
fn test_decrypt_with_wrong_key() {
    let plaintext = b"Sensitive data";
    let associated_data = b"example-context";

    // Encrypt the plaintext
    let (nonce_b64, ciphertext_b64, _) =
        encrypt_entry(plaintext, Some(associated_data)).expect("Encryption failed");

    // Generate a different key
    let wrong_key = generate_key();

    // Attempt to decrypt with the wrong key
    let result = decrypt_entry(&wrong_key, &nonce_b64, &ciphertext_b64, Some(associated_data));

    // Verify that decryption fails
    assert!(result.is_err());
}

#[test]
fn test_decrypt_with_wrong_associated_data() {
    let plaintext = b"Sensitive data";
    let associated_data = b"example-context";

    // Encrypt the plaintext
    let (nonce_b64, ciphertext_b64, key) =
        encrypt_entry(plaintext, Some(associated_data)).expect("Encryption failed");

    // Attempt to decrypt with different associated data
    let wrong_associated_data = b"wrong-context";
    let result =
        decrypt_entry(&key, &nonce_b64, &ciphertext_b64, Some(wrong_associated_data));

    // Verify that decryption fails
    assert!(result.is_err());
}

#[test]
fn test_decrypt_with_corrupted_ciphertext() {
    let plaintext = b"Sensitive data";
    let associated_data = b"example-context";

    // Encrypt the plaintext
    let (nonce_b64, mut ciphertext_b64, key) =
        encrypt_entry(plaintext, Some(associated_data)).expect("Encryption failed");

    // Corrupt the ciphertext by modifying it
    ciphertext_b64.push('A');

    // Attempt to decrypt the corrupted ciphertext
    let result = decrypt_entry(&key, &nonce_b64, &ciphertext_b64, Some(associated_data));

    // Verify that decryption fails
    assert!(result.is_err());
}