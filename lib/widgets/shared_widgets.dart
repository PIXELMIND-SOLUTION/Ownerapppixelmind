import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

// ─── Status Badge ──────────────────────────────────────────────────────────────

class ExpiryBadge extends StatelessWidget {
  final ExpiryStatus status;
  final int? daysLeft;
  const ExpiryBadge({super.key, required this.status, this.daysLeft});

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      ExpiryStatus.active => ('Active', AppTheme.successDim, AppTheme.success),
      ExpiryStatus.expiringSoon => (
          daysLeft != null ? 'In $daysLeft days' : 'Expiring',
          AppTheme.warningDim,
          AppTheme.warning
        ),
      ExpiryStatus.critical => (
          daysLeft != null ? '$daysLeft days left!' : 'Critical',
          AppTheme.dangerDim,
          AppTheme.danger
        ),
      ExpiryStatus.expired => ('Expired', AppTheme.dangerDim, AppTheme.danger),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: fg.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ─── Credential Type Icon ──────────────────────────────────────────────────────

class CredentialTypeIcon extends StatelessWidget {
  final CredentialType type;
  final double size;
  const CredentialTypeIcon({super.key, required this.type, this.size = 20});

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (type) {
      CredentialType.appStore => (Icons.apple, const Color(0xFF007AFF)),
      CredentialType.playStore => (Icons.android, const Color(0xFF34A853)),
      CredentialType.twilio => (Icons.sms_outlined, const Color(0xFFE31E26)),
      CredentialType.hosting => (Icons.dns_outlined, AppTheme.accent),
      CredentialType.domain => (Icons.language, const Color(0xFF9B59B6)),
      CredentialType.apiKey => (Icons.vpn_key_outlined, AppTheme.primary),
      CredentialType.database => (
          Icons.storage_outlined,
          const Color(0xFFFF9800)
        ),
      CredentialType.email => (Icons.email_outlined, const Color(0xFF00BCD4)),
      CredentialType.aws => (Icons.cloud_outlined, const Color(0xFFFF9900)),
      CredentialType.mongodb => (
          Icons.storage_rounded,
          const Color(0xFF00ED64)
        ),
      CredentialType.payment => (
          Icons.credit_card_outlined,
          const Color(0xFF6772E5)
        ),
      CredentialType.firebase => (
          Icons.local_fire_department_outlined,
          const Color(0xFFFFA000)
        ),
      CredentialType.other => (Icons.key_outlined, AppTheme.textSecondary),
    };
    return Icon(icon, color: color, size: size);
  }
}

// ─── Section Header ────────────────────────────────────────────────────────────

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  const SectionHeader(
      {super.key, required this.title, this.subtitle, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
              if (subtitle != null)
                Text(subtitle!,
                    style: const TextStyle(
                        color: AppTheme.textSecondary, fontSize: 12)),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

// ─── Copy Button ───────────────────────────────────────────────────────────────

class CopyButton extends StatefulWidget {
  final String value;
  const CopyButton({super.key, required this.value});
  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: widget.value));
        setState(() => _copied = true);
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) setState(() => _copied = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _copied ? AppTheme.successDim : AppTheme.surfaceBorder,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _copied ? Icons.check : Icons.copy_outlined,
              size: 13,
              color: _copied ? AppTheme.success : AppTheme.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              _copied ? 'Copied!' : 'Copy',
              style: TextStyle(
                  fontSize: 11,
                  color: _copied ? AppTheme.success : AppTheme.textSecondary,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Project Type Chip ─────────────────────────────────────────────────────────

class ProjectTypeChip extends StatelessWidget {
  final ProjectType type;
  const ProjectTypeChip({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final (label, icon) = switch (type) {
      ProjectType.mobileApp => ('Mobile App', Icons.phone_android),
      ProjectType.webApp => ('Web App', Icons.web),
      ProjectType.both => ('Mobile + Web', Icons.devices),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceBorder,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.textSecondary),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ─── Stat Card ─────────────────────────────────────────────────────────────────

class MiniStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const MiniStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 22, fontWeight: FontWeight.w700)),
          Text(label,
              style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
