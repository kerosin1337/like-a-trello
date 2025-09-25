import 'package:dio/dio.dart';

import '/shared/constants/duration.dart';
import '/shared/constants/url.dart';
import 'interceptors/auth_interceptor.dart';

Dio _defaultDio = Dio(
  BaseOptions(
    baseUrl: apiUrl,
    connectTimeout: dioTimeout,
    receiveTimeout: dioTimeout,
    sendTimeout: dioTimeout,
  ),
);

class DioClient {
  final Dio _dioClient;

  DioClient() : _dioClient = _defaultDio {
    _dioClient.interceptors.addAll([AuthInterceptor(_dioClient)]);
  }

  Dio get dio => _dioClient;
}
