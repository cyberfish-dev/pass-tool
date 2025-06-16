import 'package:flutter/material.dart';
import 'package:flutter_app/components/custom_border.dart';
import 'package:flutter_app/components/rectangular_notched_rectangle.dart';
import 'package:flutter_app/menu/menu_items.dart';
import 'package:flutter_app/themes/main.dart';
import 'package:pass_tool_core/pass_tool_core.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

Future<void> main() async {
  await RustLib.init();
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
  Rect _fabRect = Rect.zero;

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  void initState() {
    super.initState();
    // Measure after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureFab());
  }

  void _measureFab() {
    // 1) Get the overlay’s RenderBox
    final overlayBox =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    if (_fabKey.currentContext == null) {
      return;
    }
    // 2) Get the FAB’s RenderBox
    final fabBox = _fabKey.currentContext!.findRenderObject() as RenderBox;
    // 3) Convert its top-left into overlay coords
    final topLeft = fabBox.localToGlobal(Offset.zero, ancestor: overlayBox);
    // 4) Build the Rect
    setState(() {
      _fabRect = topLeft & fabBox.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureFab());
    final bool keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final hasFloating =
        menuActions.containsKey(_currentIndex) && !keyboardVisible;

    final notch = RectangularNotchedRectangle(
      notchWidth: 65,
      notchHeight: 33,
      notchRadius: 16,
      ignore: !hasFloating
    );

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: pages[_currentIndex],
      bottomNavigationBar: SizedBox(
        height: 120,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            shape: NotchedBorder(
              notch: notch,
              guest: _fabRect,
              borderWidth: 2,
              borderColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: BottomAppBar(
            padding: EdgeInsets.only(bottom: 0, top: 20),
            elevation: 0,
            shape: hasFloating ? notch : null,
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: hasFloating
          ? FloatingActionButton(
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
            )
          : null,
    );
  }
}
