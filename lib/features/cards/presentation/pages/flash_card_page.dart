import 'dart:ffi';

import 'package:basa_app_project/core/widgets/button.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/fetching_card/fetching_cards_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/flash_card/flash_card_bloc.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/flash_card_slider.dart';

class FleshCardPage extends StatefulWidget {
  const FleshCardPage({super.key});

  @override
  State<FleshCardPage> createState() => _FleshCardPageState();
}

class _FleshCardPageState extends State<FleshCardPage> {
  final PageController _pageController = PageController();
  final FlipCardController _flipCardController = FlipCardController();
  bool isThisBack = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FlashCardBloc, FlashCardState>(
        builder: (context, state) {
          if (state is FlashCardIsLoading) return CircularProgressIndicator();
          if (state is FLashCardIsError)
            return Center(child: Text("Something Went Wrong"));
          if (state is FLashCardIsFinished) {
            final List<CardsDetailEntity> flashCards = state.listCard;
            return SafeArea(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: Center(child: Text("Flash Card")),
                  ),
                  Expanded(
                    child: FlashCardSlider(
                      itemCount: flashCards.length,
                      flashCards: flashCards,
                      flipCardController: _flipCardController,
                      pageController: _pageController,
                      onCardFlipped: (isBack) {
                        setState(() {
                          isThisBack = isBack;
                        });
                        debugPrint(isThisBack.toString());
                      },
                      onPageChanged: (int value) {},
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          style: ButtonStyle(
                            iconSize: WidgetStatePropertyAll(30),
                            foregroundColor: WidgetStatePropertyAll(
                              Colors.white,
                            ),
                            backgroundColor: WidgetStatePropertyAll(
                              isThisBack
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context).disabledColor,
                            ),
                          ),
                          onPressed: isThisBack
                              ? () {
                                  setState(() {
                                    isThisBack = false;
                                  });
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              : null,
                          icon: Icon(Icons.close),
                        ),
                        IconButton(
                          style: ButtonStyle(
                            iconSize: WidgetStatePropertyAll(30),
                            foregroundColor: WidgetStatePropertyAll(
                              Colors.white,
                            ),
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.black,
                            ),
                          ),
                          onPressed: () {
                            _flipCardController.toggleCard();
                          },
                          icon: Icon(Icons.flip_camera_android),
                        ),
                        IconButton(
                          style: ButtonStyle(
                            iconSize: WidgetStatePropertyAll(30),
                            foregroundColor: WidgetStatePropertyAll(
                              Colors.white,
                            ),
                            backgroundColor: WidgetStatePropertyAll(
                              isThisBack
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).disabledColor,
                            ),
                          ),
                          onPressed: isThisBack
                              ? () {
                                  _flipCardController.toggleCard();
                                }
                              : null,
                          icon: Icon(Icons.check),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(child: Text("Something unknown"));
        },
      ),
    );
  }
}
