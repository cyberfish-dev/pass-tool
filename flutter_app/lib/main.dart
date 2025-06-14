import 'package:flutter/material.dart';
import 'package:flutter_app/components/rectangular_notched_rectangle.dart';
import 'package:flutter_app/menu/menu_items.dart';
import 'package:flutter_app/themes/main.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

void main() {
  runApp(const PassToolApp());
}

class PassToolApp extends StatelessWidget {
  const PassToolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PassTool',
      themeMode: ThemeMode.dark,
      theme: baseTheme,
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
  final GlobalKey _fabKey = GlobalKey();
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final notchShape = RectangularNotchedRectangle(
      notchWidth: 65,
      notchHeight: 33,
      notchRadius: 16,
    );

    final bool keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: pages[_currentIndex],
      bottomNavigationBar: SizedBox(
        height: 120,
        child: BottomAppBar(
          padding: EdgeInsets.only(bottom: 0, top: 20),
          elevation: 4,
          shape: notchShape,
          notchMargin: 0,
          child: Builder(
            builder: (context) {
              return BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                items: navItems,
                currentIndex: _currentIndex,
                onTap: _onItemTapped,
                type: BottomNavigationBarType.fixed,
                selectedFontSize: 13,
                unselectedFontSize: 13,
                selectedLabelStyle: TextStyle(height: 1.8),
                unselectedLabelStyle: TextStyle(height: 1.8),
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: menuActions.containsKey(_currentIndex)
          ? Visibility(
            visible: !keyboardVisible,
            child: FloatingActionButton(
              key: _fabKey,
              onPressed: () => menuActions[_currentIndex]!(context, _fabKey),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    PhosphorIcons.plusCircle(PhosphorIconsStyle.fill),
                    size: 25,
                  ),
                ],
              ),
            ),
          )
          : null,
    );
  }
}
