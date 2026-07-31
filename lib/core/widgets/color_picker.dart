import 'package:basa_app_project/core/constants/color_swatches.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

Future<bool> colorPickerDialog({
  required BuildContext context,
  required Color currentColor,
  required ValueChanged<Color> onChangedColor,
}) async {
  return ColorPicker(
    onColorChangeEnd: onChangedColor,
    showColorCode: true,
    showColorName: true,
    color: currentColor,
    onColorChanged: (Color color) {},
    width: 40,
    height: 40,
    borderRadius: 4,
    spacing: 5,
    runSpacing: 5,
    wheelDiameter: 155,
    heading: Text(
      'Select Color',
      style: Theme.of(context).textTheme.titleMedium,
    ),
    subheading: Text(
      'Select color shade',
      style: Theme.of(context).textTheme.titleMedium,
    ),
    customColorSwatchesAndNames: colorsNameMap,
    pickersEnabled: const <ColorPickerType, bool>{
      ColorPickerType.both: false,
      ColorPickerType.primary: false,
      ColorPickerType.accent: false,
      ColorPickerType.custom: true,
      ColorPickerType.wheel: true,
    },
    copyPasteBehavior: const ColorPickerCopyPasteBehavior(
      copyButton: true,
      longPressMenu: true,
      editFieldCopyButton: true,
    ),
  ).showPickerDialog(
    context,
    constraints: const BoxConstraints(
      minWidth: 280,
      minHeight: 480,
      maxWidth: 320,
    ),
  );
}
