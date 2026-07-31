import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({
    super.key,
    required Color colorCards,
    required int statsNumber,
    required String statsTitle,
    required IconData statsIcon,
  }) : _colorCards = colorCards,
       _statsNumber = statsNumber,
       _statsTitle = statsTitle,
       _statsIcon = statsIcon;

  final Color _colorCards;
  final int _statsNumber;
  final String _statsTitle;
  final IconData _statsIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: _colorCards,
      ),
      padding: const EdgeInsets.all(16),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Icon(_statsIcon, size: 200, color: Colors.white.withAlpha(50)),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _statsNumber.toString(),
                style: TextStyle(
                  fontSize: TextTheme.of(context).displayLarge?.fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                _statsTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: TextTheme.of(context).titleLarge?.fontSize,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
