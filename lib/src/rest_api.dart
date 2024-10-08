import 'dart:convert';
import 'package:http/http.dart' as http;
import 'exceptions.dart';

/// Checks the HTTP response status and throws the appropriate exception.
///
/// Throws [ObjectNotFound] for 404 errors.
/// Throws [Forbidden] for 403 errors.
/// Throws [Unauthorized] for 401 errors.
/// Throws [ObjectAlreadyExists] for 409 errors.
/// Throws [UnknownError] for other 4xx and 5xx errors.
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

  if (response.statusCode == 409) {
    throw ObjectAlreadyExists(response.body);
  }

  if (response.statusCode >= 400 && response.statusCode < 600) {
    throw UnknownError('Error ${response.statusCode}: ${response.body}');
  }
}

/// A class for making HTTP requests to a RESTful API.
///
/// Takes an [apiKey] for authentication and a [baseUrl] for the API endpoint.
class RestAPI {
  final String apiKey;
  late final String baseUrl;

  RestAPI(this.apiKey, String baseUrl) {
    this.baseUrl = '${baseUrl.replaceAll(RegExp(r'/+$'), '')}/api';
  }

  /// ### headers
  /// Generates the necessary HTTP headers for API requests.
  ///
  /// Returns a [Map] containing the 'Authorization' and 'Content-Type' headers.
  Map<String, String> headers() {
    return {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json'
    };
  }

  /// Sends a GET request to the specified [url].
  ///
  /// Throws an [Exception] if the response status indicates an error.
  Future<http.Response> get(String url) async {
    final response =
        await http.get(Uri.parse('$baseUrl$url'), headers: headers());
    _raiseForStatus(response);
    return response;
  }

  /// Sends a DELETE request to the specified [url].
  ///
  /// Throws an [Exception] if the response status indicates an error.
  Future<http.Response> delete(String url) async {
    final response =
        await http.delete(Uri.parse('$baseUrl$url'), headers: headers());
    _raiseForStatus(response);
    return response;
  }

  /// Sends a POST request to the specified [url] with the provided [data].
  ///
  /// Throws an [Exception] if the response status indicates an error.
  Future<http.Response> post(String url, Map<String, dynamic> data,
      {bool useOnlyBareHost = false}) async {
    var targetUrl = Uri.parse('$baseUrl$url');
    if (useOnlyBareHost) {
      targetUrl = Uri.parse('${baseUrl.replaceAll("/api", "")}$url');
    }
    final response = await http.post(
      targetUrl,
      headers: headers(),
      body: jsonEncode(data),
    );
    _raiseForStatus(response);
    return response;
  }

  /// Sends a PATCH request to the specified [url] with the provided [data].
  ///
  /// Throws an [Exception] if the response status indicates an error.
  Future<http.Response> patch(String url, Map<String, dynamic> data) async {
    final response = await http.patch(
      Uri.parse('$baseUrl$url'),
      headers: headers(),
      body: jsonEncode(data),
    );
    _raiseForStatus(response);
    return response;
  }
}
