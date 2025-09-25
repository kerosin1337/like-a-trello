import 'package:dio/dio.dart';

Future<FormData> createFormData(Map<String, dynamic> map) async {
  return FormData.fromMap(map);
}
