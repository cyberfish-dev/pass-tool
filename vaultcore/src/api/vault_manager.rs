use std::{fs, io};

use zeroize::Zeroize;

use crate::api::crypto::{
    decrypt_payload, derive_master_key, encrypt_payload, generate_salt, split_master_key,
    CryptoError,
};
use crate::api::vault_models::{
    CreditCardRecord, Folder, LoginRecord, SecureNoteRecord, VaultMetadataVault,
    VaultPayload,
};

/// Custom error type for vault manager operations.
#[derive(Debug)]
pub enum VaultManagerError {
    Io(io::Error),
    Crypto(CryptoError),
    VaultCorrupted,
    IncorrectPassword,
    Serialization(serde_json::Error),
    Other(String),
}

impl std::fmt::Display for VaultManagerError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        use VaultManagerError::*;
        match self {
            Io(e) => write!(f, "File system error: {}", e),
            Crypto(e) => write!(f, "Crypto error: {}", e),
            VaultCorrupted => write!(f, "Vault data is corrupted or missing."),
            IncorrectPassword => write!(f, "Incorrect password or vault data is corrupted."),
            Serialization(e) => write!(f, "Serialization error: {}", e),
            Other(msg) => write!(f, "{}", msg),
        }
    }
}

impl std::error::Error for VaultManagerError {}

impl From<io::Error> for VaultManagerError {
    fn from(e: io::Error) -> Self {
        VaultManagerError::Io(e)
    }
}
impl From<CryptoError> for VaultManagerError {
    fn from(e: CryptoError) -> Self {
        VaultManagerError::Crypto(e)
    }
}
impl From<serde_json::Error> for VaultManagerError {
    fn from(e: serde_json::Error) -> Self {
        VaultManagerError::Serialization(e)
    }
}

#[flutter_rust_bridge::frb(sync)]
pub fn create_vault_manager(
    root_path: String,
    password: &str,
) -> Result<VaultManager, VaultManagerError> {
    let salt_path = format!("{}/salt.key", root_path);
    let data_path = format!("{}/vault_metadata.dat", root_path);

    let salt_exists = fs::metadata(&salt_path).is_ok();
    let data_exists = fs::metadata(&data_path).is_ok();

    if salt_exists && data_exists {
        // Load existing vault
        let file_salt = fs::read(&salt_path)?;
        let file_data = fs::read(&data_path)?;

        let mut master_key = derive_master_key(password, &file_salt).map_err(|e| match e {
            CryptoError::InvalidSalt => VaultManagerError::VaultCorrupted,
            _ => VaultManagerError::IncorrectPassword,
        })?;

        let (enc_key, _) = split_master_key(&master_key);

        let vault = decrypt_payload(&file_data, &enc_key).map_err(|e| match e {
            CryptoError::AesGcm(_) => VaultManagerError::IncorrectPassword,
            CryptoError::Base64(_) | CryptoError::SerdeJson(_) => VaultManagerError::VaultCorrupted,
            _ => VaultManagerError::Crypto(e),
        })?;

        // Ensure the master key is zeroed out after use
        master_key.zeroize();

        return Ok(VaultManager {
            root_path,
            enc_key,
            vault,
        });
    }

    // Create new vault
    let salt = generate_salt();
    let mut master_key = derive_master_key(password, &salt)?;
    let (enc_key, _) = split_master_key(&master_key);

    let vault = VaultMetadataVault::default();
    let encrypted_record = encrypt_payload(vault.clone(), &enc_key)?;

    // Ensure the master key is zeroed out after use
    master_key.zeroize();

    // Save salt and encrypted vault
    fs::create_dir_all(&root_path)?;
    fs::write(&salt_path, &salt)?;
    fs::write(&data_path, &encrypted_record)?;

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
    pub fn add_folder(&mut self, name: String) -> Result<Folder, VaultManagerError> {
        let folder = self.vault.add_folder(name);
        self.update_vault_meta()?;

        Ok(folder)
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn remove_folder(&mut self, id: String) -> Result<bool, VaultManagerError> {
        let result = self.vault.remove_folder_by_id(&id);
        self.update_vault_meta()?;

        Ok(result)
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn add_login_record(
        &mut self,
        name: String,
        folder: Option<String>,
        icon: Option<String>,
        record: LoginRecord,
    ) -> Result<(), VaultManagerError> {
        self.add_generic_entry(name, folder, icon, &record)
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn add_note_record(
        &mut self,
        name: String,
        folder: Option<String>,
        icon: Option<String>,
        record: SecureNoteRecord,
    ) -> Result<(), VaultManagerError> {
        self.add_generic_entry(name, folder, icon, &record)
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn add_credit_card_record(
        &mut self,
        name: String,
        folder: Option<String>,
        icon: Option<String>,
        record: CreditCardRecord,
    ) -> Result<(), VaultManagerError> {
        self.add_generic_entry(name, folder, icon, &record)
    }

    fn add_generic_entry<T: VaultPayload>(
        &mut self,
        name: String,
        folder: Option<String>,
        icon: Option<String>,
        payload: &T,
    ) -> Result<(), VaultManagerError> {
        let encrypted = encrypt_payload(payload, &self.enc_key)?;
        let record_id = self.vault.add_entry(name, T::category(), folder, icon);

        fs::write(
            format!("{}/records/{}.dat", self.root_path, record_id),
            encrypted,
        )?;

        self.update_vault_meta();

        Ok(())
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn get_metadata(&self) -> VaultMetadataVaultAlias {
        self.vault.clone()
    }

    fn update_vault_meta(&mut self) -> Result<(), VaultManagerError> {
        let encrypted_record = encrypt_payload(self.vault.clone(), &self.enc_key)
            .map_err(VaultManagerError::Crypto)?;

        let data_path = format!("{}/vault_metadata.dat", self.root_path);
        fs::write(&data_path, &encrypted_record).map_err(VaultManagerError::Io)?;

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
