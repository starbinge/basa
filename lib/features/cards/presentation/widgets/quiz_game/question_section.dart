import 'package:audioplayers/audioplayers.dart';
import 'package:basa_app_project/core/constants/screen_size.dart';
import 'package:basa_app_project/core/data/external_database/external_database_accessor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m3e_core/m3e_core.dart';
import 'package:path/path.dart' as path;

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/animated_play_pause_button.dart';

class QuestionSection extends StatefulWidget {
  const QuestionSection({
    super.key,
    required this.activeQuestion,
    required this.question,
    required AudioPlayer audioPlayer,
  }) : _audioPlayer = audioPlayer;
  final int activeQuestion;

  final String question;

  final AudioPlayer _audioPlayer;

  @override
  State<QuestionSection> createState() => _QuestionSectionState();
}

class _QuestionSectionState extends State<QuestionSection> {
  bool _isPlaying = false;

  @override
  void initState() {
    widget._audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    widget._audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = context.screenWidth;
    double cookieSize = (screenWidth * 0.65).clamp(200.0, 260.0);

    return Padding(
          key: ValueKey<int>(widget.activeQuestion),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: SizedBox(
            width: cookieSize,
            height: cookieSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                M3EShape.c9SidedCookie(
                      width: cookieSize,
                      height: cookieSize,
                      color: AppColors.inversePrimary.withValues(alpha: 0.2),
                    )
                    .animate(onComplete: (controller) => controller.repeat())
                    .rotate(
                      curve: Curves.linear,
                      duration: const Duration(seconds: 5),
                    ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child:
                          widget.question.contains(".mp3") ||
                              widget.question.contains(".wav")
                          ? AnimatedPlayPauseButton(
                              isPlaying: _isPlaying,
                              onPressed: () {
                                if (_isPlaying) {
                                  widget._audioPlayer.pause();
                                } else {
                                  widget._audioPlayer.play(
                                    DeviceFileSource(
                                      path
                                          .join(
                                            RepositoryProvider.of<
                                                  ExternalDatabaseAccessor
                                                >(context)
                                                .filePath!,
                                            widget.question,
                                          )
                                          .replaceAll('\\', '/'),
                                    ),
                                  );
                                }
                                setState(() {
                                  _isPlaying = !_isPlaying;
                                });
                              },
                              size: 60,
                              color: AppColors.primaryDark,
                            )
                          : Text(
                              widget.question,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    color: AppColors.primaryDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .animate(key: ValueKey<int>(widget.activeQuestion))
        .scale(
          curve: Curves.fastEaseInToSlowEaseOut,
          duration: const Duration(milliseconds: 300),
        );
  }
}
