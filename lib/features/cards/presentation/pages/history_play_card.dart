import 'package:basa_app_project/core/data/external_database/external_database_accessor.dart';
import 'package:basa_app_project/core/pages/error_page.dart';
import 'package:basa_app_project/features/cards/data/repositories/history_repo_impl.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/history/history_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/history/history_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryPlayCard extends StatelessWidget {
  const HistoryPlayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Histories"), centerTitle: true),
      body: BlocProvider(
        create: (context) => HistoryBloc(
          historyCardRepo: HistoryRepoImpl(
            historyDao: RepositoryProvider.of<ExternalDatabaseAccessor>(
              context,
            ).historyDao!,
          ),
        )..add(getHistory()),
        child: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state is HistoryIsLoading) return const CircularProgressIndicator();
            if (state is HistoryIsError)
              return ErrorPage(message: state.errorMessage);
            if (state is HistoryIsFinished)
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsetsGeometry.all(10),
                    sliver: SliverMainAxisGroup(
                      slivers: [
                        SliverToBoxAdapter(
                          child: HistoryContainer(
                            timeLabel: state.today.labelTime,
                            listCard: state.today.listCards,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: HistoryContainer(
                            timeLabel: state.weekly.labelTime,
                            listCard: state.weekly.listCards,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: HistoryContainer(
                            timeLabel: state.monthly.labelTime,
                            listCard: state.monthly.listCards,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            return const ErrorPage(message: "Unkown Error");
          },
        ),
      ),
    );
  }
}
