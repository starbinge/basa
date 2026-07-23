import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/cards_detail_entity.dart';

class FlashCardSlider extends StatefulWidget {
  const FlashCardSlider({
    super.key,
    required this.itemCount,
    required this.flashCards,
    required PageController pageController,
    required this.onCardFlipped,
    required this.onPageChanged,
  }) : _pageController = pageController;

  final int itemCount;
  final List<CardsDetailEntity> flashCards;
  final PageController _pageController;
  final void Function(bool isFront) onCardFlipped;
  final void Function(int index) onPageChanged;

  @override
  State<FlashCardSlider> createState() => _FlashCardSliderState();
}

class _FlashCardSliderState extends State<FlashCardSlider> {
  @override
  void dispose() {
    widget._pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      onPageChanged: widget.onPageChanged,
      controller: widget._pageController,
      itemCount: widget.itemCount,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int cardIndex) {
        final card = widget.flashCards[cardIndex];

        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 60.h, horizontal: 25.w),
            child: FlipCard(
              onFlipDone: widget.onCardFlipped,
              key: ValueKey(cardIndex),
              side: CardSide.FRONT,
              fill: Fill.fillBack,
              direction: FlipDirection.HORIZONTAL,
              front: _buildCardContainer(
                text: card.defaultLanguage,
                backgroundColor: const Color(0xFFFFFFFF),
              ),
              back: _buildCardContainer(
                text: card.translatedLanguage,
                backgroundColor: const Color(0xFFF5F5F5),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardContainer({
    required String text,
    required Color backgroundColor,
  }) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFF000000), width: 2.w),
          boxShadow: const [
            BoxShadow(color: Color(0xFF000000), offset: Offset(4, 4)),
          ],
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF000000),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
