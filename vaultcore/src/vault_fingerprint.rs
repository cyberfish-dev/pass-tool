use sha2::{Sha256, Digest};
use crate::vault::Vault;
use serde_json;

/// Computes a SHA-256 fingerprint of the vault.
/// The vault must be in a deterministic serialized form (e.g., sorted).
pub fn fingerprint_vault(vault: &Vault) -> Result<String, String> {
    // Serialize the vault to JSON
    let serialized = serde_json::to_string(vault)
        .map_err(|_| "Vault serialization failed".to_string())?;

    // Compute the SHA-256 hash
    let hash = Sha256::digest(serialized.as_bytes());

    // Return the hex-encoded hash
    Ok(hex::encode(hash))
}