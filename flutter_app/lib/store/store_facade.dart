import 'package:flutter_app/models/folder_model.dart';
import 'package:flutter_app/store/local_store.dart';
import 'package:flutter_app/store/store_base.dart';

class StoreFacade implements StoreBase {
  final StoreBase _store = LocalStore();

  @override
  void addFolder(String item) {
    _store.addFolder(item);
  }

  @override
  void removeFolder(String id) {
    _store.removeFolder(id);
  }

  @override
  List<FolderModel> listFolders() {
    return _store.listFolders();
  }
}
