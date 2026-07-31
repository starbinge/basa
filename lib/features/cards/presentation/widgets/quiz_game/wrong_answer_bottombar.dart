import 'package:audioplayers/audioplayers.dart';
import 'package:basa_app_project/core/theme/app_colors.dart';
import 'package:basa_app_project/core/widgets/animated_header.dart';
import 'package:basa_app_project/core/widgets/animated_play_pause_button.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:flutter/material.dart';

class WrongAnswerBottombar extends StatefulWidget {
  const WrongAnswerBottombar({
    super.key,
    required this.selectedCard,
    required this.audioPlayer,
    required this.playButtonPressed,
    required this.pauseButtonPressed,
    required this.textButtonPressed,
  });

  final CardsDetailEntity? selectedCard;
  final AudioPlayer audioPlayer;
  final VoidCallback playButtonPressed;
  final VoidCallback pauseButtonPressed;
  final VoidCallback textButtonPressed;

  @override
  State<WrongAnswerBottombar> createState() => _WrongAnswerBottombarState();
}

class _WrongAnswerBottombarState extends State<WrongAnswerBottombar> {
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    widget.audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  double _dynamicFontSize(String text) {
    final int length = text.length;
    if (length <= 10) return 48;
    if (length <= 20) return 36;
    if (length <= 30) return 28;
    if (length <= 50) return 22;
    return 18;
  }

  void _togglePlay() {
    if (_isPlaying) {
      widget.pauseButtonPressed();
    } else {
      widget.playButtonPressed();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String translatedText = widget.selectedCard?.translatedLanguage ?? "";
    final String defaultText = widget.selectedCard?.defaultLanguage ?? "";

    return Container(
      decoration: BoxDecoration(
        color: AppColors.errorContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      width: double.infinity,
      height: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Wrong Answer",
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.error),
          ),
          if (widget.selectedCard == null)
            AnimatedHeader(
              icon: Icons.hourglass_empty_rounded,
              title: "Cards Not Found",
              subtitle: "Something is wrong with the card.",
            ),

          Column(
            children: [
              Text(
                translatedText,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.error,
                  fontSize: _dynamicFontSize(translatedText),
                ),
              ),
              Text(
                defaultText,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.error,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          AnimatedPlayPauseButton(
            isPlaying: _isPlaying,
            onPressed: _togglePlay,
            size: 60,
            color: AppColors.error,
            backgroundColor: const Color.fromARGB(
              255,
              223,
              57,
              57,
            ).withValues(alpha: 0.2),
          ),
          TextButton(
            onPressed: widget.textButtonPressed,
            child: Text("Yes, I understood!"),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.error),
              foregroundColor: WidgetStatePropertyAll(AppColors.errorContainer),
            ),
          ),
        ],
      ),
    );
  }
}
