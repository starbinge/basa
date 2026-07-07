import 'package:basa_app_project/core/router/app_router.dart';
import 'package:basa_app_project/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/data/external_database/external_database_accessor.dart';
import 'core/data/initial_database/initial_database.dart';
import 'features/decks/data/repositories/deck_repository_impl.dart';
import 'features/decks/domain/repositories/deck_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialDb = AppDatabase();
  final dbAccessor = ExternalDatabaseAccessor();
  final deckRepository = DeckRepositoryImpl(decksDao: initialDb.decksDao);
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AppDatabase>.value(value: initialDb),
        RepositoryProvider<ExternalDatabaseAccessor>.value(value: dbAccessor),
        RepositoryProvider<DeckRepository>.value(value: deckRepository),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Basa',
        theme: AppTheme.light(context),
        routerConfig: appRouter,
      ),
    );
  }
}
