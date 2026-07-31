import 'package:basa_app_project/core/constants/screen_size.dart';
import 'package:flutter/material.dart';

class StatsNumberContainer extends StatelessWidget {
  const StatsNumberContainer({
    super.key,
    required this.number,
    required this.numberLabel,
  });

  final String number;
  final String numberLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth * 0.2,
      height: context.screenWidth * 0.2,
      padding: EdgeInsetsGeometry.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number.toString(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(numberLabel, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
