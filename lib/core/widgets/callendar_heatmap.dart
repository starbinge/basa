import 'package:flutter/material.dart';
import 'package:m3e_core/m3e_core.dart';

class CallendarHeatmap extends StatelessWidget {
  const CallendarHeatmap({
    super.key,
    required this.itemCount,
    required this.getValue,
    this.baseColor,
  });

  final int itemCount;
  final double Function(int index) getValue;
  final Color? baseColor;

  @override
  Widget build(BuildContext context) {
    final color = baseColor ?? Theme.of(context).primaryColor;

    return Container(
      padding: EdgeInsets.all(10),
      constraints: BoxConstraints(maxHeight: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: itemCount,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemBuilder: (BuildContext context, int dateIndex) {
                final value = getValue(dateIndex);
                return Stack(
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
