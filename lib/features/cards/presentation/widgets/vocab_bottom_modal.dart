import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:basa_app_project/core/widgets/animated_play_pause_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as path;

import '../../domain/entities/cards_detail_entity.dart';

class VocabBottomModal extends StatefulWidget {
  const VocabBottomModal({
    super.key,
    required this.listCard,

    required AudioPlayer audioPlayer,
    required this.cardIndex,
    required this.filePath,
  }) : _audioPlayer = audioPlayer;

  final List<CardsDetailEntity> listCard;
  final File filePath;
  final AudioPlayer _audioPlayer;
  final int cardIndex;

  @override
  State<VocabBottomModal> createState() => _VocabBottomModalState();
}

class _VocabBottomModalState extends State<VocabBottomModal> {
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    widget._audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  void _togglePlay() {
    final rawPath = path.join(
      widget.filePath.parent.path,
      widget.listCard[widget.cardIndex].audioPath.first,
    );
    debugPrint(rawPath);

    if (_isPlaying) {
      widget._audioPlayer.pause();
    } else {
      widget._audioPlayer.play(DeviceFileSource(rawPath.replaceAll('\\', '/')));
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int index = widget.cardIndex;
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 24.h),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Text(
                      widget.listCard[index].defaultLanguage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: TextTheme.of(context)
                            .headlineLarge
                            ?.fontSize,
                        color: Theme.of(context).primaryColor,
                        fontWeight: TextTheme.of(context)
                            .headlineLarge
                            ?.fontWeight,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Text(
                      widget.listCard[index].translatedLanguage,
                      style:
                          Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              if (widget.listCard[index].descriptions.isNotEmpty)
                Card(
                  shadowColor: Theme.of(
                    context,
                  ).shadowColor.withValues(alpha: 0.1),
                  elevation: 2,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.r)),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).primaryColorLight.withValues(alpha: 0.2),
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(
                                context,
                              ).dividerColor.withValues(alpha: 0.1),
                              width: 1.w,
                            ),
                          ),
                        ),
                        child: Text(
                          "Additional Context",
                          style: TextStyle(
                            fontSize: TextTheme.of(
                              context,
                            ).titleMedium?.fontSize,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.listCard[index].descriptions.length,
                          itemBuilder: (context, descIndex) {
                            final description =
                                widget.listCard[index].descriptions[descIndex];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: ListTile(
                                leading: Text(
                                  "•",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                horizontalTitleGap: 8.w,
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  description,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color
                                            ?.withValues(alpha: 0.85),
                                        height: 1.3,
                                      ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 50.h),
              AnimatedPlayPauseButton(
                isPlaying: _isPlaying,
                onPressed: _togglePlay,
                size: 48,
                color: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.all(16.w),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
