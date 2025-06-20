use std::collections::HashMap;

use serde::{Deserialize, Serialize};

#[flutter_rust_bridge::frb(opaque)]
#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct VaultMetadataVault {
    pub entries: Vec<VaultMetadataEntry>,

    pub folders: Vec<Folder>,
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

#[derive(Serialize, Deserialize, Clone, Debug, PartialEq, Eq)]
pub struct Folder {
    pub id: String,
    pub name: String,
}

#[derive(Serialize, Deserialize, Clone, Debug, PartialEq, Eq, Hash)]
pub enum EntryCategory {
    Login,
    SecureNote,
    CreditCard,
}

pub trait VaultPayload: Serialize {
    fn category() -> EntryCategory;
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct LoginRecord {
    pub username: String,
    pub password: String,
    pub website: Option<String>,
}

impl VaultPayload for LoginRecord {
    fn category() -> EntryCategory {
        EntryCategory::Login
    }
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct SecureNoteRecord {
    pub note: String,
}

impl VaultPayload for SecureNoteRecord {
    fn category() -> EntryCategory {
        EntryCategory::SecureNote
    }
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct CreditCardRecord {
    pub number: String,
    pub name: String,
    pub exp_month: String,
    pub exp_year: String,
    pub cvv: String
}

impl VaultPayload for CreditCardRecord {
    fn category() -> EntryCategory {
        EntryCategory::CreditCard
    }
}