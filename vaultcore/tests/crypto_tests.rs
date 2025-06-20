use aes_gcm::{Aes256Gcm, KeyInit};
use pass_tool_core::api::crypto::*;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, PartialEq, Debug, Clone)]
struct DummyPayload {
    foo: String,
    bar: i32,
}

#[test]
fn test_generate_salt_length_and_randomness() {
    let salt1 = generate_salt();
    let salt2 = generate_salt();
    assert_eq!(salt1.len(), 16);
    assert_eq!(salt2.len(), 16);
    assert_ne!(salt1, salt2, "Salts should be random and unique");
}

#[test]
fn test_generate_submaster_key_length_and_randomness() {
    let key1 = generate_submaster_key();
    let key2 = generate_submaster_key();
    assert_eq!(key1.len(), 32);
    assert_eq!(key2.len(), 32);
    assert_ne!(key1, key2, "Submaster keys should be random and unique");
}

#[test]
fn test_derive_master_key_and_split() {
    let password = "test-password";
    let salt = generate_salt();
    let master_key = derive_master_key(password, &salt).unwrap();
    assert_eq!(master_key.len(), 64);

    let (enc_key, mac_key) = split_master_key(&master_key);
    assert_eq!(enc_key.len(), 32);
    assert_eq!(mac_key.len(), 32);
    assert_ne!(enc_key, mac_key, "Encryption and MAC keys should differ");
}

#[test]
fn test_derive_master_key_invalid_salt() {
    let password = "test-password";
    let bad_salt = [0u8; 8];
    let result = derive_master_key(password, &bad_salt);
    assert!(matches!(result, Err(CryptoError::InvalidSalt)));
}

#[test]
fn test_encrypt_and_decrypt_it_roundtrip() {
    let key = generate_submaster_key();
    let data = b"super secret data";
    let aad = b"test aad";

    let encrypted = encrypt_it(data, &key, aad).unwrap();
    let decrypted = decrypt_it(&encrypted, &key, aad).unwrap();

    assert_eq!(decrypted.as_slice(), data);
}

#[test]
fn test_encrypt_it_invalid_key_length() {
    let key = [0u8; 31]; // Invalid key length
    let result = Aes256Gcm::new_from_slice(&key);
    assert!(result.is_err());
}

#[test]
fn test_decrypt_it_invalid_format() {
    let key = generate_submaster_key();
    let aad = b"aad";
    let result = decrypt_it(&[], &key, aad);
    assert!(matches!(
        result,
        Err(CryptoError::InvalidEncryptedKeyFormat)
    ));
}

#[test]
fn test_encrypt_payload_and_decrypt_payload_roundtrip() {
    let password = "vault-password";
    let salt = generate_salt();
    let master_key = derive_master_key(password, &salt).unwrap();
    let (enc_key, _) = split_master_key(&master_key);

    let payload = DummyPayload {
        foo: "hello".to_string(),
        bar: 42,
    };

    let encrypted = encrypt_payload(payload.clone(), &enc_key).unwrap();
    let decrypted: DummyPayload = decrypt_payload(&encrypted, &enc_key).unwrap();
    assert_eq!(payload, decrypted);
}

#[test]
fn test_encrypt_payload_with_wrong_key_fails() {
    let password = "vault-password";
    let salt = generate_salt();
    let master_key = derive_master_key(password, &salt).unwrap();
    let (enc_key, _) = split_master_key(&master_key);

    let payload = DummyPayload {
        foo: "hello".to_string(),
        bar: 42,
    };

    let encrypted = encrypt_payload(payload.clone(), &enc_key).unwrap();

    // Use a different key for decryption
    let wrong_key = generate_submaster_key();
    let result: Result<DummyPayload, _> = decrypt_payload(&encrypted, &wrong_key);
    assert!(result.is_err());
}

#[test]
fn test_encrypt_payload_and_decrypt_payload_with_modified_aad_fails() {
    let password = "vault-password";
    let salt = generate_salt();
    let master_key = derive_master_key(password, &salt).unwrap();
    let (enc_key, _) = split_master_key(&master_key);

    let payload = DummyPayload {
        foo: "hello".to_string(),
        bar: 42,
    };

    let encrypted = encrypt_payload(payload.clone(), &enc_key).unwrap();

    // Tamper with the created_at timestamp in the JSON (AAD)
    let mut record: EncryptedRecordFile = serde_json::from_slice(&encrypted).unwrap();
    record.created_at += 1; // Change the AAD
    let tampered = serde_json::to_vec(&record).unwrap();

    let result: Result<DummyPayload, _> = decrypt_payload(&tampered, &enc_key);
    assert!(result.is_err());
}
