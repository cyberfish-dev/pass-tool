use pass_tool_core::vault_fingerprint::*;
use pass_tool_core::vault::*;

#[test]
fn test_fingerprint_vault_success() {
    // Create a sample Vault object
    let vault = Vault::new(); // Assuming `Vault::new()` initializes an empty vault

    // Compute the fingerprint
    let fingerprint = fingerprint_vault(&vault).expect("Failed to compute fingerprint");

    // Ensure the fingerprint is not empty
    assert!(!fingerprint.is_empty(), "Fingerprint should not be empty");
}

#[test]
fn test_fingerprint_vault_deterministic() {
    // Create two logically equivalent Vault objects
    let vault1 = Vault::new(); // Assuming `Vault::new()` initializes an empty vault
    let vault2 = Vault::new();

    // Compute fingerprints for both vaults
    let fingerprint1 = fingerprint_vault(&vault1).expect("Failed to compute fingerprint");
    let fingerprint2 = fingerprint_vault(&vault2).expect("Failed to compute fingerprint");

    // Ensure the fingerprints are identical
    assert_eq!(
        fingerprint1, fingerprint2,
        "Fingerprints of equivalent vaults should match"
    );
}
