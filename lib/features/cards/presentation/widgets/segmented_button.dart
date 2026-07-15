import 'package:basa_app_project/features/cards/domain/entities/segmented_button_entity.dart';
import 'package:flutter/material.dart';

class SegmentedButtonCustom extends StatefulWidget {
  const SegmentedButtonCustom({super.key, required this.listOfButtons});
  final List<SegmentedButtonEntity> listOfButtons;
  @override
  State<SegmentedButtonCustom> createState() => _SegmentedButtonCustomState();
}

class _SegmentedButtonCustomState extends State<SegmentedButtonCustom> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 20,
      children: widget.listOfButtons.map((button) {
        return GestureDetector(
          onTap: button.onTap,
          child: AnimatedContainer(
            padding: EdgeInsets.symmetric(
              vertical: 5,
              horizontal: button.selectionParamter ? 15 : 5,
            ),
            decoration: BoxDecoration(
              color: button.selectionParamter
                  ? button.backgroundColor.selectedColor
                  : button.backgroundColor.unselectedColor,
              borderRadius: button.selectionParamter
                  ? BorderRadius.circular(button.borderRadiusSize)
                  : BorderRadius.circular(0),
            ),
            constraints: BoxConstraints(maxWidth: 100, maxHeight: 200),
            child: Text(
              button.text,
              style: TextStyle(
                color: button.selectionParamter
                    ? button.foregroundColor.selectedColor
                    : button.foregroundColor.unselectedColor,
              ),
            ),
            duration: Duration(milliseconds: 700),
            curve: Curves.elasticInOut,
          ),
        );
      }).toList(),
    );
  }
}
