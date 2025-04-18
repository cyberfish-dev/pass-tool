use vaultcore::device_keys::*;
use vaultcore::sync_message::SyncMessage;
use base64::{engine::general_purpose::STANDARD, Engine as _};

#[test]
fn test_keypair_generation_and_encoding() {
    let (_, pk) = generate_keypair();
    let encoded = encode_public_key(&pk);
    let decoded = decode_public_key(&encoded).unwrap();
    assert_eq!(pk.to_bytes(), decoded.to_bytes());
}

#[test]
fn test_sign_and_verify_sync_message() {
    let (sk, pk) = generate_keypair();
    let message = b"This is a sync payload";

    let sig_b64 = sign_message(&sk, message);
    assert!(verify_signature(&pk, message, &sig_b64));
}

#[test]
fn test_sync_message_serialization_and_verification() {
    let (sk, pk) = generate_keypair();

    let payload = b"{\"entry\":\"encrypted-data\"}";
    let payload_b64 = STANDARD.encode(payload);
    let sig_b64 = sign_message(&sk, payload);

    let msg = SyncMessage {
        vault_id: "vault-xyz".to_string(),
        device_id: "dev-123".to_string(),
        timestamp: 1712345678,
        payload_b64: payload_b64.clone(),
        signature: sig_b64.clone(),
    };

    let json = serde_json::to_string(&msg).unwrap();
    let decoded: SyncMessage = serde_json::from_str(&json).unwrap();

    let verified = verify_signature(&pk, &STANDARD.decode(&decoded.payload_b64).unwrap(), &decoded.signature);
    assert!(verified);
}
