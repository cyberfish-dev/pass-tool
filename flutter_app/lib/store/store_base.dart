import 'package:flutter_app/models/folder_model.dart';

abstract class StoreBase {
  void addFolder(String item);
  void removeFolder(String id);
  List<FolderModel> listFolders();
}
