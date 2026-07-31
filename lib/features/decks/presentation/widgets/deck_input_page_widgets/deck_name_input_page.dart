import 'package:basa_app_project/core/utils/custom_deck__color_mapper.dart';
import 'package:basa_app_project/core/widgets/color_picker.dart';
import 'package:basa_app_project/core/widgets/text_button_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeckNameInput extends StatelessWidget {
  const DeckNameInput({
    super.key,
    required this.theme,
    required TextEditingController deckNameController,
    required PageController pageController,
    required this.onSelectedColor,
    required int selectedColor,
  }) : _selectedColor = selectedColor,
       _pageController = pageController,
       _deckNameController = deckNameController;
  final ValueChanged<Color> onSelectedColor;
  final ThemeData theme;
  final TextEditingController _deckNameController;
  final PageController _pageController;
  final int _selectedColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10,
      children: [
        Expanded(child: Container()),
        Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SvgPicture.asset(
                    'assets/images/folder_icon(1).svg',
                    height: 64,
                    colorMapper: CustomDeckColorMapper(
                      selectedColor: _selectedColor,
                    ),
                  ),
                ),

                IconButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(theme.primaryColor),
                    foregroundColor: WidgetStatePropertyAll(
                      theme.colorScheme.surfaceDim,
                    ),
                  ),
                  onPressed: () async {
                    await colorPickerDialog(
                      context: context,
                      currentColor: Colors.blue.shade900,
                      onChangedColor: onSelectedColor,
                    );
                  },
                  icon: const Icon(Icons.edit),
                ),
              ],
            )
            .animate(delay: const Duration(milliseconds: 200))
            .fadeIn(curve: Curves.easeInOut)
            .moveY(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              delay: const Duration(milliseconds: 100),
              begin: 20,
              end: 0,
            ),
        TextField(
              autofocus: true,
              controller: _deckNameController,
              decoration: InputDecoration(
                errorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                hintText: "Give a name to your deck",
                hintStyle: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w200),
              ),
              textAlign: TextAlign.center,
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
        SizedBox(
          width: double.infinity,
          child: ValueListenableBuilder(
            valueListenable: _deckNameController,
            builder: (context, value, child) {
              final bool isNotEmpty = _deckNameController.text.isNotEmpty;
              return TextButtonCustom(
                theme: theme,
                buttonStyle: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    isNotEmpty
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant.withAlpha(120),
                  ),
                  foregroundColor: WidgetStatePropertyAll(
                    isNotEmpty
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant.withAlpha(120),
                  ),
                ),
                onPressedButton: isNotEmpty
                    ? () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }
}
