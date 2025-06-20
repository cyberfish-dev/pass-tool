import 'package:flutter/material.dart';
import 'package:flutter_app/components/categories_list.dart';
import 'package:flutter_app/components/folder_list.dart';
import 'package:flutter_app/components/no_folder_list.dart';

class ScreenUpdater {
  static final GlobalKey<FolderListState> folderListGlobalKey =
      GlobalKey<FolderListState>();
      
  static final GlobalKey<CategoryListState> categoryListGlobalKey =
      GlobalKey<CategoryListState>();

  static final GlobalKey<NoFolderListState> noFolderListGlobalKey =
      GlobalKey<NoFolderListState>();

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
