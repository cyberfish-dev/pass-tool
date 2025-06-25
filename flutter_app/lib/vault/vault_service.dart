import 'package:flutter_app/models/record_base.dart';
import 'package:pass_tool_core/pass_tool_core.dart';
import 'package:path_provider/path_provider.dart';

// TODO: properly handle errors and exceptions

class VaultService {
  VaultManager? _vault;
  static final VaultService _instance = VaultService._internal();
  static bool _metaDirty = true;

  static VaultMetadataVault? _vaultMeta;

  VaultService._internal();

  static Future initVault() async {
    await _instance.init();
  }

  static VaultMetadataVault fetchMeta() {
    if (_vaultMeta == null || _metaDirty) {
      final metadata = _instance.vault.getMetadata();
      _vaultMeta = metadata;

      _metaDirty = false;
    }

    return _vaultMeta!;
  }

  static void addFolder(String name) {
    _instance.vault.addFolder(name: name);
    _metaDirty = true;
  }

  static void addCreditCard(RecordBase<CreditCardRecord> record) {
    _instance.vault.addCreditCardRecord(
      name: record.itemName,
      record: record.data,
      folder: record.folder,
      icon: record.icon,
    );
    _metaDirty = true;
  }

  static void updateCreditCard(
    String itemId,
    RecordBase<CreditCardRecord> record,
  ) {
    _instance.vault.updateCreditCardRecord(
      recordId: itemId,
      name: record.itemName,
      record: record.data,
      folder: record.folder,
      icon: record.icon,
      isTrashed: record.isTrashed,
    );
    _metaDirty = true;
  }

  static CreditCardRecord getCreditCard(String itemId) {
    return _instance.vault.getCreditCardRecord(recordId: itemId);
  }

  static void addSecureNote(RecordBase<SecureNoteRecord> record) {
    _instance.vault.addNoteRecord(
      name: record.itemName,
      record: record.data,
      folder: record.folder,
      icon: record.icon,
    );
    _metaDirty = true;
  }

  static void updateSecureNote(
    String itemId,
    RecordBase<SecureNoteRecord> record,
  ) {
    _instance.vault.updateNoteRecord(
      recordId: itemId,
      name: record.itemName,
      record: record.data,
      folder: record.folder,
      icon: record.icon,
      isTrashed: record.isTrashed,
    );
    _metaDirty = true;
  }

  static SecureNoteRecord getSecureNote(String itemId) {
    return _instance.vault.getNoteRecord(recordId: itemId);
  }

  static void deleteFolder(String id) {
    _instance.vault.removeFolder(id: id);
    _metaDirty = true;
  }

  Future init() async {
    final dir = await getApplicationDocumentsDirectory();
    _vault = createVaultManager(password: 'some_password', rootPath: dir.path);
  }

  VaultManager get vault {
    if (_vault == null) {
      throw Exception(
        'Vault not initialized. Call initEmptyVault() or loadFromBytes() first.',
      );
    }
    return _vault!;
  }

  bool get isInitialized => _vault != null;
}
