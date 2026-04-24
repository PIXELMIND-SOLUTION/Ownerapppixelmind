// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ownerapp_pixelmind/views/auth/auth_screen.dart';

class _ProfileData {
  final String name;
  final String role;
  final String email;
  final String phone;
  final String location;
  final String imageUrl;
  final int totalProjects;
  final int activeProjects;
  final String memberSince;

  const _ProfileData({
    required this.name,
    required this.role,
    required this.email,
    required this.phone,
    required this.location,
    required this.imageUrl,
    required this.totalProjects,
    required this.activeProjects,
    required this.memberSince,
  });
}

const _profile = _ProfileData(
  name: 'Arjun Mehta',
  role: 'Product Owner',
  email: 'arjun.mehta@pixelmind.in',
  phone: '+91 98765 43210',
  location: 'Hyderabad, Telangana',
  imageUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
  totalProjects: 12,
  activeProjects: 4,
  memberSince: 'Jan 2024',
);

const _bg = Color(0xFF0F1420);
const _card = Color(0xFF1A1F2E);
const _blue = Color(0xFF3D8EFF);
const _teal = Color(0xFF00D4AA);
const _orange = Color(0xFFFF7C3D);
const _purple = Color(0xFFA855F7);
const _textMuted = Color(0xFF6B7280);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _fadeIn = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Logout', style: TextStyle(color: Colors.white)),
          content: Text(
            'Are you sure you want to log out?',
            style: TextStyle(color: Colors.white.withOpacity(0.7)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                Navigator.pop(context);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                  (route) => false,
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: _bg,
      body: FadeTransition(
        opacity: _fadeIn,
        child: SlideTransition(
          position: _slideUp,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: topPad + 190,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF152845), Color(0xFF1A1F2E)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: topPad - 10,
                            right: -30,
                            child: _glowCircle(140, _blue.withOpacity(0.12)),
                          ),
                          Positioned(
                            top: topPad + 40,
                            left: -20,
                            child: _glowCircle(100, _purple.withOpacity(0.1)),
                          ),
                          // Top bar
                          Positioned(
                            top: topPad + 16,
                            left: 20,
                            right: 20,
                            child: Row(
                              children: [
                                const Text(
                                  'Profile',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const Spacer(),
                                // Edit button
                                GestureDetector(
                                  onTap: () => HapticFeedback.lightImpact(),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 7,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _blue.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: _blue.withOpacity(0.3),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.edit_outlined,
                                          color: _blue,
                                          size: 13,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Edit',
                                          style: TextStyle(
                                            color: _blue,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                      top: topPad + 90,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          // Avatar with ring
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer glow ring
                              Container(
                                width: 98,
                                height: 98,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const SweepGradient(
                                    colors: [_blue, _teal, _purple, _blue],
                                  ),
                                ),
                              ),
                              // White gap
                              Container(
                                width: 92,
                                height: 92,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _bg,
                                ),
                              ),
                              // Network image
                              ClipOval(
                                child: Image.network(
                                  _profile.imageUrl,
                                  width: 84,
                                  height: 84,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 84,
                                    height: 84,
                                    color: _card,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'AM',
                                      style: TextStyle(
                                        color: _blue,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Online dot
                              Positioned(
                                bottom: 3,
                                right: 3,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: _teal,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: _bg, width: 2.5),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // Name
                          Text(
                            _profile.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _blue.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _blue.withOpacity(0.25),
                              ),
                            ),
                            child: Text(
                              _profile.role,
                              style: const TextStyle(
                                color: _blue,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Location
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 12,
                                color: Colors.white.withOpacity(0.35),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                _profile.location,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.38),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: topPad + 370),
                  ],
                ),
              ),

              // ── Stats Row ──────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: _card,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.white.withOpacity(0.06)),
                    ),
                    child: Row(
                      children: [
                        _statItem(
                          '${_profile.totalProjects}',
                          'Total Projects',
                          _blue,
                        ),
                        _vDivider(),
                        _statItem(
                          '${_profile.activeProjects}',
                          'Active Now',
                          _orange,
                        ),
                        _vDivider(),
                        _statItem(_profile.memberSince, 'Member Since', _teal),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Contact Info Section ───────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel('Contact Information'),
                      const SizedBox(height: 12),
                      _infoTile(
                        icon: Icons.phone_rounded,
                        label: 'Mobile Number',
                        value: _profile.phone,
                        accent: _teal,
                        onTap: () => HapticFeedback.lightImpact(),
                      ),
                      const SizedBox(height: 10),
                      _infoTile(
                        icon: Icons.mail_outline_rounded,
                        label: 'Email Address',
                        value: _profile.email,
                        accent: _blue,
                        onTap: () => HapticFeedback.lightImpact(),
                      ),
                      const SizedBox(height: 10),
                      _infoTile(
                        icon: Icons.location_on_outlined,
                        label: 'Location',
                        value: _profile.location,
                        accent: _purple,
                        onTap: () => HapticFeedback.lightImpact(),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Account Section ────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel('Account'),
                      const SizedBox(height: 12),
                      _menuItem(
                        icon: Icons.shield_outlined,
                        label: 'Privacy & Security',
                        accent: _blue,
                      ),
                      const SizedBox(height: 10),
                      _menuItem(
                        icon: Icons.notifications_outlined,
                        label: 'Notifications',
                        accent: _orange,
                        trailing: _notifBadge('3'),
                      ),
                      const SizedBox(height: 10),
                      _menuItem(
                        icon: Icons.help_outline_rounded,
                        label: 'Help & Support',
                        accent: _teal,
                      ),
                      const SizedBox(height: 10),
                      _menuItem(
                        icon: Icons.info_outline_rounded,
                        label: 'About App',
                        accent: _purple,
                      ),
                    ],
                  ),
                ),
              ),

              // ── Logout Button ─────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      _showLogoutDialog();
                    },
                    child: Container(
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.red.withOpacity(0.25),
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            color: Colors.redAccent,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Log Out',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Version tag ───────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 18, bottom: 110),
                  child: Center(
                    child: Text(
                      'OwnerApp v1.0.0 · PixelMind',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.18),
                        fontSize: 11.5,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Helper Builders ───────────────────────────────────────────────────────

  Widget _glowCircle(double size, Color color) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );

  Widget _statItem(String value, String label, Color color) => Expanded(
    child: Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  Widget _vDivider() =>
      Container(width: 1, height: 36, color: Colors.white.withOpacity(0.07));

  Widget _sectionLabel(String text) => Text(
    text,
    style: TextStyle(
      color: Colors.white.withOpacity(0.45),
      fontSize: 11.5,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.8,
    ),
  );

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color accent,
    VoidCallback? onTap,
  }) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: accent, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          // Icon(
          //   Icons.copy_outlined,
          //   size: 15,
          //   color: Colors.white.withOpacity(0.2),
          // ),
        ],
      ),
    ),
  );

  Widget _menuItem({
    required IconData icon,
    required String label,
    required Color accent,
    Widget? trailing,
  }) => GestureDetector(
    onTap: () => HapticFeedback.lightImpact(),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: accent, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          trailing ??
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withOpacity(0.22),
                size: 20,
              ),
        ],
      ),
    ),
  );

  Widget _notifBadge(String count) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: _orange.withOpacity(0.15),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: _orange.withOpacity(0.3)),
    ),
    child: Text(
      count,
      style: const TextStyle(
        color: _orange,
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
