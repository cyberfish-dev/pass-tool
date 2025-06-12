import 'package:flutter/material.dart';
import 'package:flutter_app/components/folder_list.dart';

class ScreenUpdater {
  static final GlobalKey<FolderListState> folderListGlobalKey = GlobalKey<FolderListState>();

  static void updateFolderList() {
    folderListGlobalKey.currentState?.update();
  }
}
