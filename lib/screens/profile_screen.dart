import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../utils/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  final Client client;
  const ProfileScreen({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthState>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        title: const Text('Profile',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.surfaceBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.primary, Color(0xFF0065FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Text(
                        client.avatarInitials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(client.name,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            )),
                        const SizedBox(height: 4),
                        Text(client.company,
                            style: const TextStyle(
                                color: AppTheme.textSecondary, fontSize: 13)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.successDim,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('Active Client',
                              style: TextStyle(
                                  color: AppTheme.success,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Account Details
            _SectionCard(
              title: 'Account Information',
              children: [
                _InfoRow(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: client.email),
                if (client.phone != null)
                  _InfoRow(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: client.phone!),
                _InfoRow(
                    icon: Icons.business_outlined,
                    label: 'Company',
                    value: client.company),
                _InfoRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Member Since',
                  value: DateFormat('MMMM yyyy').format(client.memberSince),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ── Summary
            _SectionCard(
              title: 'Account Summary',
              children: [
                _InfoRow(
                    icon: Icons.folder_outlined,
                    label: 'Projects',
                    value: '${client.projects.length} project${client.projects.length != 1 ? 's' : ''}'),
                _InfoRow(
                    icon: Icons.key_outlined,
                    label: 'Credentials',
                    value: '${client.projects.fold<int>(0, (s, p) => s + p.totalCredentials)} total'),
                _InfoRow(
                    icon: Icons.warning_amber_rounded,
                    label: 'Active Alerts',
                    value: '${client.totalAlerts}',
                    valueColor: client.totalAlerts > 0
                        ? AppTheme.warning
                        : AppTheme.success),
              ],
            ),

            const SizedBox(height: 14),

            // ── Support
            if (client.supportEmail != null) ...[
              _SectionCard(
                title: 'Support',
                children: [
                  _InfoRow(
                      icon: Icons.support_agent_outlined,
                      label: 'Contact Admin',
                      value: client.supportEmail!),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'For any credential updates, access issues, or renewals, contact your admin.',
                      style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 12,
                          height: 1.4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
            ],

            // ── App Info
            _SectionCard(
              title: 'App Info',
              children: [
                const _InfoRow(
                    icon: Icons.shield_outlined,
                    label: 'App Name',
                    value: 'ClientVault'),
                const _InfoRow(
                    icon: Icons.info_outline,
                    label: 'Version',
                    value: '1.0.0'),
                const _InfoRow(
                    icon: Icons.lock_outline,
                    label: 'Auth Type',
                    value: 'Admin-assigned credentials'),
              ],
            ),

            const SizedBox(height: 24),

            // ── Sign Out
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: AppTheme.surfaceElevated,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      title: const Text('Sign Out',
                          style: TextStyle(color: AppTheme.textPrimary)),
                      content: const Text(
                          'Are you sure you want to sign out?',
                          style: TextStyle(color: AppTheme.textSecondary)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel',
                              style: TextStyle(color: AppTheme.textSecondary)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            auth.logout();
                          },
                          child: const Text('Sign Out',
                              style: TextStyle(color: AppTheme.danger)),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.logout, color: AppTheme.danger, size: 18),
                label: const Text('Sign Out',
                    style: TextStyle(color: AppTheme.danger)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppTheme.danger.withOpacity(0.4)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Text(
              title,
              style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5),
            ),
          ),
          const Divider(height: 1, color: AppTheme.surfaceBorder),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  const _InfoRow(
      {required this.icon,
      required this.label,
      required this.value,
      this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.textMuted),
          const SizedBox(width: 10),
          Text(label,
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 13)),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: valueColor ?? AppTheme.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
