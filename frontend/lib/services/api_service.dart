import 'dart:convert';
import 'package:frontend/services/auth_service.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final AuthService authService;

  ApiService({required this.authService});

  Future<http.Response> get(String url) async {
    return await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );
  }

  Future<http.Response> post(String url, dynamic body) async {
    return await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: await _getHeaders(),
    );
  }

  Future<http.Response> put(String url, dynamic body) async {
    return await http.put(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: await _getHeaders(),
    );
  }

  Future<http.Response> delete(String url) async {
    return await http.delete(
      Uri.parse(url),
      headers: await _getHeaders(),
    );
  }

  Future<Map<String, String>> _getHeaders() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    String? token = await authService.getToken(); // Get the token from AuthService
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }
}