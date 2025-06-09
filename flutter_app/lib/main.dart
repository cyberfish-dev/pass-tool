import 'package:flutter/material.dart';
import 'package:flutter_app/themes/main.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'screens/vault_screen.dart';

void main() {
  runApp(const PassToolApp());
}

class PassToolApp extends StatelessWidget {
  const PassToolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PassTool',
      themeMode:
          ThemeMode.dark, // always dark; swap to .system if you want auto
      theme: baseeTheme,
      darkTheme: darkTeme,
      home: const MainLayout(),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  static const List<Widget> _pages = <Widget>[
    VaultScreen(),
    Center(child: Text('Generator', style: TextStyle(fontSize: 24))),
    Center(child: Text('Send', style: TextStyle(fontSize: 24))),
    Center(child: Text('Settings', style: TextStyle(fontSize: 24))),
  ];

  static final List<BottomNavigationBarItem> _navItems =
      <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(PhosphorIcons.vault(PhosphorIconsStyle.thin)), label: 'Vault'),
        BottomNavigationBarItem(
          icon: Icon(PhosphorIcons.wrench(PhosphorIconsStyle.thin)),
          label: 'Generator',
        ),
        BottomNavigationBarItem(icon: Icon(PhosphorIcons.paperPlaneTilt(PhosphorIconsStyle.thin)), label: 'Send'),
        BottomNavigationBarItem(
          icon: Icon(PhosphorIcons.gear(PhosphorIconsStyle.thin)),
          label: 'Settings',
        ),
      ];

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
  }

  void _showAddMenu() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: SizedBox(
        height: 100,
        child: BottomNavigationBar(
          items: _navItems,
          currentIndex: _currentIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,    // same font size for both
          unselectedFontSize: 12,  // prevents zooming on select
        ),
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: _showAddMenu,
              child: Icon(PhosphorIcons.plus()),
            )
          : null,
    );
  }
}
