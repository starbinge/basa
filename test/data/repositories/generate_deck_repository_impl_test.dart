import 'dart:convert';
import 'dart:typed_data';

import 'package:basa_app_project/features/decks/data/repositories/generate_deck_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHttpClientAdapter implements HttpClientAdapter {
  _FakeHttpClientAdapter(this.statusCode, this.body);

  final int statusCode;
  final String body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      body,
      statusCode,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late Dio dio;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://example.com/api/'));
  });

  test('accepts 201 Created and returns the parsed json', () async {
    dio.httpClientAdapter = _FakeHttpClientAdapter(
      201,
      jsonEncode({
        'language': 'Korea',
        'rolePlay': 'A student',
        'difficulty': 'beginner',
        'listCards': [],
      }),
    );

    final repo = GenerateDeckRepositoryImpl(dio: dio);
    final result = await repo.generateDeck(
      requestData: {'defaultLanguage': 'Indonesia'},
    );

    expect(result['language'], 'Korea');
    expect(result['listCards'], isEmpty);
  });

  test('accepts 200 OK', () async {
    dio.httpClientAdapter = _FakeHttpClientAdapter(
      200,
      jsonEncode({'language': 'Korea', 'listCards': []}),
    );

    final repo = GenerateDeckRepositoryImpl(dio: dio);
    final result = await repo.generateDeck(requestData: {});

    expect(result['language'], 'Korea');
  });

  test('throws when the status code is non-2xx', () async {
    dio.httpClientAdapter = _FakeHttpClientAdapter(500, 'boom');

    final repo = GenerateDeckRepositoryImpl(dio: dio);

    await expectLater(
      repo.generateDeck(requestData: {}),
      throwsA(isA<Exception>()),
    );
  });
}
