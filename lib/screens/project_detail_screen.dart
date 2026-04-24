import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import 'credential_detail_screen.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;
  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // ── SliverAppBar with project header
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: AppTheme.background,
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
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      project.accentColor.withOpacity(0.15),
                      AppTheme.background,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: project.accentColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: project.accentColor.withOpacity(0.4)),
                          ),
                          child: Icon(
                            project.type == ProjectType.mobileApp
                                ? Icons.phone_android
                                : project.type == ProjectType.webApp
                                    ? Icons.web
                                    : Icons.devices,
                            color: project.accentColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                project.name,
                                style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              ProjectTypeChip(type: project.type),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  Text(
                    project.description,
                    style: const TextStyle(
                        color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: 20),

                  // Stats row
                  Row(
                    children: [
                      Expanded(
                        child: MiniStatCard(
                          label: 'Total',
                          value: '${project.totalCredentials}',
                          icon: Icons.key_outlined,
                          color: project.accentColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MiniStatCard(
                          label: 'Expiring',
                          value: '${project.expiringCount}',
                          icon: Icons.timer_outlined,
                          color: project.expiringCount > 0
                              ? AppTheme.warning
                              : AppTheme.success,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MiniStatCard(
                          label: 'Expired',
                          value: '${project.expiredCount}',
                          icon: Icons.error_outline,
                          color: project.expiredCount > 0
                              ? AppTheme.danger
                              : AppTheme.success,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),
                  const SectionHeader(title: 'Service Credentials'),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),

          // ── Credential List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final cred = project.credentials[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _CredentialListTile(
                      credential: cred,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CredentialDetailScreen(
                            credential: cred,
                            projectName: project.name,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: project.credentials.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

// ─── Credential List Tile ─────────────────────────────────────────────────────

class _CredentialListTile extends StatelessWidget {
  final Credential credential;
  final VoidCallback onTap;
  const _CredentialListTile(
      {required this.credential, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final status = credential.expiryStatus;
    final isIssue = status == ExpiryStatus.critical ||
        status == ExpiryStatus.expired;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isIssue
                ? AppTheme.danger.withOpacity(0.3)
                : AppTheme.surfaceBorder,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: CredentialTypeIcon(
                    type: credential.type, size: 18),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    credential.label,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${credential.fields.length} field${credential.fields.length != 1 ? 's' : ''}',
                        style: const TextStyle(
                            color: AppTheme.textMuted, fontSize: 11),
                      ),
                      if (credential.expiryDate != null) ...[
                        const Text(' · ',
                            style: TextStyle(
                                color: AppTheme.textMuted, fontSize: 11)),
                        ExpiryBadge(
                            status: status,
                            daysLeft: credential.daysUntilExpiry),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppTheme.textMuted, size: 18),
          ],
        ),
      ),
    );
  }
}
