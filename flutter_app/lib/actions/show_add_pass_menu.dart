import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

void showAddMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(PhosphorIcons.globe()),
            title: Text('Add Login'),
            onTap: () {
              Navigator.pop(ctx);
              // TODO: Navigate to AddLoginScreen()
            },
          ),
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('Add Card'),
            onTap: () {
              Navigator.pop(ctx);
              // TODO: Navigate to AddCardScreen()
            },
          ),
          ListTile(
            leading: Icon(Icons.note_add_outlined),
            title: Text('Add Secure Note'),
            onTap: () {
              Navigator.pop(ctx);
              // TODO: Navigate to AddNoteScreen()
            },
          ),
          ListTile(
            leading: Icon(Icons.folder_open),
            title: Text('Add Folder'),
            onTap: () {
              Navigator.pop(ctx);
              // TODO: Navigate to AddFolderScreen()
            },
          ),
        ],
      ),
    ),
  );
}
