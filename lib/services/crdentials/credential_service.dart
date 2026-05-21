// lib/services/credential_service.dart

import 'dart:convert';
import 'package:client_support_app/constant/api_constant.dart';
import 'package:client_support_app/models/credential_model.dart';
import 'package:http/http.dart' as http;

class CredentialService {
  CredentialService._();

  static final CredentialService instance = CredentialService._();

  Future<CredentialsResponse> fetchCredentials(String clientId) async {
    final url = Uri.parse(ApiConstants.clientCredentials(clientId));

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print(
          'Response status code for get all credentials ${response.statusCode}');
      print(
          'Response bodyyyyyyyyyyyyy for get all credentials ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return CredentialsResponse.fromJson(json);
      } else {
        throw Exception(
          'Failed to fetch credentials. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching credentials: $e');
    }
  }
}
