import 'package:flutter_app/models/folder_model.dart';
import 'package:flutter_app/store/store_base.dart';

class LocalStore implements StoreBase {
  static final List<FolderModel> _folders = [];

  @override
  void addFolder(String item) {
    _folders.add(FolderModel(id: DateTime.now().toString(), name: item));
  }

  @override
  List<FolderModel> listFolders() {
    return _folders;
  }

  @override
  void removeFolder(String id) {
    _folders.removeWhere((folder) => folder.id == id);
  }
}
