use std::collections::HashMap;

use serde::{Serialize, Deserialize};

#[flutter_rust_bridge::frb(opaque)]
#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct VaultMetadataVault {
    pub entries: Vec<VaultMetadataEntry>,
    
    pub folder_counts: HashMap<String, usize>,
    pub category_counts: HashMap<EntryCategory, usize>,
    pub trashed_count: usize,
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct VaultMetadataEntry {
    pub id: String,               
    pub name: String,            
    pub category: EntryCategory,
    pub folder: Option<String>,
    pub updated_at: i64,
    pub version: u32,
    pub is_trashed: bool,
    pub icon: Option<String>,
}

#[derive(Serialize, Deserialize, Clone, Debug, PartialEq, Eq, Hash)]
pub enum EntryCategory {
    Login,
    SecureNote,
    CreditCard,
}