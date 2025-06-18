use std::collections::HashMap;

use chrono::Utc;
use uuid::Uuid;

use crate::api::vault_models::{EntryCategory, VaultMetadataEntry, VaultMetadataVault};

#[flutter_rust_bridge::frb(sync)]
pub fn create_empty_vault() -> VaultMetadataVaultAlias {
    VaultMetadataVaultAlias::default()
}

#[flutter_rust_bridge::frb(sync)]
pub fn add_entry_to_vault(
    vault: VaultMetadataVaultAlias,
    name: String,
    category: EntryCategory,
    folder: Option<String>,
    icon: Option<String>,
) -> VaultMetadataVaultAlias {
    vault.add_entry(name, category, folder, icon)
}

#[flutter_rust_bridge::frb(non_opaque)]
pub type VaultMetadataVaultAlias = VaultMetadataVault;

impl VaultMetadataVault {
    pub fn add_entry(
        mut self,
        name: String,
        category: EntryCategory,
        folder: Option<String>,
        icon: Option<String>,
    ) -> Self {
        let entry = VaultMetadataEntry {
            id: Uuid::new_v4().to_string(),
            name,
            category,
            folder,
            updated_at: Utc::now().timestamp(),
            version: 1,
            is_trashed: false,
            icon,
        };

        self.entries.push(entry.clone());
        self.recalculate_counts();
        self
    }

    pub fn recalculate_counts(&mut self) {
        let mut folder_counts: HashMap<String, usize> = HashMap::new();
        let mut category_counts: HashMap<EntryCategory, usize> = HashMap::new();
        let mut trashed_count = 0;

        for entry in &self.entries {
            if entry.is_trashed {
                trashed_count += 1;
            }

            if let Some(folder) = &entry.folder {
                *folder_counts.entry(folder.clone()).or_insert(0) += 1;
            }

            *category_counts.entry(entry.category.clone()).or_insert(0) += 1;
        }

        self.folder_counts = folder_counts;
        self.category_counts = category_counts;
        self.trashed_count = trashed_count;
    }
}

impl Default for VaultMetadataVault {
    fn default() -> Self {
        Self {
            entries: Vec::new(),
            folder_counts: HashMap::new(),
            category_counts: HashMap::new(),
            trashed_count: 0,
        }
    }
}
