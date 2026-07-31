import 'dart:async';

import 'package:basa_app_project/core/widgets/animated_header.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/shared/vocab_cards.dart';
import 'package:flutter/material.dart';

class VocabularyListContainer extends StatefulWidget {
  const VocabularyListContainer({
    super.key,
    required this.searchValue,
    required this.filteredCards,
    required this.listCards,
  });

  final void Function(String value) searchValue;
  final List<CardsDetailEntity> filteredCards;
  final List<CardsDetailEntity> listCards;

  @override
  State<VocabularyListContainer> createState() =>
      _VocabularyListContainerState();
}

class _VocabularyListContainerState extends State<VocabularyListContainer> {
  SearchController _searchController = SearchController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        Text("Vocabularies", style: Theme.of(context).textTheme.headlineMedium),
        SizedBox(height: 10),
        SearchBar(
          controller: _searchController,
          onChanged: (value) {
            if (_debounce?.isActive ?? false) {
              _debounce?.cancel();
            }

            _debounce = Timer(const Duration(milliseconds: 500), () {
              setState(() {
                widget.searchValue(value);
              });
            });
          },
          side: WidgetStatePropertyAll(
            BorderSide(width: 0.8, color: Colors.grey.withValues(alpha: 0.2)),
          ),
          hintText: "Search Vocabularies...",
          elevation: WidgetStatePropertyAll(0),
          trailing: {
            Padding(
              padding: EdgeInsetsGeometry.all(10),
              child: Icon(Icons.search),
            ),
          },
        ),
        Container(
          padding: EdgeInsets.all(5),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 0.5,
              color: Colors.grey.withValues(alpha: 0.2),
            ),
          ),
          constraints: BoxConstraints(maxHeight: 500),
          child: _sharedUi(),
        ),
      ],
    );
  }

  Widget _sharedUi() {
    if (_searchController.text.isNotEmpty) {
      if (widget.filteredCards.isEmpty) {
        return const Center(
          child: AnimatedHeader(
            icon: Icons.exposure_zero,
            title: "Card Has Not Found",
          ),
        );
      }
      return _buildListView(widget.filteredCards);
    }

    if (widget.listCards.isEmpty) {
      return const Center(
        child: AnimatedHeader(
          icon: Icons.exposure_zero,
          title: "Card Has Not Found",
        ),
      );
    }

    return _buildListView(widget.listCards);
  }

  Widget _buildListView(List<CardsDetailEntity> cards) {
    return Scrollbar(
      child: ListView.builder(
        padding: EdgeInsetsGeometry.zero,
        itemCount: cards.length,
        itemBuilder: (context, int itemIndex) {
          return VocabCard(listCard: cards, index: itemIndex);
        },
      ),
    );
  }
}
