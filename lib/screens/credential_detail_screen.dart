import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import 'package:intl/intl.dart';

class CredentialDetailScreen extends StatefulWidget {
  final Credential credential;
  final String projectName;
  const CredentialDetailScreen(
      {super.key, required this.credential, required this.projectName});

  @override
  State<CredentialDetailScreen> createState() => _CredentialDetailScreenState();
}

class _CredentialDetailScreenState extends State<CredentialDetailScreen> {
  final Set<String> _visibleFields = {};
  bool _allVisible = false;

  bool _isSensitiveField(String key) {
    final lower = key.toLowerCase();
    return lower.contains('password') ||
        lower.contains('secret') ||
        lower.contains('token') ||
        lower.contains('key') ||
        lower.contains('auth') ||
        lower.contains('ssh') ||
        lower.contains('uri') ||
        lower.contains('credential');
  }

  bool _isLinkField(String key, String value) {
    final lower = key.toLowerCase();
    return (lower.contains('url') || lower.contains('link')) &&
        value.startsWith('http');
  }

  void _toggleAll() {
    setState(() {
      _allVisible = !_allVisible;
      if (_allVisible) {
        _visibleFields
            .addAll(widget.credential.fields.keys.where(_isSensitiveField));
      } else {
        _visibleFields.clear();
      }
    });
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cred = widget.credential;
    final status = cred.expiryStatus;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(cred.label,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            Text(widget.projectName,
                style: const TextStyle(
                    fontSize: 11, color: AppTheme.textSecondary)),
          ],
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.surfaceBorder),
            ),
            child: const Icon(Icons.arrow_back_ios_new,
                size: 14, color: AppTheme.textPrimary),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton.icon(
            onPressed: _toggleAll,
            icon: Icon(
              _allVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 14,
              color: AppTheme.primary,
            ),
            label: Text(
              _allVisible ? 'Hide All' : 'Show All',
              style: const TextStyle(color: AppTheme.primary, fontSize: 12),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header card ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: status == ExpiryStatus.expired ||
                          status == ExpiryStatus.critical
                      ? AppTheme.danger.withOpacity(0.4)
                      : AppTheme.surfaceBorder,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                        child: CredentialTypeIcon(type: cred.type, size: 22)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_credTypeLabel(cred.type),
                            style: const TextStyle(
                                color: AppTheme.textSecondary, fontSize: 11)),
                        Text(cred.label,
                            style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  if (cred.expiryDate != null ||
                      cred.secondaryExpiryDate != null)
                    ExpiryBadge(status: status, daysLeft: cred.daysUntilExpiry),
                ],
              ),
            ),

            // ── Store links (App Store / Play Store) ─────────────────────
            if (cred.hasStoreLinks) ...[
              const SizedBox(height: 12),
              const SectionHeader(title: 'Store Links'),
              const SizedBox(height: 10),
              if (cred.appStoreLink != null)
                _StoreLinkButton(
                  label: 'View on App Store',
                  icon: Icons.apple,
                  color: const Color(0xFF007AFF),
                  url: cred.appStoreLink!,
                  onTap: () => _launchUrl(cred.appStoreLink!),
                ),
              if (cred.playStoreLink != null) ...[
                if (cred.appStoreLink != null) const SizedBox(height: 8),
                _StoreLinkButton(
                  label: 'View on Play Store',
                  icon: Icons.play_arrow_rounded,
                  color: const Color(0xFF34A853),
                  url: cred.playStoreLink!,
                  onTap: () => _launchUrl(cred.playStoreLink!),
                ),
              ],
            ],

            // ── Expiry warning ────────────────────────────────────────────
            if (status == ExpiryStatus.expired ||
                status == ExpiryStatus.critical) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.dangerDim,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.danger.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: AppTheme.danger, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        status == ExpiryStatus.expired
                            ? 'This credential has expired. Contact your administrator to renew it.'
                            : 'This credential expires in ${cred.daysUntilExpiry} days. Please schedule a renewal.',
                        style: const TextStyle(
                            color: AppTheme.danger, fontSize: 13, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // ── Privacy notice ────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryDim.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lock_outline, color: AppTheme.primary, size: 14),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Credentials are masked by default. Tap the eye icon to reveal individual fields.',
                      style: TextStyle(
                          color: AppTheme.primary, fontSize: 11, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const SectionHeader(title: 'Credential Fields'),
            const SizedBox(height: 12),

            // ── Fields ────────────────────────────────────────────────────
            ...cred.fields.entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _isLinkField(e.key, e.value)
                      ? _LinkFieldCard(
                          fieldKey: e.key,
                          url: e.value,
                          onTap: () => _launchUrl(e.value),
                        )
                      : _FieldCard(
                          fieldKey: e.key,
                          value: e.value,
                          isSensitive: _isSensitiveField(e.key),
                          isVisible: !_isSensitiveField(e.key) ||
                              _visibleFields.contains(e.key),
                          onToggleVisibility: _isSensitiveField(e.key)
                              ? () => setState(() {
                                    if (_visibleFields.contains(e.key)) {
                                      _visibleFields.remove(e.key);
                                    } else {
                                      _visibleFields.add(e.key);
                                    }
                                  })
                              : null,
                        ),
                )),

            // ── Expiry information ────────────────────────────────────────
            if (cred.expiryDate != null ||
                cred.secondaryExpiryDate != null) ...[
              const SizedBox(height: 16),
              const SectionHeader(title: 'Expiry Information'),
              const SizedBox(height: 12),
              if (cred.expiryDate != null)
                _ExpiryRow(
                  label: 'Primary Expiry',
                  date: cred.expiryDate!,
                  status: cred.expiryDate!.difference(DateTime.now()).inDays < 0
                      ? ExpiryStatus.expired
                      : cred.expiryDate!.difference(DateTime.now()).inDays <= 7
                          ? ExpiryStatus.critical
                          : cred.expiryDate!
                                      .difference(DateTime.now())
                                      .inDays <=
                                  30
                              ? ExpiryStatus.expiringSoon
                              : ExpiryStatus.active,
                ),
              if (cred.secondaryExpiryDate != null) ...[
                const SizedBox(height: 8),
                _ExpiryRow(
                  label: cred.secondaryExpiryLabel ?? 'Secondary Expiry',
                  date: cred.secondaryExpiryDate!,
                  status: cred.secondaryExpiryDate!
                              .difference(DateTime.now())
                              .inDays <
                          0
                      ? ExpiryStatus.expired
                      : cred.secondaryExpiryDate!
                                  .difference(DateTime.now())
                                  .inDays <=
                              7
                          ? ExpiryStatus.critical
                          : cred.secondaryExpiryDate!
                                      .difference(DateTime.now())
                                      .inDays <=
                                  30
                              ? ExpiryStatus.expiringSoon
                              : ExpiryStatus.active,
                ),
              ],
            ],

            // ── Notes ────────────────────────────────────────────────────
            if (cred.notes != null) ...[
              const SizedBox(height: 16),
              const SectionHeader(title: 'Notes'),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.surfaceBorder),
                ),
                child: Text(
                  cred.notes!,
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
                ),
              ),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _credTypeLabel(CredentialType type) {
    return switch (type) {
      CredentialType.appStore => 'App Store',
      CredentialType.playStore => 'Google Play',
      CredentialType.twilio => 'Twilio',
      CredentialType.hosting => 'Hosting',
      CredentialType.domain => 'Domain / SSL',
      CredentialType.apiKey => 'API Key',
      CredentialType.database => 'Database',
      CredentialType.email => 'Email Service',
      CredentialType.aws => 'Amazon Web Services',
      CredentialType.mongodb => 'MongoDB Atlas',
      CredentialType.payment => 'Payment Gateway',
      CredentialType.firebase => 'Firebase',
      CredentialType.other => 'Other',
    };
  }
}

// ─── Store Link Button ────────────────────────────────────────────────────────

class _StoreLinkButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final String url;
  final VoidCallback onTap;

  const _StoreLinkButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.url,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          color: color,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                  Text(url,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppTheme.textSecondary, fontSize: 10)),
                ],
              ),
            ),
            Icon(Icons.open_in_new_rounded, color: color, size: 14),
          ],
        ),
      ),
    );
  }
}

// ─── Expiry Row ───────────────────────────────────────────────────────────────

class _ExpiryRow extends StatelessWidget {
  final String label;
  final DateTime date;
  final ExpiryStatus status;
  const _ExpiryRow(
      {required this.label, required this.date, required this.status});

  @override
  Widget build(BuildContext context) {
    final days = date.difference(DateTime.now()).inDays;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_outlined,
              color: AppTheme.textSecondary, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: AppTheme.textSecondary, fontSize: 11)),
                Text(
                  DateFormat('MMMM dd, yyyy').format(date),
                  style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          ExpiryBadge(status: status, daysLeft: days),
        ],
      ),
    );
  }
}

// ─── Link Field Card ──────────────────────────────────────────────────────────

class _LinkFieldCard extends StatelessWidget {
  final String fieldKey;
  final String url;
  final VoidCallback onTap;
  const _LinkFieldCard({
    required this.fieldKey,
    required this.url,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(fieldKey,
              style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onTap,
                  child: Text(
                    url,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                        decorationColor: AppTheme.primary),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onTap,
                child: const Icon(Icons.open_in_new_rounded,
                    color: AppTheme.primary, size: 14),
              ),
              const SizedBox(width: 8),
              CopyButton(value: url),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Field Card ───────────────────────────────────────────────────────────────

class _FieldCard extends StatelessWidget {
  final String fieldKey;
  final String value;
  final bool isSensitive;
  final bool isVisible;
  final VoidCallback? onToggleVisibility;
  const _FieldCard({
    required this.fieldKey,
    required this.value,
    required this.isSensitive,
    required this.isVisible,
    this.onToggleVisibility,
  });

  String get _maskedValue => '•' * value.length.clamp(8, 24);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                fieldKey,
                style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3),
              ),
              if (isSensitive) ...[
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.accentDim,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('SENSITIVE',
                      style: TextStyle(
                          color: AppTheme.accent,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5)),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: SelectableText(
                  isVisible ? value : _maskedValue,
                  style: TextStyle(
                    color:
                        isVisible ? AppTheme.textPrimary : AppTheme.textMuted,
                    fontSize: 14,
                    fontFamily: 'monospace',
                    letterSpacing: isVisible ? 0 : 2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (isSensitive && onToggleVisibility != null)
                GestureDetector(
                  onTap: onToggleVisibility,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      isVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              const SizedBox(width: 4),
              if (isVisible) CopyButton(value: value),
            ],
          ),
        ],
      ),
    );
  }
}
