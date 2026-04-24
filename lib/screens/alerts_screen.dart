import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../utils/auth_state.dart';

class AlertsScreen extends StatelessWidget {
  final Client client;
  const AlertsScreen({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final alerts = auth.alerts;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        title: Row(
          children: [
            const Text('Alerts',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary)),
            if (auth.unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.danger,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${auth.unreadCount}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (auth.unreadCount > 0)
            TextButton(
              onPressed: auth.markAllRead,
              child: const Text('Mark all read',
                  style: TextStyle(color: AppTheme.primary, fontSize: 12)),
            ),
        ],
      ),
      body: alerts.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline,
                      color: AppTheme.success, size: 52),
                  SizedBox(height: 16),
                  Text('All Clear!',
                      style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                  SizedBox(height: 6),
                  Text('No expiry alerts at the moment.',
                      style: TextStyle(
                          color: AppTheme.textSecondary, fontSize: 13)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: alerts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final alert = alerts[index];
                final isRead = auth.isAlertRead(alert.id);
                return _AlertCard(
                  alert: alert,
                  isRead: isRead,
                  onTap: () => auth.markAlertRead(alert.id),
                );
              },
            ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final AppAlert alert;
  final bool isRead;
  final VoidCallback onTap;
  const _AlertCard(
      {required this.alert, required this.isRead, required this.onTap});

  Color get _severityColor => switch (alert.severity) {
        ExpiryStatus.expired => AppTheme.danger,
        ExpiryStatus.critical => AppTheme.danger,
        ExpiryStatus.expiringSoon => AppTheme.warning,
        ExpiryStatus.active => AppTheme.success,
      };

  Color get _severityBg => switch (alert.severity) {
        ExpiryStatus.expired => AppTheme.dangerDim,
        ExpiryStatus.critical => AppTheme.dangerDim,
        ExpiryStatus.expiringSoon => AppTheme.warningDim,
        ExpiryStatus.active => AppTheme.successDim,
      };

  IconData get _severityIcon => switch (alert.severity) {
        ExpiryStatus.expired => Icons.error_outline,
        ExpiryStatus.critical => Icons.warning_amber_rounded,
        ExpiryStatus.expiringSoon => Icons.timer_outlined,
        ExpiryStatus.active => Icons.check_circle_outline,
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead ? AppTheme.surfaceElevated : AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isRead
                ? AppTheme.surfaceBorder
                : _severityColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _severityBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_severityIcon, color: _severityColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          alert.title,
                          style: TextStyle(
                            color: isRead
                                ? AppTheme.textSecondary
                                : AppTheme.textPrimary,
                            fontSize: 13,
                            fontWeight: isRead
                                ? FontWeight.w400
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: _severityColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    alert.message,
                    style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                        height: 1.4),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    timeago.format(alert.createdAt),
                    style: const TextStyle(
                        color: AppTheme.textMuted, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
