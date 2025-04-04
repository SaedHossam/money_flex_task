import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/models/customer.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/utils/constants.dart';

class CustomerProvider with ChangeNotifier {
  final ApiService _apiService;
  List<Customer> _customers = [];
  bool _isLoading = false;
  String? _errorMessage;

  CustomerProvider(this._apiService);

  List<Customer> get customers => _customers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchCustomers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.get(ApiConstants.customersUrl);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _customers = data.map((json) => Customer.fromJson(json)).toList();
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to load customers';
      }
    } catch (e) {
      _errorMessage = 'An error occurred. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createCustomer(Customer customer) async {
    _isLoading = true;
    _errorMessage = null; // clear previous error
    notifyListeners();

    try {
      final response = await _apiService.post(
        ApiConstants.customersUrl,
        customer.toJson(),
      );

      if (response.statusCode == 201) {
        await fetchCustomers();
        return true;
      } else {
        // Try to decode and extract the backend error message
        try {
          final data = json.decode(response.body);
          _errorMessage = data['message'] ?? 'Failed to create customer';
        } catch (_) {
          _errorMessage = 'Failed to create customer';
        }
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

  Future<Customer?> getCustomerById(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.get(
        '${ApiConstants.customersUrl}/$id',
      );
      if (response.statusCode == 200) {
        return Customer.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateCustomer(Customer customer, int customerId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.put(
        '${ApiConstants.customersUrl}/$customerId',
        customer.toJson(),
      );
      if (response.statusCode == 200) {
        await fetchCustomers();
        return true;
      } else {
        try {
          final data = json.decode(response.body);
          _errorMessage = data['message'] ?? 'Failed to create customer';
        } catch (_) {
          _errorMessage = 'Failed to create customer';
        }
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

  Future<bool> deleteCustomer(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.delete(
        '${ApiConstants.customersUrl}/$id',
      );
      if (response.statusCode == 200) {
        await fetchCustomers();
        return true;
      } else {
        _errorMessage = 'Failed to delete customer';
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
}
