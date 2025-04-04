import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:frontend/utils/constants.dart';

class ApiService {
  final String? token;

  ApiService({this.token});

  Future<http.Response> get(String url) async {
    return await http.get(
      Uri.parse(url),
      headers: _getHeaders(),
    );
  }

  Future<http.Response> post(String url, dynamic body) async {
    return await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: _getHeaders(),
    );
  }

  Future<http.Response> put(String url, dynamic body) async {
    return await http.put(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: _getHeaders(),
    );
  }

  Future<http.Response> delete(String url) async {
    return await http.delete(
      Uri.parse(url),
      headers: _getHeaders(),
    );
  }

  Map<String, String> _getHeaders() {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }
}