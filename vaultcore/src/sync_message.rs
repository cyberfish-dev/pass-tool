use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize, Debug)]
pub struct SyncMessage {
    pub vault_id: String,
    pub device_id: String,
    pub timestamp: u64,
    pub payload_b64: String,
    pub signature: String, // Base64 signature of payload
}
