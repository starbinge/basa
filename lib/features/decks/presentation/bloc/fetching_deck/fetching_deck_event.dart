import 'package:flutter/material.dart';

@immutable
sealed class FetchingDeckEvent {}

class FetchDecksList extends FetchingDeckEvent {}
