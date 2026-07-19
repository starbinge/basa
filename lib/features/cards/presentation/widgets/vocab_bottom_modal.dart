import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as path;

import '../../domain/entities/cards_detail_entity.dart';

class VocabBottomModal extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final int index = cardIndex;
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
                      textAlign: TextAlign.center,
                      listCard[index].defaultLanguage,
                      style: TextStyle(
                        fontSize: TextTheme.of(context).headlineLarge?.fontSize,
                        color: Theme.of(context).primaryColor,
                        fontWeight: TextTheme.of(
                          context,
                        ).headlineLarge?.fontWeight,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Text(
                      listCard[index].translatedLanguage,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              if (listCard[index].descriptions.isNotEmpty)
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
                          itemCount: listCard[index].descriptions.length,
                          itemBuilder: (context, descIndex) {
                            final description =
                                listCard[index].descriptions[descIndex];
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
              IconButton(
                style: ButtonStyle(
                  maximumSize: WidgetStateProperty.all(Size(100.w, 100.h)),
                  minimumSize: WidgetStateProperty.all(Size(60.w, 60.h)),
                  foregroundColor: const WidgetStatePropertyAll<Color>(
                    Colors.white,
                  ),
                  backgroundColor: WidgetStatePropertyAll<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () {
                  final rawPath = path.join(
                    filePath.parent.path,
                    listCard[index].audioPath.first,
                  );
                  debugPrint(rawPath);
                  _audioPlayer.play(
                    DeviceFileSource(rawPath.replaceAll('\\', '/')),
                  );
                },
                icon: const Icon(Icons.play_arrow),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
