import 'package:basa_app_project/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:m3e_core/m3e_core.dart';

import '../../pages/main_card_page.dart';

class CardAppBar extends StatelessWidget {
  const CardAppBar({
    super.key,
    required this.flagEmoji,
    required this.widget,
    required this.flashCardButton,
    required this.quizButton,
    required this.historyButton,
  });

  final String? flagEmoji;
  final MainCardPage widget;
  final VoidCallback flashCardButton;
  final VoidCallback quizButton;
  final VoidCallback historyButton;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.0),
          bottomRight: Radius.circular(24.0),
        ),
      ),
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: TextTheme.of(context).titleLarge?.fontSize,
        fontWeight: TextTheme.of(context).titleLarge?.fontWeight,
      ),
      title: Center(
        child: Container(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Text("Cards", textAlign: TextAlign.center)),
              IconButton(onPressed: historyButton, icon: Icon(Icons.history)),
            ],
          ),
        ),
      ),

      centerTitle: true,
      expandedHeight: 350.0,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 5,
      shadowColor: Theme.of(context).shadowColor,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Container(
          child: Center(
            child: Stack(
              clipBehavior: Clip.antiAlias,
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.translate,
                  size: (TextTheme.of(context).displayLarge!.fontSize! * 7),
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimary.withValues(alpha: 0.2),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    flagEmoji!.isNotEmpty
                        ? Text(
                            flagEmoji!,
                            style: TextStyle(
                              fontSize:
                                  (TextTheme.of(
                                    context,
                                  ).displayLarge!.fontSize! *
                                  1.5),
                            ),
                          )
                        : Icon(
                            Icons.language,
                            size: TextTheme.of(context).headlineLarge?.fontSize,
                          ),
                    Container(
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(
                          context,
                        ).hintColor.withValues(alpha: 0.2),
                      ),
                      child: Text(
                        widget.deckCountry,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: TextTheme.of(context).labelMedium?.fontSize,
                        ),
                      ),
                    ),
                    Text(
                      widget.deckName,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: widget.deckName.length > 20
                            ? TextTheme.of(context).titleLarge?.fontSize
                            : widget.deckName.length > 12
                            ? TextTheme.of(context).headlineMedium?.fontSize
                            : TextTheme.of(context).displaySmall?.fontSize,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        M3EButton.icon(
                          decoration: M3EButtonDecoration(
                            foregroundColor: WidgetStatePropertyAll(
                              AppColors.primaryDark,
                            ),
                            backgroundColor: WidgetStatePropertyAll(
                              AppColors.primaryContainer,
                            ),
                          ),
                          onPressed: flashCardButton,
                          icon: Icon(Icons.shuffle_on_rounded),
                          label: Text(
                            "Flash  Card",
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: AppColors.primaryDark),
                          ),
                        ),

                        M3EButton.icon(
                          decoration: M3EButtonDecoration(
                            foregroundColor: WidgetStatePropertyAll(
                              AppColors.tertiaryDark,
                            ),
                            backgroundColor: WidgetStatePropertyAll(
                              AppColors.tertiaryContainer,
                            ),
                          ),
                          onPressed: quizButton,
                          icon: Icon(Icons.quiz_rounded),
                          label: Text(
                            "Play Quiz",
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: AppColors.tertiaryDark),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
