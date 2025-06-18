import 'package:pass_tool_core/pass_tool_core.dart';

class VaultService {
  VaultManager? _vault;
  static final VaultService _instance = VaultService._internal();
  static bool _metaDirty = true;

  static VaultMetadataVault? _vaultMeta;

  VaultService._internal();

  static void init() {
    // TODO: make sure to load from disk if available
    _instance.initEmptyVault();
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

  static void deleteFolder(String id) {
    _instance.vault.removeFolder(id: id);
    _metaDirty = true;
  }

  /// Initialize a new vault (or load one)
  void initEmptyVault() {
    _vault = createEmptyVaultManager();
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
