import 'package:flutter/material.dart';
import 'package:flutter_app/actions/show_add_pass_menu.dart';
import 'package:flutter_app/screens/vault_screen.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

const List<Widget> pages = <Widget>[
  VaultScreen(),
  Center(child: Text('Generator', style: TextStyle(fontSize: 24))),
  Center(child: Text('Send', style: TextStyle(fontSize: 24))),
  Center(child: Text('Settings', style: TextStyle(fontSize: 24))),
];

final List<BottomNavigationBarItem> navItems = <BottomNavigationBarItem>[
  BottomNavigationBarItem(
    icon: Icon(PhosphorIcons.vault(PhosphorIconsStyle.fill)),
    label: 'Vault',
  ),
  BottomNavigationBarItem(
    icon: Icon(PhosphorIcons.wrench(PhosphorIconsStyle.fill)),
    label: 'Generator',
  ),
  BottomNavigationBarItem(
    icon: Icon(PhosphorIcons.paperPlaneTilt(PhosphorIconsStyle.fill)),
    label: 'Send',
  ),
  BottomNavigationBarItem(
    icon: Icon(PhosphorIcons.gear(PhosphorIconsStyle.fill)),
    label: 'Settings',
  ),
];

typedef ContextAction = void Function(BuildContext context);

final Map<int, ContextAction> menuActions = {
  0: (context) {
    showAddMenu(context);
  }
};