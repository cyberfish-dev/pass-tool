import 'package:flutter_app/store/localStore.dart';
import 'package:flutter_app/store/store_base.dart';

class StoreFacade implements StoreBase {
  final StoreBase _store = LocalStore();

  @override
  void addFolder(String item) {
    _store.addFolder(item);
  }

  @override
  void removeFolder(String item) {
    _store.removeFolder(item);
  }

  @override
  List<String> listFolders() {
    return _store.listFolders();
  }
}
