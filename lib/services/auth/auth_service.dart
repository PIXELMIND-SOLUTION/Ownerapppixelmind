// lib/services/auth_service.dart

import 'dart:convert';
import 'package:client_support_app/constant/api_constant.dart';
import 'package:client_support_app/models/client_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<Map<String, dynamic>> clientLogin({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.clientLogin),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone': phone,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      print(
          'Response status code for Loginnnnnnnnnnnnnnnnnnnnnnnn ${response.statusCode}');
      print(
          'Response bodyyyyyyyyyyyyy for Loginnnnnnnnnnnnnnnnnnnnnnnn ${response.body}');

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'message': data['message'],
          'client':
              ClientModel.fromJson(data['client'] as Map<String, dynamic>),
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Something went wrong: $e',
      };
    }
  }
}
