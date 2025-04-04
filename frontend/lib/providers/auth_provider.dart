import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/utils/constants.dart';

class AuthProvider with ChangeNotifier {
  final AuthService authService;
  final ApiService apiService;

  AuthProvider({required this.authService, required this.apiService});

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(User user) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await apiService.post(ApiConstants.loginUrl, user.toJson());
      
      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['access_token'];
        await authService.saveToken(token);
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
    await authService.deleteToken();
    notifyListeners();
  }
}