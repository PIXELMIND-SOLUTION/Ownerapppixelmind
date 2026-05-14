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
  int get unreadCount =>
      _alerts.where((a) => !_readAlertIds.contains(a.id)).length;

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

  void addProject(Project project) {
    if (_currentClient == null) return;
    final updatedProjects = List<Project>.from(_currentClient!.projects)
      ..add(project);
    _currentClient = Client(
      id: _currentClient!.id,
      name: _currentClient!.name,
      email: _currentClient!.email,
      company: _currentClient!.company,
      avatarInitials: _currentClient!.avatarInitials,
      projects: updatedProjects,
      memberSince: _currentClient!.memberSince,
      phone: _currentClient!.phone,
      supportEmail: _currentClient!.supportEmail,
    );
    notifyListeners(); // ← triggers HomeScreen rebuild automatically
  }

  void updateProject(Project updated) {
    if (_currentClient == null) return;
    final updatedProjects = _currentClient!.projects
        .map((p) => p.id == updated.id ? updated : p)
        .toList();
    _currentClient = Client(
      id: _currentClient!.id,
      name: _currentClient!.name,
      email: _currentClient!.email,
      company: _currentClient!.company,
      avatarInitials: _currentClient!.avatarInitials,
      projects: updatedProjects,
      memberSince: _currentClient!.memberSince,
      phone: _currentClient!.phone,
      supportEmail: _currentClient!.supportEmail,
    );
    notifyListeners();
  }

  void addCredential(String projectId, Credential credential) {
    if (_currentClient == null) return;
    final updatedProjects = _currentClient!.projects.map((p) {
      if (p.id != projectId) return p;
      return Project(
        id: p.id,
        name: p.name,
        type: p.type,
        description: p.description,
        credentials: List<Credential>.from(p.credentials)..add(credential),
        createdAt: p.createdAt,
        accentColor: p.accentColor,
      );
    }).toList();

    _currentClient = Client(
      id: _currentClient!.id,
      name: _currentClient!.name,
      email: _currentClient!.email,
      company: _currentClient!.company,
      avatarInitials: _currentClient!.avatarInitials,
      projects: updatedProjects,
      memberSince: _currentClient!.memberSince,
      phone: _currentClient!.phone,
      supportEmail: _currentClient!.supportEmail,
    );
    _refreshAlerts();
    notifyListeners();
  }

  void _refreshAlerts() {
  if (_currentClient == null) return;
  final fresh = <AppAlert>[];
  for (final project in _currentClient!.projects) {
    for (final cred in project.credentials) {
      final status = cred.expiryStatus;
      if (status != ExpiryStatus.active) {
        fresh.add(AppAlert(
          id: cred.id,
          title: '${cred.label} · ${project.name}',
          message: status == ExpiryStatus.expired
              ? 'This credential has expired.'
              : 'Expires in ${cred.daysUntilExpiry} days.',
          severity: status,
          createdAt: DateTime.now(),
          projectId: project.id,
          credentialId: cred.id,
        ));
      }
    }
  }
  _alerts = fresh;
}

  void updateCredential(String projectId, Credential updated) {
    if (_currentClient == null) return;
    final updatedProjects = _currentClient!.projects.map((p) {
      if (p.id != projectId) return p;
      return Project(
        id: p.id,
        name: p.name,
        type: p.type,
        description: p.description,
        credentials:
            p.credentials.map((c) => c.id == updated.id ? updated : c).toList(),
        createdAt: p.createdAt,
        accentColor: p.accentColor,
      );
    }).toList();

    _currentClient = Client(
      id: _currentClient!.id,
      name: _currentClient!.name,
      email: _currentClient!.email,
      company: _currentClient!.company,
      avatarInitials: _currentClient!.avatarInitials,
      projects: updatedProjects,
      memberSince: _currentClient!.memberSince,
      phone: _currentClient!.phone,
      supportEmail: _currentClient!.supportEmail,
    );
    _refreshAlerts();
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
