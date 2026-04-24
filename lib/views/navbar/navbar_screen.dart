import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ownerapp_pixelmind/provider/navbar/navbar_provider.dart';
import 'package:ownerapp_pixelmind/views/home/account_screen.dart';
import 'package:ownerapp_pixelmind/views/home/home_screen.dart';
import 'package:ownerapp_pixelmind/views/home/profile_screen.dart';

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}


class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar>
    with TickerProviderStateMixin {
  static const _items = [
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    _NavItem(
      icon: Icons.layers_outlined,
      activeIcon: Icons.layers_rounded,
      label: 'Accounts',
    ),
    // _NavItem(
    //   icon: Icons.qr_code_scanner_outlined,
    //   activeIcon: Icons.qr_code_scanner_rounded,
    //   label: 'Scan QR',
    // ),
    // _NavItem(
    //   icon: Icons.credit_card_outlined,
    //   activeIcon: Icons.credit_card_rounded,
    //   label: 'Cards',
    // ),
    _NavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _items.length,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );

    _scaleAnimations = _controllers
        .map(
          (c) => Tween<double>(begin: 1.0, end: 1.18).animate(
            CurvedAnimation(parent: c, curve: Curves.easeOutBack),
          ),
        )
        .toList();

    _fadeAnimations = _controllers
        .map(
          (c) => Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: c, curve: Curves.easeOut),
          ),
        )
        .toList();

    // Activate the initial index
    _controllers[widget.currentIndex].value = 1.0;
  }

  @override
  void didUpdateWidget(CustomBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _controllers[oldWidget.currentIndex].reverse();
      _controllers[widget.currentIndex].forward();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _handleTap(int index) {
    if (index == widget.currentIndex) return;
    HapticFeedback.lightImpact();
    widget.onTap(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 30,
            spreadRadius: -4,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: const Color(0xFF3D8EFF).withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: -2,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            _items.length,
            (index) => _buildNavItem(index),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isActive = widget.currentIndex == index;
    final item = _items[index];

    return Expanded(
      child: GestureDetector(
        onTap: () => _handleTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _controllers[index],
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimations[index],
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow blob behind active icon
                      if (isActive)
                        FadeTransition(
                          opacity: _fadeAnimations[index],
                          child: Container(
                            width: 44,
                            height: 38,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: const RadialGradient(
                                colors: [
                                  Color(0x553D8EFF),
                                  Color(0x003D8EFF),
                                ],
                              ),
                            ),
                          ),
                        ),
                      // Active pill background
                      if (isActive)
                        FadeTransition(
                          opacity: _fadeAnimations[index],
                          child: Container(
                            width: 44,
                            height: 34,
                            decoration: BoxDecoration(
                              color: const Color(0xFF3D8EFF).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      // Icon
                      Icon(
                        isActive ? item.activeIcon : item.icon,
                        size: 22,
                        color: isActive
                            ? const Color(0xFF3D8EFF)
                            : const Color(0xFF6B7280),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight:
                        isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive
                        ? const Color(0xFF3D8EFF)
                        : const Color(0xFF6B7280),
                    letterSpacing: isActive ? 0.2 : 0,
                  ),
                  child: Text(item.label),
                ),
                // Active dot indicator
                const SizedBox(height: 3),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  width: isActive ? 16 : 0,
                  height: 3,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D8EFF),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class NavbarScreen extends StatefulWidget {
  const NavbarScreen({super.key});

  @override
  State<NavbarScreen> createState() => _NavbarScreenState();
}

class _NavbarScreenState extends State<NavbarScreen> {
  final _provider = BottomNavbarProvider();

  static const _pages = [

    HomeScreen(),
    AccountScreen(),
    ProfileScreen()
  ];

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _provider,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFF0F1420),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: KeyedSubtree(
              key: ValueKey(_provider.currentIndex),
              child: _pages[_provider.currentIndex],
            ),
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: _provider.currentIndex,
            onTap: _provider.setIndex,
          ),
        );
      },
    );
  }
}

// class _PlaceholderPage extends StatelessWidget {
//   final String label;
//   final IconData icon;

//   const _PlaceholderPage({required this.label, required this.icon});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 64, color: const Color(0xFF3D8EFF).withOpacity(0.4)),
//           const SizedBox(height: 16),
//           Text(
//             label,
//             style: const TextStyle(
//               color: Color(0xFF6B7280),
//               fontSize: 18,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }