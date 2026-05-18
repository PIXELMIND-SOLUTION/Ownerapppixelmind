// lib/helpers/preference_helper.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/client_model.dart';

class PreferenceHelper {
  PreferenceHelper._();

  static const String _keyIsLoggedIn  = 'is_logged_in';
  static const String _keyClientData  = 'client_data';

  static Future<void> saveClient(ClientModel client) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyClientData, jsonEncode(client.toJson()));
  }

  static Future<ClientModel?> getClient() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyClientData);
    if (raw == null) return null;
    return ClientModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyClientData);
  }
}