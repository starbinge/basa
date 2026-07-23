import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/vocab_bottom_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:m3e_core/m3e_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardTierListContainer extends StatelessWidget {
  const CardTierListContainer({
    super.key,
    required this.titleText,
    required this.iconShape,
    required this.backgroundColor,
    required this.strokeColor,
    required this.iconColor,
    required this.cardsData,
    required this.carouselBackgroundColor,
    required this.carouselForgroundColor,
    required this.isAudioPlay,
    required this.audioPlayer,
    required this.filePath,
  });
  final File filePath;
  final String titleText;
  final IconData iconShape;
  final Color backgroundColor;
  final Color strokeColor;
  final Color iconColor;
  final List<CardsDetailEntity> cardsData;
  final Color carouselBackgroundColor;
  final Color carouselForgroundColor;
  final bool isAudioPlay;
  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),

      child: Column(
        children: [
          Center(
            child: Column(
              spacing: 20,
              children: [
                Stack(
                  fit: StackFit.loose,
                  alignment: AlignmentGeometry.center,
                  children: [
                    RepaintBoundary(
                      child:
                          M3EContainer.c9SidedCookie(
                                border: BorderSide(
                                  width: 3,
                                  color: strokeColor,
                                ),
                                padding: const EdgeInsets.all(35),
                                color: backgroundColor,
                                child: const Icon(
                                  Icons.transform_sharp,
                                  color: Colors.transparent,
                                ),
                              )
                              .animate(
                                autoPlay: true,
                                onComplete: (controller) {
                                  controller.repeat();
                                },
                              )
                              .rotate(
                                curve: Curves.fastOutSlowIn,
                                duration: const Duration(seconds: 5),
                              ),
                    ),

                    Icon(iconShape, size: 50, color: iconColor),
                  ],
                ),
                SizedBox(
                  width: double.infinity / 2,
                  child: Text(
                    softWrap: true,
                    titleText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: Theme.of(
                        context,
                      ).textTheme.displayLarge?.fontFamily,
                      fontSize: Theme.of(
                        context,
                      ).textTheme.titleLarge?.fontSize,
                      fontWeight: Theme.of(
                        context,
                      ).textTheme.titleLarge?.fontWeight,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 180.h),
            child: CarouselView.weighted(
              onTap: (int cardIndex) async {
                await showModalBottomSheet(
                  isScrollControlled: true,
                  showDragHandle: true,
                  context: context,
                  builder: (BuildContext context) {
                    return VocabBottomModal(
                      listCard: cardsData,
                      filePath: filePath,
                      audioPlayer: audioPlayer,
                      cardIndex: cardIndex,
                    );
                  },
                );
                audioPlayer.stop();
              },
              flexWeights: const <int>[8, 1, 1],
              // 💡 Tambahkan ini agar jarak antar kartu tidak terlalu nempel
              itemSnapping: true,
              backgroundColor: Colors.transparent,
              children: cardsData.map((card) {
                return ClipRRect(
                  // 💡 Biar ujung kartunya membulat ngikutin desain M3
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(color: carouselBackgroundColor),
                    child: Center(
                      child: Stack(
                        fit: StackFit.expand,
                        alignment: AlignmentGeometry.bottomRight,
                        clipBehavior: Clip.antiAlias,
                        children: [
                          ClipRRect(
                            child: Icon(
                              Icons.translate_rounded,
                              size: 300,
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                card.defaultLanguage,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.fade,
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      color: carouselForgroundColor,
                                      fontSize: card.defaultLanguage.length > 30 ? 25.0 : 30.0,
                                    ),
                              ),
                              Text(
                                card.translatedLanguage,
                                overflow: TextOverflow.fade,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: carouselForgroundColor,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
