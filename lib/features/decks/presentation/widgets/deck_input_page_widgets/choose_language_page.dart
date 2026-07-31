import 'package:basa_app_project/core/constants/common_path.dart';
import 'package:basa_app_project/core/widgets/country_selector.dart';
import 'package:basa_app_project/core/widgets/text_button_custom.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ChooseLanguagePage extends StatefulWidget {
  const ChooseLanguagePage({
    super.key,
    required this.theme,
    required this.pageController,
    required ValueChanged<Country> onSelect,
    required String selectedCountry,
  }) : _selectedCountry = selectedCountry,
       _onSelect = onSelect;

  final ThemeData theme;
  final PageController pageController;
  final ValueChanged<Country> _onSelect;
  final String _selectedCountry;

  @override
  State<ChooseLanguagePage> createState() => _ChooseLanguagePageState();
}

class _ChooseLanguagePageState extends State<ChooseLanguagePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Container()),
        LottieBuilder.asset(animationPath + "Grey_Globe.json", repeat: true),
        const Text("What language is your deck?")
            .animate(delay: const Duration(milliseconds: 200))
            .fadeIn(curve: Curves.easeInOut)
            .moveY(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              delay: const Duration(milliseconds: 100),
              begin: 20,
              end: 0,
            ),
        CountrySelector(
              onSelect: widget._onSelect,
              selectedCountry: widget._selectedCountry,
            )
            .animate(delay: const Duration(milliseconds: 400))
            .fadeIn(curve: Curves.easeInOut)
            .moveY(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              delay: const Duration(milliseconds: 200),
              begin: 20,
              end: 0,
            ),
        Expanded(child: Container()),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          spacing: 20,
          children: [
            Expanded(
              child: TextButtonCustom(
                placeHolder: "Back",
                theme: widget.theme,
                buttonStyle: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    widget.theme.scaffoldBackgroundColor,
                  ),
                  foregroundColor: WidgetStatePropertyAll(
                    widget.theme.primaryColor,
                  ),
                  side: WidgetStatePropertyAll(
                    BorderSide(width: 1, color: widget.theme.primaryColor),
                  ),
                ),
                onPressedButton: () => widget.pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              ),
            ),
            Expanded(
              child: TextButtonCustom(
                theme: widget.theme,
                buttonStyle: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    widget._selectedCountry.isNotEmpty
                        ? widget.theme.colorScheme.primary
                        : widget.theme.colorScheme.onSurfaceVariant.withAlpha(
                            120,
                          ),
                  ),
                  foregroundColor: WidgetStatePropertyAll(
                    widget._selectedCountry.isNotEmpty
                        ? widget.theme.colorScheme.onPrimary
                        : widget.theme.colorScheme.onSurfaceVariant.withAlpha(
                            120,
                          ),
                  ),
                ),
                onPressedButton: widget._selectedCountry.isNotEmpty
                    ? () {
                        widget.pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
