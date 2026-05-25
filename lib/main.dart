import 'package:basa_app_project/core/database/initial_database/initial_database.dart';
import 'package:basa_app_project/core/router/app_router.dart';
import 'package:basa_app_project/core/services/file_picker.dart';
import 'package:basa_app_project/core/theme/app_theme.dart';
import 'package:basa_app_project/features/cards/data/repositories/card_repo_impl.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/fetching_card/fetching_cards_bloc.dart';
import 'package:basa_app_project/features/decks/data/repositories/deck_repository_impl.dart';
import 'package:basa_app_project/features/decks/presentation/bloc/deck_import/deck_import_bloc.dart';
import 'package:basa_app_project/features/decks/presentation/bloc/fetching_deck/fetching_deck_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  runApp(Provider<AppDatabase>.value(value: database, child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FetchingDeckBloc>(
          create: (context) {
            final decksDao = context.read<AppDatabase>().decksDao;
            final repository = DeckRepositoryImpl(decksDao: decksDao);
            return FetchingDeckBloc(repository: repository);
          },
        ),
        BlocProvider<DeckImportBloc>(
          create: (context) {
            final decksDao = context.read<AppDatabase>().decksDao;
            final repository = DeckRepositoryImpl(decksDao: decksDao);
            return DeckImportBloc(
              repository: repository,
              filePicker: FilePickerService(),
            );
          },
        ),
        BlocProvider<FetchingCardsBloc>(
          create: (context) {
            final decksDao = context.read<AppDatabase>().decksDao;
            return FetchingCardsBloc(
              cardRepo: CardRepoImpl(decksDao: decksDao),
            );
          },
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Basa',
        theme: AppTheme.light,
        routerConfig: appRouter,
      ),
    );
  }
}
