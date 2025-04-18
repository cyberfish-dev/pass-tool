use argon2::{
    password_hash::{PasswordHasher, SaltString},
    Argon2, Params,
};

/// Derives a 256-bit (32-byte) encryption key from a password using Argon2id.
/// - If `salt` is provided, it's used; otherwise a random salt is generated.
/// - Returns the derived key and the (possibly generated) base64-encoded salt.
pub fn derive_key(password: &str, salt: Option<&[u8]>) -> Result<([u8; 32], String), String> {
    // Use secure Argon2id configuration
    let params = Params::new(65536, 4, 1, Some(32))
        .map_err(|_| "Invalid Argon2 parameters".to_string())?;

    let argon2 = Argon2::new(argon2::Algorithm::Argon2id, argon2::Version::V0x13, params);

    // Generate or use provided salt
    let salt_str = match salt {
        Some(bytes) => SaltString::encode_b64(bytes)
            .map_err(|_| "Invalid salt bytes".to_string())?,
        None => SaltString::generate(rand_core::OsRng),
    };

    // Perform key derivation
    let hash = argon2
        .hash_password(password.as_bytes(), &salt_str)
        .map_err(|_| "Argon2 hashing failed".to_string())?
        .hash
        .ok_or("Missing hash output in Argon2 result".to_string())?;

    // Extract the raw bytes from the hash (already 32 bytes)
    let bytes = hash.as_bytes();

    if bytes.len() < 32 {
        return Err("Derived hash is shorter than 32 bytes.".into());
    }

    let mut key = [0u8; 32];
    key.copy_from_slice(&bytes[..32]);

    Ok((key, salt_str.to_string()))
}
