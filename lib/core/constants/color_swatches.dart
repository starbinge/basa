import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:basa_app_project/core/theme/app_colors.dart';

// Make a custom ColorSwatch to name map from our Bauhaus colors.
final Map<ColorSwatch<Object>, String> colorsNameMap = <ColorSwatch<Object>, String>{
  ColorTools.createPrimarySwatch(AppColors.primary): 'Bauhaus Blue',
  ColorTools.createPrimarySwatch(AppColors.primaryContainer): 'Bauhaus Blue Container',
  ColorTools.createAccentSwatch(AppColors.secondary): 'Bauhaus Red',
  ColorTools.createAccentSwatch(AppColors.secondaryContainer): 'Bauhaus Red Container',
  ColorTools.createAccentSwatch(AppColors.tertiary): 'Bauhaus Yellow',
  ColorTools.createAccentSwatch(AppColors.tertiaryContainer): 'Bauhaus Yellow Container',
  ColorTools.createPrimarySwatch(AppColors.error): 'Bauhaus Error',
  ColorTools.createPrimarySwatch(AppColors.surface): 'Bauhaus Surface',
};
