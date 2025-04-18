use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize, Clone)]
pub struct VaultMetadata {
    pub vault_id: String,
    pub created_at: u64,
    pub kdf_salt: String,
    pub kdf_algo: String,
    pub cipher_algo: String,
}

#[derive(Serialize, Deserialize, Clone)]
pub struct EncryptedEntry {
    pub id: String,
    pub nonce: String,
    pub ciphertext: String,
    pub created_at: u64,
    pub updated_at: u64,
    pub source: String,
}

#[derive(Serialize, Deserialize, Clone)]
pub struct Vault {
    pub metadata: VaultMetadata,
    pub entries: Vec<EncryptedEntry>,
}

impl Vault {
    pub fn new() -> Self {
        Vault {
            metadata: VaultMetadata {
                vault_id: String::new(),
                created_at: 0,
                kdf_salt: String::new(),
                kdf_algo: String::new(),
                cipher_algo: String::new(),
            },
            entries: Vec::new(),
        }
    }
}

#[derive(Serialize, Deserialize)]
pub struct VaultPlainEntry {
    pub id: String,
    pub source: String,
    pub username: String,
    pub password: String,
    pub notes: String,
    pub web_url: String,
    pub app_name: String,
    pub created_at: u64,
    pub updated_at: u64,
}
