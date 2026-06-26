import 'dart:io';
import 'package:basa_app_project/core/database/initial_database/initial_database.dart';
import 'package:basa_app_project/core/services/external_database_accessor.dart';
import 'package:basa_app_project/features/cards/data/repositories/card_repo_impl.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/fetching_card/fetching_cards_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainCardPage extends StatefulWidget {
  const MainCardPage({
    super.key,
    required this.deckId,
    required this.fileName,
    required this.filePath,
  });

  final int deckId;
  final String fileName;
  final File filePath;

  @override
  State<MainCardPage> createState() => _MainCardPageState();
}

class _MainCardPageState extends State<MainCardPage> {
  FetchingCardsBloc? _bloc;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final accessor = RepositoryProvider.of<ExternalDatabaseAccessor>(context);
    final db = await accessor.fetchAnkiDatabase(
      pathFile: widget.filePath,
      fileName: widget.fileName,
    );
    final decksDao = await RepositoryProvider.of<AppDatabase>(context).decksDao;
    final repo = await CardRepoImpl(decksDao: decksDao, cardsDao: db.cardsDao);

    debugPrint("trying to fetch");

    await repo.getCardById(cardId: 1335782638416);
    debugPrint(repo.oneCardById?.defaultLanguage.toString());
    setState(() {
      _bloc = FetchingCardsBloc(cardRepo: repo);
    });
  }

  @override
  void dispose() {
    _bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return BlocProvider.value(
      value: _bloc!,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.fileName)),
        body: const Center(child: Text("Test: BLoC Berhasil Diinisialisasi!")),
      ),
    );
  }
}
