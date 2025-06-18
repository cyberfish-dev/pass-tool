use crate::api::vault_models::{EntryCategory, VaultMetadataVault};

#[flutter_rust_bridge::frb(sync)]
pub fn create_empty_vault_manager() -> VaultManager {
    VaultManager::default()
}

#[flutter_rust_bridge::frb(non_opaque)]
pub type VaultMetadataVaultAlias = VaultMetadataVault;

#[flutter_rust_bridge::frb(opaque)]
pub struct VaultManager {
    vault: VaultMetadataVault,
}

#[flutter_rust_bridge::frb(opaque)]
impl VaultManager {
    #[flutter_rust_bridge::frb(sync)]
    pub fn add_folder(&mut self, name: String) {
        self.vault.add_folder(name);
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn remove_folder(&mut self, id: String) -> bool {
        self.vault.remove_folder_by_id(&id)
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
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn get_metadata(&self) -> VaultMetadataVaultAlias {
        self.vault.clone()
    }
}

impl Default for VaultManager {
    fn default() -> Self {
        Self {
            vault: VaultMetadataVault::default(),
        }
    }
}
