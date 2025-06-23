import 'package:flutter/material.dart';
import 'package:flutter_app/components/categories_list.dart';
import 'package:flutter_app/components/folder_list.dart';
import 'package:flutter_app/components/records_list.dart';

class ScreenUpdater {
  static final GlobalKey<FolderListState> folderListGlobalKey =
      GlobalKey<FolderListState>();
      
  static final GlobalKey<CategoryListState> categoryListGlobalKey =
      GlobalKey<CategoryListState>();

  static final GlobalKey<RecordsListState> noFolderListGlobalKey =
      GlobalKey<RecordsListState>();

  static final GlobalKey<RecordsListState> recordsGlobalKey =
      GlobalKey<RecordsListState>();

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
