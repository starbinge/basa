import 'package:flutter/material.dart';
import 'package:m3e_core/m3e_core.dart';

class CallendarHeatmap extends StatefulWidget {
  const CallendarHeatmap({
    super.key,
    required this.itemCount,
    required this.getValue,
    this.baseColor,
    required this.onDateTap,
  });

  final int itemCount;
  final double Function(int index) getValue;
  final void Function(DateTime date) onDateTap;
  final Color? baseColor;

  @override
  State<CallendarHeatmap> createState() => _CallendarHeatmapState();
}

class _CallendarHeatmapState extends State<CallendarHeatmap> {
  @override
  Widget build(BuildContext context) {
    final color = widget.baseColor ?? Theme.of(context).primaryColor;

    return Container(
      padding: const EdgeInsets.all(10),
      constraints: const BoxConstraints(maxHeight: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: widget.itemCount,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemBuilder: (BuildContext context, int dateIndex) {
                final value = widget.getValue(dateIndex);
                return GestureDetector(
                  onTap: () {
                    final int day = dateIndex + 1;
                    final DateTime clickedDate = DateTime(2026, 7, day);
                    widget.onDateTap(clickedDate);
                  },
                  child: Stack(
                    alignment: AlignmentGeometry.center,
                    children: [
                      M3EShape.flower(
                        color: value == 0.0
                            ? Colors.grey.withValues(alpha: 0.1)
                            : color.withValues(alpha: value.clamp(0.0, 1.0)),
                        width: 40,
                        height: 40,
                      ),
                      Text((dateIndex + 1).toString()),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
