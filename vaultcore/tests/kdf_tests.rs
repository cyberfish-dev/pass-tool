use pass_tool_core::kdf::derive_key;
use argon2::password_hash::SaltString;

#[test]
fn test_derive_key_with_provided_salt() {
    let password = "test_password";
    let salt = b"fixed_salt_12345678"; // 16 bytes

    let result = derive_key(password, Some(salt));
    assert!(result.is_ok());

    let (key, salt_str) = result.unwrap();
    assert_eq!(salt_str, SaltString::encode_b64(salt).unwrap().to_string());
    assert_eq!(key.len(), 32); // Ensure key is 32 bytes
}


#[test]
fn test_derive_key_with_generated_salt() {
    let password = "test_password";

    let result = derive_key(password, None);
    assert!(result.is_ok());

    let (key, salt_str) = result.unwrap();
    assert_eq!(key.len(), 32); // Ensure key is 32 bytes

    // Decode the generated salt to ensure it's valid base64
    assert!(SaltString::encode_b64(salt_str.as_bytes()).is_ok());
}

#[test]
fn test_derive_key_invalid_salt() {
    let password = "test_password";
    let invalid_salt = b"short"; // Less than 16 bytes

    let result = derive_key(password, Some(invalid_salt));
    assert!(result.is_err());
    assert_eq!(result.unwrap_err(), "Argon2 hashing failed");
}

#[test]
fn test_derive_key_empty_password() {
    let password = "";
    let salt = b"fixed_salt_12345678"; // 16 bytes

    let result = derive_key(password, Some(salt));
    assert!(result.is_ok());

    let (key, salt_str) = result.unwrap();
    assert_eq!(salt_str, SaltString::encode_b64(salt).unwrap().to_string()); // Ensure salt is correctly encoded
    assert_eq!(key.len(), 32); // Ensure key is 32 bytes
}

#[test]
fn test_derive_key_consistency_with_same_salt() {
    let password = "test_password";
    let salt = b"fixed_salt_12345678"; // 16 bytes

    let result1 = derive_key(password, Some(salt));
    let result2 = derive_key(password, Some(salt));

    assert!(result1.is_ok());
    assert!(result2.is_ok());

    let (key1, _) = result1.unwrap();
    let (key2, _) = result2.unwrap();

    assert_eq!(key1, key2); // Ensure derived keys are the same
}

#[test]
fn test_derive_key_different_salts_produce_different_keys() {
    let password = "test_password";
    let salt1 = b"fixed_salt_12345678"; // 16 bytes
    let salt2 = b"another_salt_87654321"; // 16 bytes

    let result1 = derive_key(password, Some(salt1));
    let result2 = derive_key(password, Some(salt2));

    assert!(result1.is_ok());
    assert!(result2.is_ok());

    let (key1, _) = result1.unwrap();
    let (key2, _) = result2.unwrap();

    assert_ne!(key1, key2); // Ensure derived keys are different
}