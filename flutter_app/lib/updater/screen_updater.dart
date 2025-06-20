import 'package:flutter/material.dart';
import 'package:flutter_app/components/folder_list.dart';

class ScreenUpdater {
  static final GlobalKey<FolderListState> folderListGlobalKey =
      GlobalKey<FolderListState>();
      
  static final GlobalKey<FolderListState> categoryListGlobalKey =
      GlobalKey<FolderListState>();

  static final GlobalKey<FolderListState> noFolderListGlobalKey =
      GlobalKey<FolderListState>();

  static void updateFolderList() {
    folderListGlobalKey.currentState?.update();
  }

  static void updateCategoryList() {
    categoryListGlobalKey.currentState?.update();
  }

  static void updateNoFolderList() {
    noFolderListGlobalKey.currentState?.update();
  }
}
