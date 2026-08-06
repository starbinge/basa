import 'package:basa_app_project/features/decks/domain/repositories/generate_deck_repo.dart';
import 'package:dio/dio.dart';

class GenerateDeckRepositoryImpl implements GenerateDeckRepo {
  final Dio _dio;

  GenerateDeckRepositoryImpl({required Dio dio}) : _dio = dio;

  @override
  Future<Map<String, dynamic>> generateDeck({
    required Map<String, dynamic> requestData,
  }) async {
    final result = await _dio.post('generate-deck', data: requestData);
    final int? statusCode = result.statusCode;
    if (statusCode == null || statusCode < 200 || statusCode >= 300) {
      throw Exception(result.statusMessage ?? 'Failed to generate deck');
    }
    return result.data as Map<String, dynamic>;
  }
}
