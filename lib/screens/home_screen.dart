import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../utils/auth_state.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';
import 'project_detail_screen.dart';
import 'alerts_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final client = auth.currentClient!;

    final pages = [
      _DashboardTab(client: client),
      AlertsScreen(client: client),
      ProfileScreen(client: client),
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: _BottomNav(
        selectedIndex: _selectedIndex,
        unreadAlerts: auth.unreadCount,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }
}

// ─── Bottom Navigation ────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int selectedIndex;
  final int unreadAlerts;
  final ValueChanged<int> onTap;
  const _BottomNav(
      {required this.selectedIndex,
      required this.unreadAlerts,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceElevated,
        border: Border(top: BorderSide(color: AppTheme.surfaceBorder)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                  icon: Icons.grid_view_rounded,
                  label: 'Projects',
                  selected: selectedIndex == 0,
                  onTap: () => onTap(0)),
              _NavItem(
                  icon: Icons.notifications_outlined,
                  label: 'Alerts',
                  selected: selectedIndex == 1,
                  badge: unreadAlerts,
                  onTap: () => onTap(1)),
              _NavItem(
                  icon: Icons.person_outline,
                  label: 'Profile',
                  selected: selectedIndex == 2,
                  onTap: () => onTap(2)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final int badge;
  final VoidCallback onTap;
  const _NavItem(
      {required this.icon,
      required this.label,
      required this.selected,
      required this.onTap,
      this.badge = 0});

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppTheme.primary : AppTheme.textMuted;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: selected
                      ? AppTheme.primary.withOpacity(0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              if (badge > 0)
                Positioned(
                  right: 8,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                        color: AppTheme.danger, shape: BoxShape.circle),
                    constraints:
                        const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '$badge',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 10, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ─── Dashboard Tab ────────────────────────────────────────────────────────────

class _DashboardTab extends StatelessWidget {
  final Client client;
  const _DashboardTab({required this.client});

  @override
  Widget build(BuildContext context) {
    final totalCreds = client.projects
        .fold<int>(0, (sum, p) => sum + p.totalCredentials);
    final totalAlerts = client.totalAlerts;
    final expiredCount = client.projects
        .fold<int>(0, (sum, p) => sum + p.expiredCount);

    return CustomScrollView(
      slivers: [
        // ── App Bar
        SliverAppBar(
          expandedHeight: 0,
          floating: true,
          backgroundColor: AppTheme.background,
          title: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppTheme.primary, Color(0xFF0065FF)]),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.shield_outlined,
                    color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              const Text('ClientVault',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary)),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: AppTheme.textSecondary),
              onPressed: () {
                // Future: search
              },
            ),
          ],
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Welcome
                Text(
                  'Welcome back,',
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 13),
                ),
                Text(
                  client.name.split(' ').first,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 20),

                // ── Alert Banner (if any critical)
                if (expiredCount > 0) ...[
                  _AlertBanner(
                    message:
                        '$expiredCount credential${expiredCount > 1 ? 's have' : ' has'} expired. Immediate action required.',
                    color: AppTheme.danger,
                    bgColor: AppTheme.dangerDim,
                  ),
                  const SizedBox(height: 12),
                ] else if (totalAlerts > 0) ...[
                  _AlertBanner(
                    message:
                        '$totalAlerts service${totalAlerts > 1 ? 's are' : ' is'} expiring soon. Review required.',
                    color: AppTheme.warning,
                    bgColor: AppTheme.warningDim,
                  ),
                  const SizedBox(height: 12),
                ],

                // ── Stats Row
                Row(
                  children: [
                    Expanded(
                      child: MiniStatCard(
                        label: 'Projects',
                        value: '${client.projects.length}',
                        icon: Icons.folder_outlined,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MiniStatCard(
                        label: 'Credentials',
                        value: '$totalCreds',
                        icon: Icons.key_outlined,
                        color: AppTheme.accent,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MiniStatCard(
                        label: 'Alerts',
                        value: '$totalAlerts',
                        icon: Icons.warning_amber_rounded,
                        color: totalAlerts > 0
                            ? AppTheme.danger
                            : AppTheme.success,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // ── Projects Section
                SectionHeader(
                  title: 'Your Projects',
                  subtitle: '${client.projects.length} active project${client.projects.length != 1 ? 's' : ''}',
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ),

        // ── Project Cards
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final project = client.projects[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _ProjectCard(
                    project: project,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProjectDetailScreen(project: project),
                      ),
                    ),
                  ),
                );
              },
              childCount: client.projects.length,
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _AlertBanner extends StatelessWidget {
  final String message;
  final Color color;
  final Color bgColor;
  const _AlertBanner(
      {required this.message, required this.color, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: color, fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Project Card ─────────────────────────────────────────────────────────────

class _ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;
  const _ProjectCard({required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppTheme.surfaceBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Accent bar + header
            Container(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppTheme.surfaceBorder),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: project.accentColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: project.accentColor.withOpacity(0.3)),
                    ),
                    child: Icon(
                      project.type == ProjectType.mobileApp
                          ? Icons.phone_android
                          : project.type == ProjectType.webApp
                              ? Icons.web
                              : Icons.devices,
                      color: project.accentColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        ProjectTypeChip(type: project.type),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right,
                      color: AppTheme.textMuted, size: 20),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.description,
                    style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        height: 1.4),
                  ),
                  const SizedBox(height: 14),

                  // Stats row
                  Row(
                    children: [
                      _ProjectStat(
                        icon: Icons.key_outlined,
                        value: '${project.totalCredentials}',
                        label: 'Credentials',
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 16),
                      if (project.expiredCount > 0)
                        _ProjectStat(
                          icon: Icons.error_outline,
                          value: '${project.expiredCount}',
                          label: 'Expired',
                          color: AppTheme.danger,
                        )
                      else if (project.expiringCount > 0)
                        _ProjectStat(
                          icon: Icons.timer_outlined,
                          value: '${project.expiringCount}',
                          label: 'Expiring',
                          color: AppTheme.warning,
                        )
                      else
                        _ProjectStat(
                          icon: Icons.check_circle_outline,
                          value: 'All OK',
                          label: 'Status',
                          color: AppTheme.success,
                        ),
                    ],
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

class _ProjectStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  const _ProjectStat(
      {required this.icon,
      required this.value,
      required this.label,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text('$value ',
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.w600)),
        Text(label,
            style: const TextStyle(
                color: AppTheme.textMuted, fontSize: 12)),
      ],
    );
  }
}
