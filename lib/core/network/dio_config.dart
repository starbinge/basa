import 'package:dio/dio.dart';

class Network {
  static final Dio  api = Dio(
    BaseOptions(
      baseUrl: "https://basa-backend.vercel.app/api/",
    )
  );
}