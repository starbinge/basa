import 'package:audioplayers/audioplayers.dart';
import 'package:basa_app_project/core/data/external_database/external_database_accessor.dart';
import 'package:basa_app_project/core/widgets/animated_play_pause_button.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/vocab_bottom_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;

import '../../domain/entities/cards_detail_entity.dart';

class VocabCard extends StatefulWidget {
  const VocabCard({super.key, required this.listCard, required this.index});

  final List<CardsDetailEntity> listCard;
  final int index;

  @override
  State<VocabCard> createState() => _VocabCardState();
}

class _VocabCardState extends State<VocabCard> {
  bool isPlayed = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlayed = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String filePath = RepositoryProvider.of<ExternalDatabaseAccessor>(
      context,
    ).filePath!;
    final bool hasAudio =
        widget.listCard[widget.index].audioPath.isNotEmpty &&
        widget.listCard[widget.index].audioPath.first.isNotEmpty;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(vertical: 2),
      color: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(5),
      ),
      borderOnForeground: false,
      elevation: 2.0,
      shadowColor: Theme.of(context).disabledColor.withAlpha(30),
      child: ListTile(
        onTap: () => whenCardTap(filePath: filePath),
        onLongPress: () {},
        splashColor: Theme.of(context).primaryColor.withAlpha(100),
        title: Text(
          widget.listCard[widget.index].defaultLanguage,
          style: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontWeight: FontWeight.bold,
            fontSize: TextTheme.of(context).titleLarge?.fontSize,
          ),
        ),
        subtitle: Text(
          widget.listCard[widget.index].translatedLanguage,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        leading: hasAudio
            ? AnimatedPlayPauseButton(
                isPlaying: isPlayed,
                onPressed: () => isPlayed
                    ? onPauseButtonPressed()
                    : onPlayButtonPressed(
                        filePath: filePath,
                        audioPath:
                            widget.listCard[widget.index].audioPath.first,
                      ),
                color: Theme.of(context).primaryColor,
              )
            : null,
      ),
    );
  }

  void onPlayButtonPressed({
    required String filePath,
    required String audioPath,
  }) async {
    setState(() {
      isPlayed = true;
    });
    await _audioPlayer.stop();
    await _audioPlayer.play(DeviceFileSource(path.join(filePath, audioPath)));
  }

  void onPauseButtonPressed() async {
    setState(() {
      isPlayed = false;
    });
    await _audioPlayer.stop();
  }

  void whenCardTap({required String filePath}) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return VocabBottomModal(
          listCard: widget.listCard,
          audioPlayer: _audioPlayer,
          cardIndex: widget.index,
          filePath: filePath,
        );
      },
    ).then((_) => _audioPlayer.stop());
  }
}
