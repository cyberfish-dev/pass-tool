use std::collections::HashMap;

use chrono::Utc;
use uuid::Uuid;

use crate::api::vault_models::{EntryCategory, Folder, VaultMetadataEntry, VaultMetadataVault};

impl VaultMetadataVault {
    pub fn add_entry(
        &mut self,
        name: String,
        category: EntryCategory,
        folder: Option<String>,
        icon: Option<String>,
    ) -> String {
        let entry = VaultMetadataEntry {
            id: Uuid::new_v4().to_string(),
            name,
            category,
            folder,
            updated_at: Utc::now().timestamp(),
            version: 1,
            is_trashed: false,
            icon,
            websites: Vec::new(),
            android_packages: Vec::new(),
        };

        self.entries.push(entry.clone());
        self.recalculate_counts();

        entry.id
    }

    pub fn update_entry(
        &mut self,
        id: &str,
        name: String,
        folder: Option<String>,
        icon: Option<String>,
        is_trashed: bool,
    ) -> bool {
        if let Some(entry) = self.entries.iter_mut().find(|e| e.id == id) {
            entry.name = name;
            entry.folder = folder;
            entry.icon = icon;
            entry.is_trashed = is_trashed;
            entry.updated_at = Utc::now().timestamp();
            entry.version += 1;

            self.recalculate_counts();

            return true;
        }

        return false;
    }

    pub fn add_folder(&mut self, name: String) -> Folder {
        let folder = Folder {
            id: Uuid::new_v4().to_string(),
            name,
        };

        self.folders.push(folder.clone());
        folder
    }

    pub fn remove_folder_by_id(&mut self, folder_id: &str) -> bool {
        let before = self.folders.len();
        self.folders.retain(|f| f.id != folder_id);

        // Remove folder reference from all entries
        for entry in &mut self.entries {
            if let Some(ref id) = entry.folder {
                if id == folder_id {
                    entry.folder = None;
                }
            }
        }

        self.recalculate_counts();
        self.folders.len() < before
    }

    pub fn recalculate_counts(&mut self) {
        let mut folder_counts: HashMap<String, usize> = HashMap::new();
        let mut category_counts: HashMap<EntryCategory, usize> = HashMap::new();
        let mut trashed_count = 0;

        for entry in &self.entries {
            if entry.is_trashed {
                trashed_count += 1;
                continue;
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
            folders: Vec::new(),
            folder_counts: HashMap::new(),
            category_counts: HashMap::new(),
            trashed_count: 0,
        }
    }
}
