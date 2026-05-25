import 'package:flutter/material.dart';

@immutable
class DeckImportState {
  final String filePath;
  final bool isLoading;
  final bool isFinished;
  final bool isError;
  final String errorMessage;
  final bool isDeckExist;

  const DeckImportState({
    required this.filePath,
    required this.isLoading,
    required this.isFinished,
    required this.isError,
    required this.errorMessage,
    required this.isDeckExist,
  });

  DeckImportState copyWith({
    String? filePath,
    bool? isLoading,
    bool? isFinished,
    bool? isError,
    String? errorMessage,
    bool? isDeckExist,
  }) {
    return DeckImportState(
      filePath: filePath ?? this.filePath,
      isLoading: isLoading ?? this.isLoading,
      isFinished: isFinished ?? this.isFinished,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
      isDeckExist: isDeckExist ?? this.isDeckExist,
    );
  }
}
