import 'package:basa_app_project/core/widgets/bottom_navbar.dart';
import 'package:basa_app_project/features/decks/presentation/pages/deck_collection_page.dart';
import 'package:basa_app_project/features/home/presentation/pages/home_page.dart';
import 'package:basa_app_project/features/library/presentation/pages/library_page.dart';
import 'package:basa_app_project/features/settings/presentation/pages/setting_page.dart';
import 'package:flutter/material.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (pageIndex) {
          setState(() => _currentIndex = pageIndex);
        },
        children: const [
          HomePage(),            // tab label: Decks
          DeckCollectionPage(),  // tab label: Home
          LibraryPage(),
          SettingPage(),
        ],
      ),
      bottomNavigationBar: BottomNavbar(
        currentPage: _currentIndex,
        onTap: (pageIndex) {
          setState(() => _currentIndex = pageIndex);
          _pageController.animateToPage(
            pageIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }
}
