import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileController with ChangeNotifier {
  String _username = '';
  String _email = '';
  String _phoneNumber = '';
  String _address = '';
  String _roleName = '';
  bool _isActive = false;
  String _imageUrl = '';

  bool _isLoading = true;
  String _errorMessage = '';

  String get username => _username;
  String get email => _email;
  String get phoneNumber => _phoneNumber;
  String get address => _address;
  String get roleName => _roleName;
  bool get isActive => _isActive;
  String get imageUrl => _imageUrl;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchUserData() async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token =await prefs.getString('tokenKey') ?? '';

      if (token.isEmpty) {
        _errorMessage = 'No token found. Please login again.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final url = 'http://152.67.10.128:5280/api/auth/Get-Data-token?token=$token';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        _username = data['userName'] ?? 'Unknown';
        _email = data['email'] ?? 'No Email';
        _phoneNumber = data['phoneNumber'] ?? 'No Phone';
        _address = data['address'] ?? 'No Address';
        _roleName = data['role']?['name'] ?? 'No Role';
        _isActive = data['isactive'] ?? false;
        _imageUrl = data['imageUrl'] ?? '';

        _isLoading = false;
      } else {
        _errorMessage = 'Failed to load profile data. Try again later.';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
