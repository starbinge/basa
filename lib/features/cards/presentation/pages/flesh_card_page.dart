import 'package:basa_app_project/features/cards/presentation/bloc/fetching_card/fetching_cards_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FleshCardPage extends StatefulWidget {
  const FleshCardPage({super.key});

  @override
  State<FleshCardPage> createState() => _FleshCardPageState();
}

class _FleshCardPageState extends State<FleshCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FetchingCardsBloc, FetchingCardsState>(
        builder: (context, state) {
          if (state is FetchingCardIsLoading)
            return CircularProgressIndicator();
          if (state is FetchingCardIsError)
            return Center(child: Text("Something Went Wrong"));
          if (state is FetchingCardIsFinished) {}
          return Center(child: Text("Something unknown"));
        },
      ),
    );
  }
}
