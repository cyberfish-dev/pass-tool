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
    pub android_packages: Vec<String>,
    pub websites: Vec<SiteMapping>,
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

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct SiteMapping {
    pub url: String,
    pub match_type: MatchType,
}

#[derive(Serialize, Deserialize, Clone, Debug, PartialEq, Eq, Hash)]
pub enum MatchType {
    Default,
    BaseDomain,
    Host,
    StartsWith,
    Exact,
    Regexp,
    Never,
}

pub trait VaultPayload: Serialize {
    fn category() -> EntryCategory;
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct LoginRecord {
    pub username: String,
    pub password: String,
    pub totp: Option<TOTPConfig>,
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
    pub brand: String,
    pub exp_month: String,
    pub exp_year: String,
    pub cvv: String,
}

impl VaultPayload for CreditCardRecord {
    fn category() -> EntryCategory {
        EntryCategory::CreditCard
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TOTPConfig {
    pub secret: String, // Base32 encoded
    pub period: u32,    // Default 30 seconds
    pub digits: u8,     // Usually 6
    pub algorithm: TOTPAlgorithm,
    pub issuer: Option<String>,
    pub account_name: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum TOTPAlgorithm {
    SHA1,
    SHA256,
    SHA512,
}
