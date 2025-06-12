import 'package:flutter/material.dart';
import 'package:flutter_app/actions/folder_add_action.dart';
import 'package:flutter_app/models/list_item_model.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

final List<ListItemModel> actions = [
  ListItemModel(
    'Login',
    PhosphorIcons.globe(PhosphorIconsStyle.thin),
    null,
    (ctx) => {},
  ),
  ListItemModel(
    'Card',
    PhosphorIcons.creditCard(PhosphorIconsStyle.thin),
    null,
    (ctx) => {},
  ),
  ListItemModel(
    'Identity',
    PhosphorIcons.identificationCard(PhosphorIconsStyle.thin),
    null,
    (ctx) => {},
  ),
  ListItemModel(
    'Secure Note',
    PhosphorIcons.note(PhosphorIconsStyle.thin),
    null,
    (ctx) => {},
  ),
  ListItemModel(
    'SSH Key',
    PhosphorIcons.key(PhosphorIconsStyle.thin),
    null,
    (ctx) => {},
  ),
  ListItemModel(
    'Folder',
    PhosphorIcons.folderOpen(PhosphorIconsStyle.thin),
    null,
    (ctx) {      
      
      Navigator.of(ctx).pop();

      final action = FolderAddAction(
      );

      action.showCustomBottomSheet(ctx);
    },
  ),
];
