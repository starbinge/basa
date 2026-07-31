import 'package:basa_app_project/core/constants/common_path.dart';
import 'package:basa_app_project/core/widgets/file_picker.dart';
import 'package:basa_app_project/core/widgets/text_button_custom.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SelectDeckFilePage extends StatefulWidget {
  const SelectDeckFilePage({
    super.key,
    required VoidCallback onTap,
    required String ankiFilePath,
    required PageController pageController,
    required VoidCallback onPressedButton,
    required VoidCallback onTapFilePicker,
  }) : _onTapFilePicker = onTapFilePicker,
       _onPressedButton = onPressedButton,
       _pageController = pageController,
       _ankiFilePath = ankiFilePath;
  final VoidCallback _onTapFilePicker;
  final String _ankiFilePath;
  final PageController _pageController;
  final VoidCallback _onPressedButton;

  @override
  State<SelectDeckFilePage> createState() => _SelectDeckFilePageState();
}

class _SelectDeckFilePageState extends State<SelectDeckFilePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Container()),
        LottieBuilder.asset(
          animationPath + "import_animation.json",
          height: 200,
          repeat: true,
          reverse: true,
        ),
        const Text("Select your anki deck file path!"),
        AnkiFilePickerButton(
          ankiFilePath: widget._ankiFilePath.split("/").last,
          onTap: widget._onTapFilePicker,
        ),
        Expanded(child: Container()),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          spacing: 20,
          children: [
            Expanded(
              child: TextButtonCustom(
                placeHolder: "Back",
                theme: theme,
                buttonStyle: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    theme.scaffoldBackgroundColor,
                  ),
                  foregroundColor: WidgetStatePropertyAll(theme.primaryColor),
                  side: WidgetStatePropertyAll(
                    BorderSide(width: 1, color: theme.primaryColor),
                  ),
                ),
                onPressedButton: () => widget._pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              ),
            ),
            Expanded(
              child: TextButtonCustom(
                theme: theme,
                buttonStyle: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    widget._ankiFilePath.isNotEmpty
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant.withAlpha(120),
                  ),
                  foregroundColor: WidgetStatePropertyAll(
                    widget._ankiFilePath.isNotEmpty
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant.withAlpha(120),
                  ),
                ),
                onPressedButton: widget._onPressedButton,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
