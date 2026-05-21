// // ignore_for_file: unused_element_parameter, deprecated_member_use, prefer_const_declarations

// import 'dart:async';
// import 'package:client_support_app/provider/auth/auth_provider.dart';
// import 'package:client_support_app/provider/auth/profile_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../theme/app_theme.dart';
// import 'alerts_screen.dart';
// import 'profile_screen.dart';

// class _Light {
//   static const Color bg = Color(0xFFF4F7FB);
//   static const Color card = Colors.white;
//   static const Color primary = Color(0xFF4A90D9);
//   static const Color accent = Color(0xFF5BC8AF);
//   static const Color textDark = Color(0xFF1A2340);
//   static const Color textMid = Color(0xFF4A5568);
//   static const Color textLight = Color(0xFF8A97AC);
//   static const Color green = Color(0xFF01875F);
//   static const Color greenEnd = Color(0xFF34A853);
// }

// class _CredentialGroup {
//   final String title;
//   final IconData icon;
//   final Color iconColor;
//   final Color iconBg;
//   final List<_CredField> fields;
//   bool expanded;

//   _CredentialGroup({
//     required this.title,
//     required this.icon,
//     required this.iconColor,
//     required this.iconBg,
//     required this.fields,
//     this.expanded = false,
//   });
// }

// class _CredField {
//   final String label;
//   final String value;
//   final IconData icon;
//   final bool isSecret;

//   const _CredField({
//     required this.label,
//     required this.value,
//     required this.icon,
//     this.isSecret = false,
//   });
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     final auth = context.watch<AuthProvider>();

//     if (auth.client == null) return const SizedBox.shrink();

//     final pages = const [
//       _DashboardTab(),
//       AlertsScreen(),
//       ProfileScreen(),
//     ];

//     return PopScope(
//       canPop: false,
//       onPopInvoked: (bool didPop) async {
//         if (didPop) return;
//         final shouldExit = await showDialog<bool>(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Exit App'),
//             content: const Text('Are you sure you want to exit?'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(false),
//                 child: const Text('Cancel'),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(true),
//                 style: TextButton.styleFrom(foregroundColor: Colors.red),
//                 child: const Text('Exit'),
//               ),
//             ],
//           ),
//         );
//         if (shouldExit == true) {
//           SystemNavigator.pop();
//         }
//       },
//       child: Scaffold(
//         backgroundColor: _Light.bg,
//         body: IndexedStack(index: _selectedIndex, children: pages),
//         bottomNavigationBar: _BottomNav(
//           selectedIndex: _selectedIndex,
//           onTap: (i) => setState(() => _selectedIndex = i),
//         ),
//       ),
//     );
//   }
// }

// class _BottomNav extends StatelessWidget {
//   final int selectedIndex;
//   final ValueChanged<int> onTap;

//   const _BottomNav({required this.selectedIndex, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: AppTheme.surfaceElevated,
//         border: Border(top: BorderSide(color: AppTheme.surfaceBorder)),
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _NavItem(
//                 icon: Icons.grid_view_rounded,
//                 label: 'Projects',
//                 selected: selectedIndex == 0,
//                 onTap: () => onTap(0),
//               ),
//               _NavItem(
//                 icon: Icons.image_outlined,
//                 label: 'Highlights',
//                 selected: selectedIndex == 1,
//                 onTap: () => onTap(1),
//               ),
//               _NavItem(
//                 icon: Icons.person_outline,
//                 label: 'Profile',
//                 selected: selectedIndex == 2,
//                 onTap: () => onTap(2),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _NavItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool selected;
//   final int badge;
//   final VoidCallback onTap;

//   const _NavItem({
//     required this.icon,
//     required this.label,
//     required this.selected,
//     required this.onTap,
//     this.badge = 0,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final color = selected ? AppTheme.primary : AppTheme.textMuted;
//     return GestureDetector(
//       onTap: onTap,
//       behavior: HitTestBehavior.opaque,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Stack(
//             clipBehavior: Clip.none,
//             children: [
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: selected
//                       ? AppTheme.primary.withOpacity(0.12)
//                       : Colors.transparent,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Icon(icon, color: color, size: 22),
//               ),
//               if (badge > 0)
//                 Positioned(
//                   right: 8,
//                   top: 0,
//                   child: Container(
//                     padding: const EdgeInsets.all(3),
//                     decoration: const BoxDecoration(
//                       color: AppTheme.danger,
//                       shape: BoxShape.circle,
//                     ),
//                     constraints:
//                         const BoxConstraints(minWidth: 16, minHeight: 16),
//                     child: Text(
//                       '$badge',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 9,
//                         fontWeight: FontWeight.w700,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 2),
//           Text(
//             label,
//             style: TextStyle(
//               color: color,
//               fontSize: 10,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _DashboardTab extends StatefulWidget {
//   const _DashboardTab();

//   @override
//   State<_DashboardTab> createState() => _DashboardTabState();
// }

// class _DashboardTabState extends State<_DashboardTab> {
//   final PageController _pageController = PageController();
//   int _carouselIndex = 0;
//   bool _brandoExpanded = false;
//   Timer? _timer;

//   final Map<String, bool> _visibilityMap = {};

//   final List<String> _banners = [
//     'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800&q=80',
//     'https://images.unsplash.com/photo-1556742044-3c52d6e88c62?w=800&q=80',
//     'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?w=800&q=80',
//   ];

//   final List<_RenewalItem> _renewals = const [
//     _RenewalItem(icon: Icons.dns_rounded, label: 'Server', date: '31 Dec 2026'),
//     _RenewalItem(
//         icon: Icons.cloud_rounded, label: 'Cloudinary', date: '15 Mar 2026'),
//     _RenewalItem(
//         icon: Icons.sms_rounded, label: 'SMS Gateway', date: '01 Jun 2026'),
//     _RenewalItem(
//         icon: Icons.play_circle_rounded,
//         label: 'Play Console',
//         date: '22 Aug 2026'),
//     _RenewalItem(
//         icon: Icons.apple_rounded, label: 'App Store', date: '10 Sep 2026'),
//     _RenewalItem(
//         icon: Icons.numbers_rounded, label: 'DUNS Number', date: '05 Jan 2027'),
//   ];

//   late final List<_CredentialGroup> _credentialGroups;

//   @override
//   void initState() {
//     super.initState();

//     _credentialGroups = [
//       _CredentialGroup(
//         title: 'Brando App',
//         icon: Icons.rocket_launch_rounded,
//         iconColor: _Light.primary,
//         iconBg: _Light.primary.withOpacity(0.12),
//         fields: const [
//           _CredField(
//             label: 'Email',
//             value: 'brando@pixelmind.in',
//             icon: Icons.email_outlined,
//           ),
//           _CredField(
//             label: 'Password',
//             value: 'Br@ndo#2024!',
//             icon: Icons.key_rounded,
//             isSecret: true,
//           ),
//         ],
//       ),
//       _CredentialGroup(
//         title: 'Play Store',
//         icon: Icons.play_circle_filled_rounded,
//         iconColor: _Light.green,
//         iconBg: _Light.green.withOpacity(0.12),
//         fields: const [
//           _CredField(
//             label: 'Email',
//             value: 'playconsole@pixelmind.in',
//             icon: Icons.email_outlined,
//           ),
//           _CredField(
//             label: 'Password',
//             value: 'Playst0re#2024',
//             icon: Icons.key_rounded,
//             isSecret: true,
//           ),
//           _CredField(
//             label: 'Package Name',
//             value: 'com.pixelmind.brando',
//             icon: Icons.tag_rounded,
//           ),
//         ],
//       ),
//       _CredentialGroup(
//         title: 'Server',
//         icon: Icons.dns_rounded,
//         iconColor: const Color(0xFFE67E22),
//         iconBg: const Color(0xFFE67E22).withOpacity(0.12),
//         fields: const [
//           _CredField(
//             label: 'Host',
//             value: '192.168.1.100',
//             icon: Icons.computer_rounded,
//           ),
//           _CredField(
//             label: 'Username',
//             value: 'root',
//             icon: Icons.person_outline_rounded,
//           ),
//           _CredField(
//             label: 'Password',
//             value: 'S3rv3r@Secure!',
//             icon: Icons.key_rounded,
//             isSecret: true,
//           ),
//           _CredField(
//             label: 'Port',
//             value: '22',
//             icon: Icons.settings_ethernet_rounded,
//           ),
//         ],
//       ),
//       _CredentialGroup(
//         title: 'Cloudinary',
//         icon: Icons.cloud_rounded,
//         iconColor: const Color(0xFF3448C5),
//         iconBg: const Color(0xFF3448C5).withOpacity(0.12),
//         fields: const [
//           _CredField(
//             label: 'Cloud Name',
//             value: 'pixelmind',
//             icon: Icons.cloud_queue_rounded,
//           ),
//           _CredField(
//             label: 'API Key',
//             value: '874523109234871',
//             icon: Icons.vpn_key_outlined,
//             isSecret: true,
//           ),
//           _CredField(
//             label: 'API Secret',
//             value: 'xK9mN2pQ7rT4wY1zA8bC3dE6f',
//             icon: Icons.lock_outline_rounded,
//             isSecret: true,
//           ),
//         ],
//       ),
//       _CredentialGroup(
//         title: 'SMS Gateway',
//         icon: Icons.sms_rounded,
//         iconColor: const Color(0xFF9B59B6),
//         iconBg: const Color(0xFF9B59B6).withOpacity(0.12),
//         fields: const [
//           _CredField(
//             label: 'Provider',
//             value: 'Twilio',
//             icon: Icons.business_rounded,
//           ),
//           _CredField(
//             label: 'Account SID',
//             value: 'AC1a2b3c4d5e6f7g8h9i0j',
//             icon: Icons.badge_outlined,
//             isSecret: true,
//           ),
//           _CredField(
//             label: 'Auth Token',
//             value: '9z8y7x6w5v4u3t2s1r0q',
//             icon: Icons.key_rounded,
//             isSecret: true,
//           ),
//           _CredField(
//             label: 'Phone Number',
//             value: '+1 (415) 555-0100',
//             icon: Icons.phone_rounded,
//           ),
//         ],
//       ),
//     ];

//     _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
//       if (_pageController.hasClients) {
//         int nextPage = _carouselIndex + 1;
//         if (nextPage >= _banners.length) nextPage = 0;
//         _pageController.animateToPage(
//           nextPage,
//           duration: const Duration(milliseconds: 500),
//           curve: Curves.easeInOut,
//         );
//       }
//     });
//   }

//   String get _formattedDate {
//     final now = DateTime.now();
//     const months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec',
//     ];
//     const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
//     return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }

//   bool _isVisible(int groupIndex, int fieldIndex) =>
//       _visibilityMap['$groupIndex-$fieldIndex'] ?? false;

//   void _toggleVisibility(int groupIndex, int fieldIndex) {
//     setState(() {
//       final key = '$groupIndex-$fieldIndex';
//       _visibilityMap[key] = !(_visibilityMap[key] ?? false);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ColoredBox(
//       color: _Light.bg,
//       child: CustomScrollView(
//         slivers: [
//           SliverToBoxAdapter(child: _buildAppBar(context)),
//           SliverToBoxAdapter(child: _buildCarousel()),
//           SliverToBoxAdapter(child: _buildBrandoSection()),
//           SliverToBoxAdapter(child: _buildCredentialSection()),
//           SliverToBoxAdapter(child: _buildPlayStoreCard()),
//           SliverToBoxAdapter(child: _buildIOSCard()),
//           SliverToBoxAdapter(child: _buildWebsiteCard()),
//           const SliverToBoxAdapter(child: SizedBox(height: 32)),
//         ],
//       ),
//     );
//   }

//   Widget _buildAppBar(BuildContext context) {
//     final client = context.read<AuthProvider>().client!;

//     final clientProvider = context.watch<ClientProvider>();
//     final profileImageUrl = clientProvider.profileImageUrl;

//     return Container(
//       color: _Light.card,
//       padding: const EdgeInsets.fromLTRB(20, 0, 12, 14),
//       child: SafeArea(
//         bottom: false,
//         child: Row(
//           children: [
//             Container(
//               width: 44,
//               height: 44,
//               decoration: BoxDecoration(
//                 color: _Light.primary.withOpacity(0.15),
//                 borderRadius: BorderRadius.circular(22),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(22),
//                 child: profileImageUrl.isNotEmpty
//                     ? Image.network(
//                         profileImageUrl,
//                         key: ValueKey(profileImageUrl),
//                         fit: BoxFit.cover,
//                         errorBuilder: (_, __, ___) => const Icon(
//                           Icons.person,
//                           color: _Light.primary,
//                           size: 24,
//                         ),
//                       )
//                     : const Icon(
//                         Icons.person,
//                         color: _Light.primary,
//                         size: 24,
//                       ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     'Welcome back,',
//                     style: TextStyle(
//                       fontSize: 11,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 1),
//                   Text(
//                     client.name.split(' ').first,
//                     style: const TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.w700,
//                       color: _Light.textDark,
//                       letterSpacing: -0.3,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Row(
//                     children: [
//                       const Icon(Icons.calendar_today_rounded,
//                           size: 11, color: Colors.black),
//                       const SizedBox(width: 4),
//                       Text(
//                         _formattedDate,
//                         style: const TextStyle(
//                           fontSize: 11,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             // IconButton(
//             //   icon: const Icon(Icons.search,
//             //       color: AppTheme.textSecondary, size: 22),
//             //   onPressed: () => Navigator.push(
//             //     context,
//             //     MaterialPageRoute(
//             //       builder: (_) => SearchScreen(
//             //         allProjects: client.projects,
//             //       ),
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCarousel() {
//     return Column(
//       children: [
//         const SizedBox(height: 20),
//         SizedBox(
//           height: 168,
//           child: PageView.builder(
//             controller: _pageController,
//             itemCount: _banners.length,
//             onPageChanged: (i) => setState(() => _carouselIndex = i),
//             itemBuilder: (_, i) => Container(
//               margin: const EdgeInsets.symmetric(horizontal: 20),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(18),
//                 boxShadow: [
//                   BoxShadow(
//                     color: _Light.primary.withOpacity(0.15),
//                     blurRadius: 14,
//                     offset: const Offset(0, 6),
//                   ),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(18),
//                 child: Image.network(
//                   _banners[i],
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                   errorBuilder: (_, __, ___) => Container(
//                     color: _Light.primary.withOpacity(0.08),
//                     child: const Icon(Icons.image_rounded,
//                         color: _Light.primary, size: 40),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 10),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: List.generate(
//             _banners.length,
//             (i) => AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               margin: const EdgeInsets.symmetric(horizontal: 3),
//               width: i == _carouselIndex ? 18.0 : 6.0,
//               height: 6,
//               decoration: BoxDecoration(
//                 color: i == _carouselIndex ? _Light.primary : _Light.textLight,
//                 borderRadius: BorderRadius.circular(3),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildBrandoSection() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           GestureDetector(
//             onTap: () => setState(() => _brandoExpanded = !_brandoExpanded),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//               decoration: BoxDecoration(
//                 color: _Light.card,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: AppTheme.surfaceBorder),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.04),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: _Light.primary.withOpacity(0.12),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Icon(Icons.rocket_launch_rounded,
//                         color: _Light.primary, size: 18),
//                   ),
//                   const SizedBox(width: 12),
//                   const Text(
//                     'Brando',
//                     style: TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.w700,
//                       color: _Light.textDark,
//                       letterSpacing: 0.2,
//                     ),
//                   ),
//                   const Spacer(),
//                   AnimatedRotation(
//                     turns: _brandoExpanded ? 0.5 : 0,
//                     duration: const Duration(milliseconds: 300),
//                     child: const Icon(Icons.keyboard_arrow_down_rounded,
//                         color: _Light.textMid),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           AnimatedCrossFade(
//             duration: const Duration(milliseconds: 350),
//             crossFadeState: _brandoExpanded
//                 ? CrossFadeState.showSecond
//                 : CrossFadeState.showFirst,
//             firstChild: const SizedBox.shrink(),
//             secondChild: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 16),
//                 const Text(
//                   'RENEWAL DATE:',
//                   style: TextStyle(
//                     fontSize: 11,
//                     fontWeight: FontWeight.w700,
//                     color: _Light.textLight,
//                     letterSpacing: 1.1,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 GridView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: _renewals.length,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     mainAxisSpacing: 12,
//                     crossAxisSpacing: 12,
//                     childAspectRatio: 1.65,
//                   ),
//                   itemBuilder: (_, i) => _buildRenewalCard(_renewals[i]),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRenewalCard(_RenewalItem item) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: _Light.card,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: AppTheme.surfaceBorder),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Icon(item.icon, color: _Light.primary, size: 16),
//               const SizedBox(width: 6),
//               Expanded(
//                 child: Text(
//                   item.label,
//                   style: const TextStyle(
//                     fontSize: 11,
//                     fontWeight: FontWeight.w600,
//                     color: _Light.textMid,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//           Text(
//             item.date,
//             style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w700,
//               color: _Light.textDark,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCredentialSection() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(7),
//                 decoration: BoxDecoration(
//                   color: _Light.accent.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(Icons.lock_outline_rounded,
//                     color: _Light.accent, size: 16),
//               ),
//               const SizedBox(width: 10),
//               const Text(
//                 'Credentials',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                   color: _Light.textDark,
//                 ),
//               ),
//               const Spacer(),
//               Text(
//                 '${_credentialGroups.length} accounts',
//                 style: const TextStyle(
//                   fontSize: 12,
//                   color: _Light.textLight,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 14),
//           ...List.generate(_credentialGroups.length, (groupIndex) {
//             final group = _credentialGroups[groupIndex];
//             return _buildCredentialGroupCard(group, groupIndex);
//           }),
//         ],
//       ),
//     );
//   }

//   Widget _buildCredentialGroupCard(_CredentialGroup group, int groupIndex) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: _Light.card,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppTheme.surfaceBorder),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           GestureDetector(
//             onTap: () => setState(() => group.expanded = !group.expanded),
//             behavior: HitTestBehavior.opaque,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: group.iconBg,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Icon(group.icon, color: group.iconColor, size: 17),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       group.title,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                         color: _Light.textDark,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF4F7FB),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: AppTheme.surfaceBorder),
//                     ),
//                     child: Text(
//                       '${group.fields.length} fields',
//                       style: const TextStyle(
//                         fontSize: 10,
//                         fontWeight: FontWeight.w600,
//                         color: _Light.textLight,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   AnimatedRotation(
//                     turns: group.expanded ? 0.5 : 0,
//                     duration: const Duration(milliseconds: 250),
//                     child: const Icon(
//                       Icons.keyboard_arrow_down_rounded,
//                       color: _Light.textMid,
//                       size: 20,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           AnimatedCrossFade(
//             duration: const Duration(milliseconds: 300),
//             crossFadeState: group.expanded
//                 ? CrossFadeState.showSecond
//                 : CrossFadeState.showFirst,
//             firstChild: const SizedBox.shrink(),
//             secondChild: Column(
//               children: [
//                 const Divider(height: 1, color: AppTheme.surfaceBorder),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
//                   child: Column(
//                     children: List.generate(group.fields.length, (fieldIndex) {
//                       final field = group.fields[fieldIndex];
//                       final visible = _isVisible(groupIndex, fieldIndex);
//                       return Padding(
//                         padding: EdgeInsets.only(
//                           bottom:
//                               fieldIndex < group.fields.length - 1 ? 12.0 : 0.0,
//                         ),
//                         child: _buildFieldRow(
//                           field: field,
//                           visible: visible,
//                           onToggle: field.isSecret
//                               ? () => _toggleVisibility(groupIndex, fieldIndex)
//                               : null,
//                         ),
//                       );
//                     }),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFieldRow({
//     required _CredField field,
//     required bool visible,
//     VoidCallback? onToggle,
//   }) {
//     final displayValue =
//         (field.isSecret && !visible) ? '••••••••••••' : field.value;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           field.label.toUpperCase(),
//           style: const TextStyle(
//             fontSize: 10,
//             fontWeight: FontWeight.w600,
//             color: _Light.textLight,
//             letterSpacing: 0.9,
//           ),
//         ),
//         const SizedBox(height: 6),
//         Row(
//           children: [
//             Expanded(
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF4F7FB),
//                   borderRadius: BorderRadius.circular(11),
//                   border: Border.all(color: AppTheme.surfaceBorder),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(field.icon, color: _Light.primary, size: 14),
//                     const SizedBox(width: 9),
//                     Expanded(
//                       child: Text(
//                         displayValue,
//                         style: const TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500,
//                           color: _Light.textDark,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             GestureDetector(
//               onTap: () {
//                 Clipboard.setData(ClipboardData(text: field.value));
//               },
//               child: Container(
//                 padding: const EdgeInsets.all(9),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF4F7FB),
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: AppTheme.surfaceBorder),
//                 ),
//                 child: const Icon(Icons.copy_rounded,
//                     size: 15, color: _Light.textMid),
//               ),
//             ),
//             if (field.isSecret) ...[
//               const SizedBox(width: 6),
//               GestureDetector(
//                 onTap: onToggle,
//                 child: Container(
//                   padding: const EdgeInsets.all(9),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF4F7FB),
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: AppTheme.surfaceBorder),
//                   ),
//                   child: Icon(
//                     visible
//                         ? Icons.visibility_off_outlined
//                         : Icons.visibility_outlined,
//                     size: 15,
//                     color: _Light.textMid,
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildIOSCard() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
//       child: GestureDetector(
//         onTap: () async {
//           final uri = Uri.parse(
//             'https://apps.apple.com/in/app/brando-hostel-booking-app/id6766164403',
//           );
//           await launchUrl(uri, mode: LaunchMode.externalApplication);
//         },
//         child: Container(
//           padding: const EdgeInsets.all(18),
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [Color(0xFF1E1E1E), Color(0xFF3A3A3A)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(18),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.2),
//                 blurRadius: 14,
//                 offset: const Offset(0, 6),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               Container(
//                 width: 48,
//                 height: 48,
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: const Icon(Icons.apple_rounded,
//                     color: Colors.white, size: 28),
//               ),
//               const SizedBox(width: 14),
//               const Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Brando iOS',
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(height: 3),
//                     Text(
//                       'View on Apple App Store',
//                       style: TextStyle(fontSize: 12, color: Colors.white70),
//                     ),
//                   ],
//                 ),
//               ),
//               const Icon(Icons.arrow_forward_ios_rounded,
//                   color: Colors.white70, size: 15),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildWebsiteCard() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
//       child: GestureDetector(
//         onTap: () async {
//           final uri = Uri.parse('https://brando.org.in/');
//           await launchUrl(uri, mode: LaunchMode.externalApplication);
//         },
//         child: Container(
//           padding: const EdgeInsets.all(18),
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [Color(0xFF4A90D9), Color(0xFF5BC8AF)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(18),
//             boxShadow: [
//               BoxShadow(
//                 color: _Light.primary.withOpacity(0.25),
//                 blurRadius: 14,
//                 offset: const Offset(0, 6),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               Container(
//                 width: 48,
//                 height: 48,
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.18),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: const Icon(Icons.language_rounded,
//                     color: Colors.white, size: 26),
//               ),
//               const SizedBox(width: 14),
//               const Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Official Website',
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(height: 3),
//                     Text(
//                       'Visit Brando Website',
//                       style: TextStyle(fontSize: 12, color: Colors.white70),
//                     ),
//                   ],
//                 ),
//               ),
//               const Icon(Icons.arrow_forward_ios_rounded,
//                   color: Colors.white70, size: 15),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPlayStoreCard() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
//       child: GestureDetector(
//         onTap: () async {
//           final uri = Uri.parse(
//             'https://play.google.com/store/apps/details?id=com.pixelmind.brando',
//           );
//           if (await canLaunchUrl(uri)) {
//             await launchUrl(uri, mode: LaunchMode.externalApplication);
//           }
//         },
//         child: Container(
//           padding: const EdgeInsets.all(18),
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [_Light.green, _Light.greenEnd],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(18),
//             boxShadow: [
//               BoxShadow(
//                 color: _Light.green.withOpacity(0.3),
//                 blurRadius: 14,
//                 offset: const Offset(0, 6),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               Container(
//                 width: 48,
//                 height: 48,
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: const Icon(Icons.play_arrow_rounded,
//                     color: Colors.white, size: 28),
//               ),
//               const SizedBox(width: 14),
//               const Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Brando',
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(height: 3),
//                     Text(
//                       'View on Google Play Store',
//                       style: TextStyle(fontSize: 12, color: Colors.white70),
//                     ),
//                   ],
//                 ),
//               ),
//               const Icon(Icons.arrow_forward_ios_rounded,
//                   color: Colors.white70, size: 15),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// class _RenewalItem {
//   final IconData icon;
//   final String label;
//   final String date;

//   const _RenewalItem({
//     required this.icon,
//     required this.label,
//     required this.date,
//   });
// }

// ignore_for_file: unused_element_parameter, deprecated_member_use, prefer_const_declarations

import 'dart:async';
import 'dart:convert';
import 'package:client_support_app/provider/auth/auth_provider.dart';
import 'package:client_support_app/provider/auth/profile_provider.dart';
import 'package:client_support_app/provider/credentials/credentials_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import 'alerts_screen.dart';
import 'profile_screen.dart';

class _Light {
  static const Color bg = Color(0xFFF4F7FB);
  static const Color card = Colors.white;
  static const Color primary = Color(0xFF4A90D9);
  static const Color accent = Color(0xFF5BC8AF);
  static const Color textDark = Color(0xFF1A2340);
  static const Color textMid = Color(0xFF4A5568);
  static const Color textLight = Color(0xFF8A97AC);
  static const Color green = Color(0xFF01875F);
  static const Color greenEnd = Color(0xFF34A853);
}

// ---------------------------------------------------------------------------
// Data models for credential display (built from API response)
// ---------------------------------------------------------------------------

class _CredentialGroup {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final List<_CredField> fields;
  bool expanded;

  _CredentialGroup({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.fields,
    this.expanded = false,
  });
}

class _CredField {
  final String label;
  final String value;
  final IconData icon;
  final bool isSecret;

  const _CredField({
    required this.label,
    required this.value,
    required this.icon,
    this.isSecret = false,
  });
}

// ---------------------------------------------------------------------------
// Helpers to convert raw API data → display models
// ---------------------------------------------------------------------------

/// Keys whose values should be masked by default.
final _secretKeys = {
  'password',
  'secret',
  'key',
  'token',
  'accesskey',
  'secretkey',
  'authtoken',
  'apikey',
  'apisecret',
  'sshkey',
  'secretaccesskey',
};

bool _isSecretKey(String key) {
  final lower = key.toLowerCase().replaceAll(RegExp(r'[_\s-]'), '');
  return _secretKeys.any((s) => lower.contains(s));
}

IconData _iconForKey(String key) {
  final lower = key.toLowerCase();
  if (lower.contains('email')) return Icons.email_outlined;
  if (lower.contains('password') ||
      lower.contains('secret') ||
      lower.contains('key') ||
      lower.contains('token')) {
    return Icons.key_rounded;
  }
  if (lower.contains('host') ||
      lower.contains('ip') ||
      lower.contains('address')) return Icons.computer_rounded;
  if (lower.contains('port')) return Icons.settings_ethernet_rounded;
  if (lower.contains('user')) return Icons.person_outline_rounded;
  if (lower.contains('phone')) return Icons.phone_rounded;
  if (lower.contains('bucket') || lower.contains('cloud'))
    return Icons.cloud_queue_rounded;
  if (lower.contains('region')) return Icons.map_outlined;
  if (lower.contains('package') || lower.contains('tag'))
    return Icons.tag_rounded;
  if (lower.contains('provider') ||
      lower.contains('name') ||
      lower.contains('server')) return Icons.business_rounded;
  if (lower.contains('sid') || lower.contains('id'))
    return Icons.badge_outlined;
  return Icons.info_outline_rounded;
}

String _labelForKey(String key) {
  final spaced = key.replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m[0]}');
  return spaced[0].toUpperCase() + spaced.substring(1);
}

({Color icon, Color bg, IconData iconData}) _schemeForName(String name) {
  final lower = name.toLowerCase();
  if (lower.contains('server') || lower.contains('ssh')) {
    return (
      icon: const Color(0xFFE67E22),
      bg: const Color(0xFFE67E22).withOpacity(0.12),
      iconData: Icons.dns_rounded,
    );
  }
  if (lower.contains('aws') || lower.contains('amazon')) {
    return (
      icon: const Color(0xFFFF9900),
      bg: const Color(0xFFFF9900).withOpacity(0.12),
      iconData: Icons.cloud_rounded,
    );
  }
  if (lower.contains('play') || lower.contains('google')) {
    return (
      icon: _Light.green,
      bg: _Light.green.withOpacity(0.12),
      iconData: Icons.play_circle_filled_rounded,
    );
  }
  if (lower.contains('cloud') || lower.contains('cloudinary')) {
    return (
      icon: const Color(0xFF3448C5),
      bg: const Color(0xFF3448C5).withOpacity(0.12),
      iconData: Icons.cloud_rounded,
    );
  }
  if (lower.contains('sms') ||
      lower.contains('twilio') ||
      lower.contains('message')) {
    return (
      icon: const Color(0xFF9B59B6),
      bg: const Color(0xFF9B59B6).withOpacity(0.12),
      iconData: Icons.sms_rounded,
    );
  }
  if (lower.contains('brando') || lower.contains('app')) {
    return (
      icon: _Light.primary,
      bg: _Light.primary.withOpacity(0.12),
      iconData: Icons.rocket_launch_rounded,
    );
  }
  return (
    icon: _Light.accent,
    bg: _Light.accent.withOpacity(0.12),
    iconData: Icons.lock_outline_rounded,
  );
}

_CredentialGroup _toGroup(dynamic credential) {
  final scheme = _schemeForName(credential.name as String);

  final fields = (credential.data as Map<String, dynamic>).entries.map((e) {
    return _CredField(
      label: _labelForKey(e.key),
      value: e.value?.toString() ?? '',
      icon: _iconForKey(e.key),
      isSecret: _isSecretKey(e.key),
    );
  }).toList();

  return _CredentialGroup(
    title: credential.name as String,
    icon: scheme.iconData,
    iconColor: scheme.icon,
    iconBg: scheme.bg,
    fields: fields,
  );
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.client == null) return const SizedBox.shrink();

    final pages = const [
      _DashboardTab(),
      AlertsScreen(),
      ProfileScreen(),
    ];

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Exit'),
              ),
            ],
          ),
        );
        if (shouldExit == true) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: _Light.bg,
        body: IndexedStack(index: _selectedIndex, children: pages),
        bottomNavigationBar: _BottomNav(
          selectedIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.selectedIndex, required this.onTap});

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
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.image_outlined,
                label: 'Highlights',
                selected: selectedIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: Icons.person_outline,
                label: 'Profile',
                selected: selectedIndex == 2,
                onTap: () => onTap(2),
              ),
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

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.badge = 0,
  });

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                      color: AppTheme.danger,
                      shape: BoxShape.circle,
                    ),
                    constraints:
                        const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '$badge',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
class _DashboardTab extends StatefulWidget {
  const _DashboardTab();

  @override
  State<_DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<_DashboardTab> {
  final PageController _pageController = PageController();
  int _carouselIndex = 0;
  bool _brandoExpanded = false;
  Timer? _timer;

  /// Visibility state: key = 'groupIndex-fieldIndex'
  final Map<String, bool> _visibilityMap = {};

  /// Expansion state per credential group id
  final Map<String, bool> _groupExpanded = {};

  // final List<String> _banners = [
  //   'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800&q=80',
  //   'https://images.unsplash.com/photo-1556742044-3c52d6e88c62?w=800&q=80',
  //   'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?w=800&q=80',
  // ];

  List<String> _banners = [];

  final List<_RenewalItem> _renewals = const [
    _RenewalItem(icon: Icons.dns_rounded, label: 'Server', date: '31 Dec 2026'),
    _RenewalItem(
        icon: Icons.cloud_rounded, label: 'Cloudinary', date: '15 Mar 2026'),
    _RenewalItem(
        icon: Icons.sms_rounded, label: 'SMS Gateway', date: '01 Jun 2026'),
    _RenewalItem(
        icon: Icons.play_circle_rounded,
        label: 'Play Console',
        date: '22 Aug 2026'),
    _RenewalItem(
        icon: Icons.apple_rounded, label: 'App Store', date: '10 Sep 2026'),
    _RenewalItem(
        icon: Icons.numbers_rounded, label: 'DUNS Number', date: '05 Jan 2027'),
  ];



  Future<void> _onRefresh() async {
  await Future.wait([
    _loadBanners(),
    Future(() => _loadCredentials()),
  ]);
}


  @override
  void initState() {
    super.initState();

    _loadBanners();

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = _carouselIndex + 1;
        if (nextPage >= _banners.length) nextPage = 0;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadCredentials());
  }

  void _loadCredentials() {
    final clientId = context.read<AuthProvider>().client?.id;
    if (clientId != null) {
      context.read<CredentialProvider>().loadCredentials(clientId);
    }
  }

  Future<void> _loadBanners() async {
    try {
      final response = await http.get(
        Uri.parse('http://31.97.228.17:5104/api/admin/banners'),
      );

      print('✅ Response status code for get all banners ${response.statusCode}');
      print('🚨 Response bodyyyyyyyyyyyyyyy for get all banners ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final banners = data['banners'] as List;
          setState(() {
            _banners = banners
                .where((b) => b['isActive'] == true)
                .map<String>((b) => (b['image'] as String).replaceFirst(
                      'http://localhost:5104',
                      'http://31.97.228.17:5104',
                    ))
                .toList();
          });
        }
      }
    } catch (_) {}
  }

  String get _formattedDate {
    final now = DateTime.now();
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // ---- visibility helpers --------------------------------------------------

  bool _isVisible(String groupId, int fieldIndex) =>
      _visibilityMap['$groupId-$fieldIndex'] ?? false;

  void _toggleVisibility(String groupId, int fieldIndex) {
    setState(() {
      final key = '$groupId-$fieldIndex';
      _visibilityMap[key] = !(_visibilityMap[key] ?? false);
    });
  }

  bool _isGroupExpanded(String groupId) => _groupExpanded[groupId] ?? false;

  void _toggleGroup(String groupId) {
    setState(
        () => _groupExpanded[groupId] = !(_groupExpanded[groupId] ?? false));
  }

  // ---- build ---------------------------------------------------------------

  // @override
  // Widget build(BuildContext context) {
  //   return ColoredBox(
  //     color: _Light.bg,
  //     child: CustomScrollView(
  //       slivers: [
  //         SliverToBoxAdapter(child: _buildAppBar(context)),
  //         SliverToBoxAdapter(child: _buildCarousel()),
  //         SliverToBoxAdapter(child: _buildBrandoSection()),
  //         SliverToBoxAdapter(child: _buildCredentialSection()),
  //         SliverToBoxAdapter(child: _buildPlayStoreCard()),
  //         SliverToBoxAdapter(child: _buildIOSCard()),
  //         SliverToBoxAdapter(child: _buildWebsiteCard()),
  //         const SliverToBoxAdapter(child: SizedBox(height: 32)),
  //       ],
  //     ),
  //   );
  // }




  @override
Widget build(BuildContext context) {
  return ColoredBox(
    color: _Light.bg,
    child: RefreshIndicator(
      onRefresh: _onRefresh,
      color: _Light.primary,
      backgroundColor: _Light.card,
      displacement: 60,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(), // <-- required for pull-to-refresh to always trigger
        slivers: [
          SliverToBoxAdapter(child: _buildAppBar(context)),
          SliverToBoxAdapter(child: _buildCarousel()),
          SliverToBoxAdapter(child: _buildBrandoSection()),
          SliverToBoxAdapter(child: _buildCredentialSection()),
          SliverToBoxAdapter(child: _buildPlayStoreCard()),
          SliverToBoxAdapter(child: _buildIOSCard()),
          SliverToBoxAdapter(child: _buildWebsiteCard()),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    ),
  );
}

  Widget _buildAppBar(BuildContext context) {
    final client = context.read<AuthProvider>().client!;
    final clientProvider = context.watch<ClientProvider>();
    final profileImageUrl = clientProvider.profileImageUrl;

    return Container(
      color: _Light.card,
      padding: const EdgeInsets.fromLTRB(20, 0, 12, 14),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _Light.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(22),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: profileImageUrl.isNotEmpty
                    ? Image.network(
                        profileImageUrl,
                        key: ValueKey(profileImageUrl),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.person,
                            color: _Light.primary, size: 24),
                      )
                    : const Icon(Icons.person, color: _Light.primary, size: 24),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Welcome back,',
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    client.name.split(' ').first,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: _Light.textDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          size: 11, color: Colors.black),
                      const SizedBox(width: 4),
                      Text(
                        _formattedDate,
                        style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
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

  Widget _buildCarousel() {
    return Column(
      children: [
        const SizedBox(height: 20),
        SizedBox(
          height: 168,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _banners.length,
            onPageChanged: (i) => setState(() => _carouselIndex = i),
            itemBuilder: (_, i) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: _Light.primary.withOpacity(0.15),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  _banners[i],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => Container(
                    color: _Light.primary.withOpacity(0.08),
                    child: const Icon(Icons.image_rounded,
                        color: _Light.primary, size: 40),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == _carouselIndex ? 18.0 : 6.0,
              height: 6,
              decoration: BoxDecoration(
                color: i == _carouselIndex ? _Light.primary : _Light.textLight,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBrandoSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => _brandoExpanded = !_brandoExpanded),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: _Light.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.surfaceBorder),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _Light.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.rocket_launch_rounded,
                        color: _Light.primary, size: 18),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Brando',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: _Light.textDark,
                        letterSpacing: 0.2),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: _brandoExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: _Light.textMid),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 350),
            crossFadeState: _brandoExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'RENEWAL DATE:',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _Light.textLight,
                      letterSpacing: 1.1),
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _renewals.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.65,
                  ),
                  itemBuilder: (_, i) => _buildRenewalCard(_renewals[i]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRenewalCard(_RenewalItem item) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _Light.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.surfaceBorder),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(item.icon, color: _Light.primary, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item.label,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _Light.textMid),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            item.date,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: _Light.textDark),
          ),
        ],
      ),
    );
  }

  // ---- Credential section (dynamic) ----------------------------------------

  Widget _buildCredentialSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Consumer<CredentialProvider>(
        builder: (context, provider, _) {
          // Loading state
          if (provider.isLoading) {
            return _buildCredentialSectionShell(
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                          strokeWidth: 2, color: _Light.primary),
                      SizedBox(height: 12),
                      Text(
                        'Loading credentials…',
                        style: TextStyle(fontSize: 13, color: _Light.textLight),
                      ),
                    ],
                  ),
                ),
              ),
              count: 0,
            );
          }

          // Error state
          if (provider.hasError) {
            return _buildCredentialSectionShell(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        color: AppTheme.danger, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      provider.errorMessage,
                      style:
                          const TextStyle(fontSize: 12, color: _Light.textMid),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: _loadCredentials,
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: const Text('Retry'),
                      style:
                          TextButton.styleFrom(foregroundColor: _Light.primary),
                    ),
                  ],
                ),
              ),
              count: 0,
            );
          }

          // Empty state
          if (provider.credentials.isEmpty) {
            return _buildCredentialSectionShell(
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'No credentials found.',
                    style: TextStyle(fontSize: 13, color: _Light.textLight),
                  ),
                ),
              ),
              count: 0,
            );
          }

          final groups = provider.credentials.map(_toGroup).toList();

          return _buildCredentialSectionShell(
            count: groups.length,
            child: Column(
              children: List.generate(groups.length, (i) {
                final group = groups[i];
                final groupId = provider.credentials[i];
                return _buildCredentialGroupCard(group, groupId.toString());
              }),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCredentialSectionShell(
      {required Widget child, required int count}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: _Light.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.lock_outline_rounded,
                  color: _Light.accent, size: 16),
            ),
            const SizedBox(width: 10),
            const Text(
              'Credentials',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _Light.textDark),
            ),
            const Spacer(),
            if (count > 0)
              Text(
                '$count accounts',
                style: const TextStyle(
                    fontSize: 12,
                    color: _Light.textLight,
                    fontWeight: FontWeight.w500),
              ),
          ],
        ),
        const SizedBox(height: 14),
        child,
      ],
    );
  }

  Widget _buildCredentialGroupCard(_CredentialGroup group, String groupId) {
    final expanded = _isGroupExpanded(groupId);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _Light.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceBorder),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _toggleGroup(groupId),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: group.iconBg,
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(group.icon, color: group.iconColor, size: 17),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      group.title,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _Light.textDark),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7FB),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.surfaceBorder),
                    ),
                    child: Text(
                      '${group.fields.length} fields',
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _Light.textLight),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: _Light.textMid, size: 20),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState:
                expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                const Divider(height: 1, color: AppTheme.surfaceBorder),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  child: Column(
                    children: List.generate(group.fields.length, (fieldIndex) {
                      final field = group.fields[fieldIndex];
                      final visible = _isVisible(groupId, fieldIndex);
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: fieldIndex < group.fields.length - 1
                                ? 12.0
                                : 0.0),
                        child: _buildFieldRow(
                          field: field,
                          visible: visible,
                          onToggle: field.isSecret
                              ? () => _toggleVisibility(groupId, fieldIndex)
                              : null,
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldRow({
    required _CredField field,
    required bool visible,
    VoidCallback? onToggle,
  }) {
    final displayValue =
        (field.isSecret && !visible) ? '••••••••••••' : field.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label.toUpperCase(),
          style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: _Light.textLight,
              letterSpacing: 0.9),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F7FB),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: AppTheme.surfaceBorder),
                ),
                child: Row(
                  children: [
                    Icon(field.icon, color: _Light.primary, size: 14),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        displayValue,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: _Light.textDark),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => Clipboard.setData(ClipboardData(text: field.value)),
              child: Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F7FB),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.surfaceBorder),
                ),
                child: const Icon(Icons.copy_rounded,
                    size: 15, color: _Light.textMid),
              ),
            ),
            if (field.isSecret) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F7FB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.surfaceBorder),
                  ),
                  child: Icon(
                    visible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 15,
                    color: _Light.textMid,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  // ---- Store / website cards -----------------------------------------------

  Widget _buildPlayStoreCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(
              'https://play.google.com/store/apps/details?id=com.pixelmind.brando');
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_Light.green, _Light.greenEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                  color: _Light.green.withOpacity(0.3),
                  blurRadius: 14,
                  offset: const Offset(0, 6)),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.play_arrow_rounded,
                    color: Colors.white, size: 28),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Brando',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    SizedBox(height: 3),
                    Text('View on Google Play Store',
                        style: TextStyle(fontSize: 12, color: Colors.white70)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.white70, size: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIOSCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(
              'https://apps.apple.com/in/app/brando-hostel-booking-app/id6766164403');
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E1E1E), Color(0xFF3A3A3A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 14,
                  offset: const Offset(0, 6)),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.apple_rounded,
                    color: Colors.white, size: 28),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Brando iOS',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    SizedBox(height: 3),
                    Text('View on Apple App Store',
                        style: TextStyle(fontSize: 12, color: Colors.white70)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.white70, size: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWebsiteCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse('https://brando.org.in/');
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4A90D9), Color(0xFF5BC8AF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                  color: _Light.primary.withOpacity(0.25),
                  blurRadius: 14,
                  offset: const Offset(0, 6)),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.language_rounded,
                    color: Colors.white, size: 26),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Official Website',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    SizedBox(height: 3),
                    Text('Visit Brando Website',
                        style: TextStyle(fontSize: 12, color: Colors.white70)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.white70, size: 15),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Supporting classes
// ---------------------------------------------------------------------------

class _RenewalItem {
  final IconData icon;
  final String label;
  final String date;

  const _RenewalItem(
      {required this.icon, required this.label, required this.date});
}
