// // ignore_for_file: unused_field, unnecessary_import, deprecated_member_use
// import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../utils/auth_state.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen>
//     with SingleTickerProviderStateMixin {
//   final _mobileController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _obscurePassword = true;
//   late AnimationController _animController;
//   late Animation<double> _fadeAnim;
//   late Animation<Offset> _slideAnim;

//   static const Color _bgColor = Color(0xFFF5F7FA);
//   static const Color _cardColor = Colors.white;
//   static const Color _borderColor = Color(0xFFE2E8F0);
//   static const Color _textPrimary = Color(0xFF1A202C);
//   static const Color _textSecondary = Color(0xFF64748B);
//   static const Color _textMuted = Color(0xFF94A3B8);
//   static const Color _primaryBlue = Color(0xFF2563EB);
//   static const Color _primaryBlueDim = Color(0xFFEFF6FF);

//   @override
//   void initState() {
//     super.initState();
//     _animController = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 800));
//     _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
//     _slideAnim = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
//         .animate(CurvedAnimation(
//             parent: _animController, curve: Curves.easeOutCubic));
//     _animController.forward();
//   }

//   @override
//   void dispose() {
//     _animController.dispose();
//     _mobileController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _handleLogin() async {
//     if (_mobileController.text.trim().length != 10) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please enter a valid 10 digit mobile number'),
//         ),
//       );
//       return;
//     }

//     final auth = context.read<AuthState>();
//     final success = await auth.login(
//       _mobileController.text.trim(),
//       _passwordController.text,
//     );
//     if (!success && mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           backgroundColor: const Color(0xFFFEE2E2),
//           behavior: SnackBarBehavior.floating,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           content: Row(
//             children: [
//               const Icon(Icons.error_outline,
//                   color: Color(0xFFDC2626), size: 18),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Text(auth.error ?? 'Login failed',
//                     style: const TextStyle(
//                         color: Color(0xFFDC2626), fontSize: 13)),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//   }

//   Future<void> _openUrl(String url) async {
//     final uri = Uri.parse(url);
//     try {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } catch (_) {
//       await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
//     }
//   }

//   Future<void> _openPlayStore() async {
//     await _openUrl(
//         'https://play.google.com/store/apps/details?id=com.pixelmind.brando');
//   }

//   Future<void> _openFacebook() async {
//     await _openUrl('https://www.facebook.com');
//   }

//   Future<void> _openInstagram() async {
//     await _openUrl('https://www.instagram.com');
//   }

//   Future<void> _openWhatsApp() async {
//     await _openUrl('https://wa.me/919961593179');
//   }

//   @override
//   Widget build(BuildContext context) {
//     final auth = context.watch<AuthState>();
//     return Scaffold(
//       backgroundColor: _bgColor,
//       body: SafeArea(
//         child: FadeTransition(
//           opacity: _fadeAnim,
//           child: SlideTransition(
//             position: _slideAnim,
//             child: Center(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(28),
//                 child: ConstrainedBox(
//                   constraints: const BoxConstraints(maxWidth: 380),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Center(
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(18),
//                           child: Image.asset(
//                             'assets/companylogo.png',
//                             width: 80,
//                             height: 80,
//                             fit: BoxFit.contain,
//                             errorBuilder: (context, error, stackTrace) {
//                               return Container(
//                                 width: 80,
//                                 height: 80,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(18),
//                                   gradient: const LinearGradient(
//                                     colors: [
//                                       _primaryBlue,
//                                       Color(0xFF0065FF),
//                                     ],
//                                     begin: Alignment.topLeft,
//                                     end: Alignment.bottomRight,
//                                   ),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: _primaryBlue.withOpacity(0.30),
//                                       blurRadius: 24,
//                                       offset: const Offset(0, 8),
//                                     ),
//                                   ],
//                                 ),
//                                 child: const Icon(Icons.shield_outlined,
//                                     color: Colors.white, size: 36),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       const Center(
//                         child: Text(
//                           'Welcome Brando',
//                           style: TextStyle(
//                             color: _textPrimary,
//                             fontSize: 26,
//                             fontWeight: FontWeight.w700,
//                             letterSpacing: -0.5,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       const Center(
//                         child: Text(
//                           'Sign in to your account',
//                           style: TextStyle(
//                             color: _textSecondary,
//                             fontSize: 13,
//                             height: 1.5,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 32),
//                       Container(
//                         padding: const EdgeInsets.all(24),
//                         decoration: BoxDecoration(
//                           color: _cardColor,
//                           borderRadius: BorderRadius.circular(20),
//                           border: Border.all(color: _borderColor),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.06),
//                               blurRadius: 20,
//                               offset: const Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Mobile Number',
//                               style: TextStyle(
//                                 color: _textSecondary,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             TextField(
//                               controller: _mobileController,
//                               keyboardType: TextInputType.number,
//                               maxLength: 10,
//                               inputFormatters: [
//                                 FilteringTextInputFormatter.digitsOnly,
//                                 LengthLimitingTextInputFormatter(10),
//                               ],
//                               style: const TextStyle(color: _textPrimary),
//                               decoration: InputDecoration(
//                                 counterText: '',
//                                 hintText: 'Enter Mobile Number',
//                                 hintStyle: const TextStyle(color: _textMuted),
//                                 filled: true,
//                                 fillColor: const Color(0xFFF8FAFC),
//                                 prefixIcon: const Icon(
//                                   Icons.phone_outlined,
//                                   size: 18,
//                                   color: _textMuted,
//                                 ),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide:
//                                       const BorderSide(color: _borderColor),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide:
//                                       const BorderSide(color: _borderColor),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: const BorderSide(
//                                     color: _primaryBlue,
//                                     width: 1.5,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//                             const Text(
//                               'Password',
//                               style: TextStyle(
//                                 color: _textSecondary,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             TextField(
//                               controller: _passwordController,
//                               obscureText: _obscurePassword,
//                               style: const TextStyle(color: _textPrimary),
//                               onSubmitted: (_) => _handleLogin(),
//                               decoration: InputDecoration(
//                                 hintText: '••••••••',
//                                 hintStyle: const TextStyle(color: _textMuted),
//                                 filled: true,
//                                 fillColor: const Color(0xFFF8FAFC),
//                                 prefixIcon: const Icon(Icons.lock_outline,
//                                     size: 18, color: _textMuted),
//                                 suffixIcon: IconButton(
//                                   icon: Icon(
//                                     _obscurePassword
//                                         ? Icons.visibility_off_outlined
//                                         : Icons.visibility_outlined,
//                                     size: 18,
//                                     color: _textMuted,
//                                   ),
//                                   onPressed: () => setState(() =>
//                                       _obscurePassword = !_obscurePassword),
//                                 ),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide:
//                                       const BorderSide(color: _borderColor),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide:
//                                       const BorderSide(color: _borderColor),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: const BorderSide(
//                                       color: _primaryBlue, width: 1.5),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 28),
//                             SizedBox(
//                               width: double.infinity,
//                               height: 48,
//                               child: ElevatedButton(
//                                 onPressed: auth.isLoading ? null : _handleLogin,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: _primaryBlue,
//                                   foregroundColor: Colors.white,
//                                   elevation: 0,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                                 child: auth.isLoading
//                                     ? const SizedBox(
//                                         height: 18,
//                                         width: 18,
//                                         child: CircularProgressIndicator(
//                                             strokeWidth: 2,
//                                             color: Colors.white),
//                                       )
//                                     : const Text(
//                                         'Sign In',
//                                         style: TextStyle(
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 28),
//                       const Center(
//                         child: Text(
//                           'Follow us on',
//                           style: TextStyle(
//                             color: _textMuted,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 14),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           _SocialButton(
//                             onTap: _openFacebook,
//                             color: const Color(0xFF1877F2),
//                             bgColor: const Color(0xFFE7F0FD),
//                             icon: Icons.facebook_rounded,
//                             label: 'Facebook',
//                           ),
//                           const SizedBox(width: 16),
//                           _SocialButton(
//                             onTap: _openInstagram,
//                             color: const Color(0xFFE1306C),
//                             bgColor: const Color(0xFFFCE4EC),
//                             label: 'Instagram',
//                             networkImageUrl:
//                                 'https://img.magnific.com/free-vector/instagram-vector-social-media-icon-7-june-2021-bangkok-thailand_53876-136728.jpg?semt=ais_hybrid&w=740&q=80',
//                           ),
//                           const SizedBox(width: 16),
//                           _SocialButton(
//                             onTap: _openWhatsApp,
//                             color: const Color(0xFF25D366),
//                             bgColor: const Color(0xFFE8F8EE),
//                             label: 'WhatsApp',
//                             networkImageUrl:
//                                 'https://play-lh.googleusercontent.com/bYtqbOcTYOlgc6gqZ2rwb8lptHuwlNE75zYJu6Bn076-hTmvd96HH-6v7S0YUAAJXoJN',
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 28),
//                       Center(
//                         child: Container(
//                           decoration: BoxDecoration(
//                             gradient: const LinearGradient(
//                               colors: [
//                                 Color(0xFF2563EB),
//                                 Color(0xFF7C3AED),
//                               ],
//                               begin: Alignment.centerLeft,
//                               end: Alignment.centerRight,
//                             ),
//                             borderRadius: BorderRadius.circular(14),
//                             boxShadow: [
//                               BoxShadow(
//                                 color:
//                                     const Color(0xFF2563EB).withOpacity(0.35),
//                                 blurRadius: 16,
//                                 offset: const Offset(0, 6),
//                               ),
//                             ],
//                           ),
//                           child: Material(
//                             color: Colors.transparent,
//                             child: InkWell(
//                               onTap: _openPlayStore,
//                               borderRadius: BorderRadius.circular(14),
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 24, vertical: 14),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.all(6),
//                                       decoration: BoxDecoration(
//                                         color: Colors.white.withOpacity(0.2),
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: const Icon(
//                                         Icons.shop_outlined,
//                                         size: 16,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 10),
//                                     const Text(
//                                       'Check our projects',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600,
//                                         letterSpacing: 0.2,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     const Icon(
//                                       Icons.arrow_forward_ios_rounded,
//                                       size: 13,
//                                       color: Colors.white70,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _SocialButton extends StatelessWidget {
//   final VoidCallback onTap;
//   final Color color;
//   final Color bgColor;
//   final String label;
//   final IconData? icon;
//   final String? networkImageUrl;

//   const _SocialButton({
//     required this.onTap,
//     required this.color,
//     required this.bgColor,
//     required this.label,
//     this.icon,
//     this.networkImageUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Container(
//             width: 56,
//             height: 56,
//             decoration: BoxDecoration(
//               color: bgColor,
//               shape: BoxShape.circle,
//               border: Border.all(
//                 color: color.withOpacity(0.25),
//                 width: 1.5,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: color.withOpacity(0.18),
//                   blurRadius: 12,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: ClipOval(
//               child: networkImageUrl != null
//                   ? Image.network(
//                       networkImageUrl!,
//                       width: 56,
//                       height: 56,
//                       fit: BoxFit.cover,
//                       loadingBuilder: (context, child, loadingProgress) {
//                         if (loadingProgress == null) return child;
//                         return Center(
//                           child: SizedBox(
//                             width: 22,
//                             height: 22,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: color,
//                             ),
//                           ),
//                         );
//                       },
//                       errorBuilder: (context, error, stackTrace) => Icon(
//                           Icons.image_not_supported_outlined,
//                           color: color,
//                           size: 24),
//                     )
//                   : Icon(icon, color: color, size: 26),
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             label,
//             style: TextStyle(
//               color: color,
//               fontSize: 10,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

















// ignore_for_file: unused_field, unnecessary_import, deprecated_member_use
import 'package:client_support_app/provider/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  static const Color _bgColor = Color(0xFFF5F7FA);
  static const Color _cardColor = Colors.white;
  static const Color _borderColor = Color(0xFFE2E8F0);
  static const Color _textPrimary = Color(0xFF1A202C);
  static const Color _textSecondary = Color(0xFF64748B);
  static const Color _textMuted = Color(0xFF94A3B8);
  static const Color _primaryBlue = Color(0xFF2563EB);
  static const Color _primaryBlueDim = Color(0xFFEFF6FF);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Login Handler ─────────────────────────────────
  Future<void> _handleLogin() async {
    if (_mobileController.text.trim().length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10 digit mobile number'),
        ),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final success = await auth.login(
      phone: _mobileController.text.trim(),
      password: _passwordController.text,
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFFEE2E2),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Row(
            children: [
              const Icon(Icons.error_outline,
                  color: Color(0xFFDC2626), size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  auth.errorMessage.isNotEmpty
                      ? auth.errorMessage
                      : 'Login failed',
                  style: const TextStyle(
                      color: Color(0xFFDC2626), fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  // ── URL Helpers ───────────────────────────────────
  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    }
  }

  Future<void> _openPlayStore() async {
    await _openUrl(
        'https://play.google.com/store/apps/details?id=com.pixelmind.brando');
  }

  Future<void> _openFacebook() async {
    await _openUrl('https://www.facebook.com');
  }

  Future<void> _openInstagram() async {
    await _openUrl('https://www.instagram.com');
  }

  Future<void> _openWhatsApp() async {
    await _openUrl('https://wa.me/919961593179');
  }

  @override
  Widget build(BuildContext context) {
    // Watch only isLoading to avoid unnecessary rebuilds
    final isLoading = context.select<AuthProvider, bool>((a) => a.isLoading);

    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Logo ───────────────────────────────────
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.asset(
                            'assets/companylogo.png',
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  gradient: const LinearGradient(
                                    colors: [
                                      _primaryBlue,
                                      Color(0xFF0065FF),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _primaryBlue.withOpacity(0.30),
                                      blurRadius: 24,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.shield_outlined,
                                    color: Colors.white, size: 36),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Title ──────────────────────────────────
                      const Center(
                        child: Text(
                          'Welcome Brando',
                          style: TextStyle(
                            color: _textPrimary,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Center(
                        child: Text(
                          'Sign in to your account',
                          style: TextStyle(
                            color: _textSecondary,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // ── Login Card ─────────────────────────────
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: _cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _borderColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Mobile field
                            const Text(
                              'Mobile Number',
                              style: TextStyle(
                                color: _textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _mobileController,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              style: const TextStyle(color: _textPrimary),
                              decoration: InputDecoration(
                                counterText: '',
                                hintText: 'Enter Mobile Number',
                                hintStyle:
                                    const TextStyle(color: _textMuted),
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                                prefixIcon: const Icon(
                                  Icons.phone_outlined,
                                  size: 18,
                                  color: _textMuted,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: _borderColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: _borderColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: _primaryBlue,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Password field
                            const Text(
                              'Password',
                              style: TextStyle(
                                color: _textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: const TextStyle(color: _textPrimary),
                              onSubmitted: (_) =>
                                  isLoading ? null : _handleLogin(),
                              decoration: InputDecoration(
                                hintText: '••••••••',
                                hintStyle:
                                    const TextStyle(color: _textMuted),
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                                prefixIcon: const Icon(Icons.lock_outline,
                                    size: 18, color: _textMuted),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 18,
                                    color: _textMuted,
                                  ),
                                  onPressed: () => setState(() =>
                                      _obscurePassword = !_obscurePassword),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: _borderColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: _borderColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: _primaryBlue, width: 1.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),

                            // Sign In button
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed:
                                    isLoading ? null : _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _primaryBlue,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor:
                                      _primaryBlue.withOpacity(0.6),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white),
                                      )
                                    : const Text(
                                        'Sign In',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // ── Social Links ───────────────────────────
                      const Center(
                        child: Text(
                          'Follow us on',
                          style: TextStyle(
                            color: _textMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SocialButton(
                            onTap: _openFacebook,
                            color: const Color(0xFF1877F2),
                            bgColor: const Color(0xFFE7F0FD),
                            icon: Icons.facebook_rounded,
                            label: 'Facebook',
                          ),
                          const SizedBox(width: 16),
                          _SocialButton(
                            onTap: _openInstagram,
                            color: const Color(0xFFE1306C),
                            bgColor: const Color(0xFFFCE4EC),
                            label: 'Instagram',
                            networkImageUrl:
                                'https://img.magnific.com/free-vector/instagram-vector-social-media-icon-7-june-2021-bangkok-thailand_53876-136728.jpg?semt=ais_hybrid&w=740&q=80',
                          ),
                          const SizedBox(width: 16),
                          _SocialButton(
                            onTap: _openWhatsApp,
                            color: const Color(0xFF25D366),
                            bgColor: const Color(0xFFE8F8EE),
                            label: 'WhatsApp',
                            networkImageUrl:
                                'https://play-lh.googleusercontent.com/bYtqbOcTYOlgc6gqZ2rwb8lptHuwlNE75zYJu6Bn076-hTmvd96HH-6v7S0YUAAJXoJN',
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // ── Play Store CTA ─────────────────────────
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF2563EB),
                                Color(0xFF7C3AED),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2563EB).withOpacity(0.35),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _openPlayStore,
                              borderRadius: BorderRadius.circular(14),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 14),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.shop_outlined,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Check our projects',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 13,
                                      color: Colors.white70,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Social Button Widget ─────────────────────────────
class _SocialButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final Color bgColor;
  final String label;
  final IconData? icon;
  final String? networkImageUrl;

  const _SocialButton({
    required this.onTap,
    required this.color,
    required this.bgColor,
    required this.label,
    this.icon,
    this.networkImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withOpacity(0.25),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.18),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: networkImageUrl != null
                  ? Image.network(
                      networkImageUrl!,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: color,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.image_not_supported_outlined,
                          color: color,
                          size: 24),
                    )
                  : Icon(icon, color: color, size: 26),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}