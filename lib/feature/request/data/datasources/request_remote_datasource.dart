import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/http/api_constants.dart';
import '../models/request_model.dart';

class RequestRemoteDataSource {
  final String requestUrl = ApiConstants.requestService;

  Future<RequestModel> createRequest(Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse(requestUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    final json = jsonDecode(res.body);

    if (res.statusCode == 201) {
      return RequestModel.fromJson(json);
    }

    throw Exception(json['message'] ?? 'Error creating request');
  }

  Future<void> acceptRequest(String uuid) async {
    final res = await http.post(Uri.parse('$requestUrl/accept/$uuid'));

    if (res.statusCode != 200) {
      final json = jsonDecode(res.body);
      throw Exception(json['message']);
    }
  }
}
