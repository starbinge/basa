import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/main_card_page.dart';

class CardAppBar extends StatelessWidget {
  const CardAppBar({super.key, required this.flagEmoji, required this.widget});

  final String? flagEmoji;
  final MainCardPage widget;

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
      title: Text("Cards"),
      centerTitle: true,
      expandedHeight: 340.0,
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
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.deckName,
                        style: TextStyle(
                          fontSize: TextTheme.of(context).displaySmall?.fontSize,
                          color: Colors.white,
                        ),
                      ),
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
