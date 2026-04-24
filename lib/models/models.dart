import 'package:flutter/material.dart';

// ─── Enums ───────────────────────────────────────────────────────────────────

enum ProjectType { mobileApp, webApp, both }

enum CredentialType {
  appStore,
  playStore,
  twilio,
  hosting,
  domain,
  apiKey,
  database,
  email,
  aws,
  mongodb,
  payment,
  firebase,
  other,
}

enum ExpiryStatus { active, expiringSoon, critical, expired }

// ─── Credential ───────────────────────────────────────────────────────────────

class Credential {
  final String id;
  final String label;
  final CredentialType type;
  final Map<String, String> fields; // key → value

  /// Primary expiry date (subscription, account, license, domain renewal, etc.)
  final DateTime? expiryDate;

  /// Secondary expiry — e.g. SSL cert date when primaryDate is domain date
  final DateTime? secondaryExpiryDate;
  final String? secondaryExpiryLabel; // e.g. "SSL Certificate"

  /// App Store / Play Store deep links
  final String? appStoreLink;
  final String? playStoreLink;

  /// Notes
  final String? notes;
  final bool isVisible;

  const Credential({
    required this.id,
    required this.label,
    required this.type,
    required this.fields,
    this.expiryDate,
    this.secondaryExpiryDate,
    this.secondaryExpiryLabel,
    this.appStoreLink,
    this.playStoreLink,
    this.notes,
    this.isVisible = false,
  });

  ExpiryStatus get expiryStatus {
    if (expiryDate == null && secondaryExpiryDate == null) {
      return ExpiryStatus.active;
    }
    // Pick the soonest expiry
    DateTime? soonest;
    for (final d in [expiryDate, secondaryExpiryDate]) {
      if (d == null) continue;
      if (soonest == null || d.isBefore(soonest)) soonest = d;
    }
    final diff = soonest!.difference(DateTime.now()).inDays;
    if (diff < 0) return ExpiryStatus.expired;
    if (diff <= 7) return ExpiryStatus.critical;
    if (diff <= 30) return ExpiryStatus.expiringSoon;
    return ExpiryStatus.active;
  }

  int? get daysUntilExpiry {
    DateTime? soonest;
    for (final d in [expiryDate, secondaryExpiryDate]) {
      if (d == null) continue;
      if (soonest == null || d.isBefore(soonest)) soonest = d;
    }
    return soonest?.difference(DateTime.now()).inDays;
  }

  bool get hasStoreLinks => appStoreLink != null || playStoreLink != null;

  Credential copyWith({bool? isVisible}) => Credential(
        id: id,
        label: label,
        type: type,
        fields: fields,
        expiryDate: expiryDate,
        secondaryExpiryDate: secondaryExpiryDate,
        secondaryExpiryLabel: secondaryExpiryLabel,
        appStoreLink: appStoreLink,
        playStoreLink: playStoreLink,
        notes: notes,
        isVisible: isVisible ?? this.isVisible,
      );
}

// ─── Project ──────────────────────────────────────────────────────────────────

class Project {
  final String id;
  final String name;
  final ProjectType type;
  final String description;
  final List<Credential> credentials;
  final DateTime createdAt;
  final Color accentColor;

  const Project({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.credentials,
    required this.createdAt,
    required this.accentColor,
  });

  int get totalCredentials => credentials.length;

  int get expiringCount => credentials
      .where((c) =>
          c.expiryStatus == ExpiryStatus.expiringSoon ||
          c.expiryStatus == ExpiryStatus.critical)
      .length;

  int get expiredCount =>
      credentials.where((c) => c.expiryStatus == ExpiryStatus.expired).length;

  List<Credential> get criticalCredentials => credentials
      .where((c) =>
          c.expiryStatus == ExpiryStatus.critical ||
          c.expiryStatus == ExpiryStatus.expired)
      .toList();
}

// ─── Client / User ────────────────────────────────────────────────────────────

class Client {
  final String id;
  final String name;
  final String email;
  final String company;
  final String avatarInitials;
  final List<Project> projects;
  final DateTime memberSince;
  final String? phone;
  final String? supportEmail;

  const Client({
    required this.id,
    required this.name,
    required this.email,
    required this.company,
    required this.avatarInitials,
    required this.projects,
    required this.memberSince,
    this.phone,
    this.supportEmail,
  });

  int get totalAlerts =>
      projects.fold(0, (sum, p) => sum + p.expiringCount + p.expiredCount);
}

// ─── Alert / Notification ─────────────────────────────────────────────────────

class AppAlert {
  final String id;
  final String title;
  final String message;
  final ExpiryStatus severity;
  final DateTime createdAt;
  final bool isRead;
  final String? projectId;
  final String? credentialId;

  const AppAlert({
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
    required this.createdAt,
    this.isRead = false,
    this.projectId,
    this.credentialId,
  });

  AppAlert copyWith({bool? isRead}) => AppAlert(
        id: id,
        title: title,
        message: message,
        severity: severity,
        createdAt: createdAt,
        isRead: isRead ?? this.isRead,
        projectId: projectId,
        credentialId: credentialId,
      );
}
