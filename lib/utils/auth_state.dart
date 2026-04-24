import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class AuthState extends ChangeNotifier {
  Client? _currentClient;
  bool _isLoading = false;
  String? _error;
  List<AppAlert> _alerts = [];
  final Set<String> _readAlertIds = {};

  Client? get currentClient => _currentClient;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentClient != null;

  List<AppAlert> get alerts => _alerts;
  int get unreadCount => _alerts.where((a) => !_readAlertIds.contains(a.id)).length;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));

    final storedPass = mockLoginCredentials[email.toLowerCase()];
    if (storedPass != null && storedPass == password) {
      _currentClient = mockClients[email.toLowerCase()];
      _alerts = getMockAlerts(_currentClient!);
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _error = 'Invalid email or password. Contact your administrator.';
    _isLoading = false;
    notifyListeners();
    return false;
  }

  void logout() {
    _currentClient = null;
    _alerts = [];
    _readAlertIds.clear();
    notifyListeners();
  }

  void markAlertRead(String alertId) {
    _readAlertIds.add(alertId);
    notifyListeners();
  }

  void markAllRead() {
    for (final alert in _alerts) {
      _readAlertIds.add(alert.id);
    }
    notifyListeners();
  }

  bool isAlertRead(String alertId) => _readAlertIds.contains(alertId);
}
