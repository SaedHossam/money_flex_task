import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/utils/constants.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(User user) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.post(ApiConstants.loginUrl, user.toJson());
      
      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['access_token'];
        await _authService.saveToken(token);
        _errorMessage = null;
        return true;
      } else {
        _errorMessage = 'Invalid credentials';
        return false;
      }
    } catch (e) {
      _errorMessage = 'An error occurred. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.deleteToken();
    notifyListeners();
  }
}