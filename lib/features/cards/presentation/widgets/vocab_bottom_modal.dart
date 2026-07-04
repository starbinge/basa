import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import '../../domain/entities/cards_detail_entity.dart';
import '../pages/main_card_page.dart';

class VocabBottomModal extends StatelessWidget {
  const VocabBottomModal({
    super.key,
    required this.listCard,
    required this.widget,
    required AudioPlayer audioPlayer,
    required this.cardIndex,
  }) : _audioPlayer = audioPlayer;

  final List<CardsDetailEntity> listCard;
  final MainCardPage widget;
  final AudioPlayer _audioPlayer;
  final int cardIndex;

  @override
  Widget build(BuildContext context) {
    final int index = cardIndex;
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24.0),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
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
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      listCard[index].translatedLanguage,
                      style: TextStyle(
                        fontSize: TextTheme.of(context).bodyLarge?.fontSize,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (listCard[index].descriptions.isNotEmpty)
                Card(
                  shadowColor: Theme.of(
                    context,
                  ).shadowColor.withValues(alpha: 0.1),
                  elevation: 2,
                  clipBehavior: Clip.antiAlias,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
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
                              width: 1,
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
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: listCard[index].descriptions.length,
                          itemBuilder: (context, descIndex) {
                            final description =
                                listCard[index].descriptions[descIndex];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: ListTile(
                                leading: const Text(
                                  "•",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                horizontalTitleGap: 8,
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  description,
                                  style: TextStyle(
                                    fontSize: TextTheme.of(
                                      context,
                                    ).bodyMedium?.fontSize,
                                    color: TextTheme.of(context)
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
              const SizedBox(height: 50),
              IconButton(
                style: ButtonStyle(
                  maximumSize: WidgetStateProperty.all(const Size(100, 100)),
                  minimumSize: WidgetStateProperty.all(const Size(60, 60)),
                  foregroundColor: const WidgetStatePropertyAll<Color>(
                    Colors.white,
                  ),
                  backgroundColor: WidgetStatePropertyAll<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () {
                  final rawPath = path.join(
                    widget.filePath.parent.path,
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
