import 'package:flutter_app/models/list_item_model.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

final List<ListItemModel> actions = [
  ListItemModel(
    'Add Login',
    PhosphorIcons.globe(PhosphorIconsStyle.thin),
    null,
  ),
  ListItemModel(
    'Add Card',
    PhosphorIcons.creditCard(PhosphorIconsStyle.thin),
    null,
  ),
  ListItemModel(
    'Add Identity',
    PhosphorIcons.identificationCard(PhosphorIconsStyle.thin),
    null,
  ),
  ListItemModel(
    'Add Secure Note',
    PhosphorIcons.note(PhosphorIconsStyle.thin),
    null,
  ),
  ListItemModel(
    'Add SSH Key',
    PhosphorIcons.key(PhosphorIconsStyle.thin),
    null,
  ),
];
