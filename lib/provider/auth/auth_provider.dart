// lib/providers/auth_provider.dart

import 'package:client_support_app/helper/storage_helper.dart';
import 'package:client_support_app/models/client_model.dart';
import 'package:client_support_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';


enum AuthStatus { idle, loading, authenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthStatus  _status  = AuthStatus.idle;
  ClientModel? _client;
  String       _errorMessage = '';

  // ── Getters ───────────────────────────────────────
  AuthStatus   get status       => _status;
  ClientModel? get client       => _client;
  String       get errorMessage => _errorMessage;
  bool         get isLoading    => _status == AuthStatus.loading;
  bool         get isLoggedIn   => _status == AuthStatus.authenticated;

  // ── Login ─────────────────────────────────────────
  Future<bool> login({
    required String phone,
    required String password,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = '';
    notifyListeners();

    final result = await _authService.clientLogin(
      phone:    phone,
      password: password,
    );

    if (result['success'] == true) {
      _client = result['client'] as ClientModel;
      await PreferenceHelper.saveClient(_client!);
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'] as String;
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  // ── Restore session on app launch ─────────────────
  Future<void> restoreSession() async {
    final savedClient = await PreferenceHelper.getClient();
    if (savedClient != null) {
      _client = savedClient;
      _status = AuthStatus.authenticated;
      notifyListeners();
    }
  }

  // ── Logout ────────────────────────────────────────
  Future<void> logout() async {
    await PreferenceHelper.clearSession();
    _client = null;
    _status = AuthStatus.idle;
    notifyListeners();
  }
}