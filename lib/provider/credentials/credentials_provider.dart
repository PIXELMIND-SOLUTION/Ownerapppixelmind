// lib/providers/credential_provider.dart

import 'package:client_support_app/models/credential_model.dart';
import 'package:client_support_app/services/crdentials/credential_service.dart';
import 'package:flutter/foundation.dart';


enum CredentialState { idle, loading, success, error }

class CredentialProvider extends ChangeNotifier {
  final CredentialService _service = CredentialService.instance;

  CredentialState _state = CredentialState.idle;
  List<CredentialModel> _credentials = [];
  String _errorMessage = '';

  CredentialState get state => _state;
  List<CredentialModel> get credentials => _credentials;
  String get errorMessage => _errorMessage;
  bool get isLoading => _state == CredentialState.loading;
  bool get hasError => _state == CredentialState.error;

  Future<void> loadCredentials(String clientId) async {
    _setState(CredentialState.loading);
    _errorMessage = '';

    try {
      final response = await _service.fetchCredentials(clientId);
      _credentials = response.credentials;
      _setState(CredentialState.success);
    } catch (e) {
      _errorMessage = e.toString();
      _credentials = [];
      _setState(CredentialState.error);
    }
  }

  void clearCredentials() {
    _credentials = [];
    _errorMessage = '';
    _setState(CredentialState.idle);
  }

  void _setState(CredentialState newState) {
    _state = newState;
    notifyListeners();
  }
}