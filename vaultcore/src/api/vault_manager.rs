use std::fs;

use crate::api::crypto::{
    decrypt_payload, derive_master_key, encrypt_payload, generate_salt, split_master_key,
};
use crate::api::vault_models::{EntryCategory, VaultMetadataVault};

#[flutter_rust_bridge::frb(sync)]
pub fn create_vault_manager(root_path: String, password: &str) -> Result<VaultManager, String> {
    let salt_path = format!("{}/salt.key", root_path);
    let data_path = format!("{}/vault_metadata.dat", root_path);

    if fs::metadata(&salt_path).is_ok() && fs::metadata(&data_path).is_ok() {
        // Load existing vault
        let file_salt = fs::read(&salt_path).map_err(|e| e.to_string())?;
        let file_data = fs::read(&data_path).map_err(|e| e.to_string())?;

        let master_key = derive_master_key(password, &file_salt)?;
        let (enc_key, _) = split_master_key(&master_key);

        let decrypted_json = decrypt_payload(&file_data, &enc_key)?;
        let vault: VaultMetadataVault = serde_json::from_slice(&decrypted_json)
            .map_err(|e| format!("Failed to parse decrypted vault: {}", e))?;

        return Ok(VaultManager {
            root_path,
            enc_key,
            vault,
        });
    }

    // Create new vault
    let salt = generate_salt();
    let master_key = derive_master_key(password, &salt)?;
    let (enc_key, _) = split_master_key(&master_key);

    let vault = VaultMetadataVault::default();
    let vault_json = serde_json::to_vec(&vault).map_err(|e| e.to_string())?;
    let encrypted_record = encrypt_payload(vault_json, &enc_key)?;

    // Save salt and encrypted vault
    fs::create_dir_all(&root_path).map_err(|e| e.to_string())?;
    fs::write(&salt_path, &salt).map_err(|e| e.to_string())?;
    fs::write(&data_path, &encrypted_record).map_err(|e| e.to_string())?;

    Ok(VaultManager {
        root_path,
        enc_key,
        vault,
    })
}

#[flutter_rust_bridge::frb(non_opaque)]
pub type VaultMetadataVaultAlias = VaultMetadataVault;

#[flutter_rust_bridge::frb(opaque)]
pub struct VaultManager {
    root_path: String,
    enc_key: [u8; 32],
    vault: VaultMetadataVault,
}

#[flutter_rust_bridge::frb(opaque)]
impl VaultManager {
    #[flutter_rust_bridge::frb(sync)]
    pub fn add_folder(&mut self, name: String) {
        self.vault.add_folder(name);
        self.update_vault();
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn remove_folder(&mut self, id: String) {
        self.vault.remove_folder_by_id(&id);
        self.update_vault();
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn add_entry(
        &mut self,
        name: String,
        category: EntryCategory,
        folder: Option<String>,
        icon: Option<String>,
    ) {
        self.vault.add_entry(name, category, folder, icon);
        self.update_vault().unwrap_or_else(|e| {
            eprintln!("Failed to update vault: {}", e);
        });
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn get_metadata(&self) -> VaultMetadataVaultAlias {
        self.vault.clone()
    }

    fn update_vault(&mut self) -> Result<(), String> {
        let vault_json = serde_json::to_vec(&self.vault).map_err(|e| e.to_string())?;
        let encrypted_record = encrypt_payload(vault_json, &self.enc_key)?;

        let data_path = format!("{}/vault_metadata.dat", self.root_path);
        fs::write(&data_path, &encrypted_record).map_err(|e| e.to_string())?;

        Ok(())
    }
}

impl Default for VaultManager {
    fn default() -> Self {
        Self {
            root_path: String::new(),
            enc_key: [0; 32],
            vault: VaultMetadataVault::default(),
        }
    }
}
