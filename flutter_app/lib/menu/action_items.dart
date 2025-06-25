import 'package:flutter/material.dart';
import 'package:flutter_app/actions/credit_action.dart';
import 'package:flutter_app/actions/folder_add_action.dart';
import 'package:flutter_app/actions/login_add_action.dart';
import 'package:flutter_app/actions/note_action.dart';
import 'package:flutter_app/enums/action.dart';
import 'package:flutter_app/models/list_item_model.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

final List<ListItemModel> actions = [
  ListItemModel('Login', PhosphorIcons.globe(PhosphorIconsStyle.thin), null, (
    ctx,
  ) {
    Navigator.of(ctx).pop();
    final action = LoginAddAction();
    action.showCustomBottomSheet(ctx, null);
  }, '_login'),
  ListItemModel(
    'Card',
    PhosphorIcons.creditCard(PhosphorIconsStyle.thin),
    null,
    (ctx) {
      Navigator.of(ctx).pop();
      final action = CreditAction(RecordAction.add);
      action.showCustomBottomSheet(ctx, null);
    },
    '_card',
  ),
  ListItemModel(
    'Secure Note',
    PhosphorIcons.note(PhosphorIconsStyle.thin),
    null,
    (ctx) {
      Navigator.of(ctx).pop();
      final action = NoteAction(RecordAction.add);
      action.showCustomBottomSheet(ctx, null);
    },
    '_note',
  ),
  ListItemModel(
    'Folder',
    PhosphorIcons.folderOpen(PhosphorIconsStyle.thin),
    null,
    (ctx) {
      Navigator.of(ctx).pop();
      final action = FolderAddAction();
      action.showCustomBottomSheet(ctx, null);
    },
    '_folder',
  ),
];
