import 'package:flutter_app/models/list_item_model.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

final List<ListItemModel> categories = [
  ListItemModel('Logins', PhosphorIcons.globe(PhosphorIconsStyle.thin), 80, (ctx) => {}, '_login'),
  ListItemModel('Cards', PhosphorIcons.creditCard(PhosphorIconsStyle.thin), 0, (ctx) => {}, '_card'),
  ListItemModel(
    'Identity',
    PhosphorIcons.identificationCard(PhosphorIconsStyle.thin),
    0,
    (ctx) => {},
    '_identity',
  ),
  ListItemModel('Secure Notes', PhosphorIcons.note(PhosphorIconsStyle.thin), 0, (ctx) => {}, '_note'),
  ListItemModel('SSH Keys', PhosphorIcons.key(PhosphorIconsStyle.thin), 0, (ctx) => {}, '_ssh_key'),
];
