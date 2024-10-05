import 'dart:convert';
import 'package:http/http.dart' as http;
import 'exceptions.dart';

void _raiseForStatus(http.Response response) {
  if (response.statusCode == 404) {
    throw ObjectNotFound(response.body);
  }

  if (response.statusCode == 403) {
    throw Forbidden(response.body);
  }

  if (response.statusCode == 401) {
    throw Unauthorized(response.body);
  }

  if (response.statusCode >= 400 && response.statusCode < 600) {
    throw UnknownError('Error ${response.statusCode}: ${response.body}');
  }
}

class RestAPI {
  final String apiKey;
  late final String baseUrl;

  RestAPI(this.apiKey, String baseUrl) {
    this.baseUrl = '${baseUrl.replaceAll(RegExp(r'/+$'), '')}/api';
  }

  Map<String, String> _headers() {
    return {'Authorization': 'Bearer $apiKey'};
  }

  Future<http.Response> get(String url) async {
    final response =
        await http.get(Uri.parse('$baseUrl$url'), headers: _headers());
    _raiseForStatus(response);
    return response;
  }

  Future<http.Response> delete(String url) async {
    final response =
        await http.delete(Uri.parse('$baseUrl$url'), headers: _headers());
    _raiseForStatus(response);
    return response;
  }

  Future<http.Response> post(String url, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl$url'),
      headers: _headers(),
      body: jsonEncode(data),
    );
    _raiseForStatus(response);
    return response;
  }

  Future<http.Response> patch(String url, Map<String, dynamic> data) async {
    final response = await http.patch(
      Uri.parse('$baseUrl$url'),
      headers: _headers(),
      body: jsonEncode(data),
    );
    _raiseForStatus(response);
    return response;
  }
}
