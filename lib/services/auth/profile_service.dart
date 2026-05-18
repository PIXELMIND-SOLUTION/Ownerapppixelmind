// lib/services/client_service.dart

// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:client_support_app/constant/api_constant.dart';
import 'package:client_support_app/models/profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ClientService {
  ClientService._();
  static final ClientService instance = ClientService._();

  Future<ProfileModel> fetchClientProfile(String clientId) async {
    final uri = Uri.parse(ApiConstants.clientProfile(clientId));

    final response = await http.get(uri, headers: _jsonHeaders());

    print(
        '📊 Response Status Code for get profile Api: ${response.statusCode}');
    print('🔍 Response Body for get profile api: ${response.body}');

    _throwIfError(response);

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return ProfileModel.fromJson(body['client'] as Map<String, dynamic>);
  }

  Future<String> uploadProfileImage({
    required String clientId,
    required File imageFile,
  }) async {
    final uri = Uri.parse(ApiConstants.uploadProfileImage(clientId));

    final ext = imageFile.path.split('.').last.toLowerCase();
    final mime = ext == 'png'
        ? 'png'
        : ext == 'webp'
            ? 'webp'
            : 'jpeg';

    final request = http.MultipartRequest('POST', uri)
      ..files.add(
        await http.MultipartFile.fromPath(
          'profileImage',
          imageFile.path,
          contentType: MediaType('image', mime),
        ),
      );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    print(
        '✅ Response Status Code for update profile image: ${response.statusCode}');
    print('📡 Response Body for update profile image: ${response.body}');

    _throwIfError(response);

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return body['profileImage'] as String? ??
        body['client']?['profileImage'] as String? ??
        '';
  }

  Map<String, String> _jsonHeaders() => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  void _throwIfError(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final body = _tryDecode(response.body);
      final message = body?['message'] as String? ??
          'Request failed (${response.statusCode})';
      throw Exception(message);
    }
  }

  Map<String, dynamic>? _tryDecode(String raw) {
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}
