import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({
    super.key,
    required this.onTap,
    required this.currentPage,
  });

  final ValueChanged<int> onTap;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentPage,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.collections_bookmark_sharp),
          label: "Decks",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_library_sharp),
          label: "Library",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
      ],
      onTap: onTap,
    );
  }
}
