import 'package:flutter_app/store/store_base.dart';

class LocalStore implements StoreBase {

  static final List<String> _folders = [];

  @override
  void addFolder(String item) {
    _folders.add(item);
  }

  @override
  List<String> listFolders() {
    return _folders;
  }

  @override
  void removeFolder(String item) {
    _folders.remove(item);
  }
}