// import 'package:client_support_app/screens/edit_profile_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import '../models/models.dart';
// import '../theme/app_theme.dart';
// import '../utils/auth_state.dart';

// class ProfileScreen extends StatelessWidget {
//   final Client client;
//   const ProfileScreen({super.key, required this.client});

//   @override
//   Widget build(BuildContext context) {
//     final auth = context.read<AuthState>();

//     return Scaffold(
//       backgroundColor: AppTheme.background,
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: AppTheme.background,
//         title: const Text('Profile',
//             style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 color: AppTheme.textPrimary)),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: AppTheme.surfaceElevated,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: AppTheme.surfaceBorder),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 50,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       image: const DecorationImage(
//                         image: NetworkImage(
//                           'https://hips.hearstapps.com/hmg-prod/images/henry-cavill-superman-1536761926.jpg?crop=0.49925925925925924xw:1xh;center,top&resize=640:*',
//                         ),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),

//                   // Container(
//                   //   width: 60,
//                   //   height: 60,
//                   //   decoration: BoxDecoration(
//                   //     gradient: const LinearGradient(
//                   //       colors: [AppTheme.primary, Color(0xFF0065FF)],
//                   //       begin: Alignment.topLeft,
//                   //       end: Alignment.bottomRight,
//                   //     ),
//                   //     borderRadius: BorderRadius.circular(18),
//                   //   ),
//                   //   child: Center(
//                   //     child: Text(
//                   //       client.avatarInitials,
//                   //       style: const TextStyle(
//                   //         color: Colors.white,
//                   //         fontSize: 20,
//                   //         fontWeight: FontWeight.w700,
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(client.name,
//                             style: const TextStyle(
//                               color: AppTheme.textPrimary,
//                               fontSize: 18,
//                               fontWeight: FontWeight.w700,
//                             )),
//                         const SizedBox(height: 4),
//                         Text(client.company,
//                             style: const TextStyle(
//                                 color: AppTheme.textSecondary, fontSize: 13)),
//                         const SizedBox(height: 4),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 3),
//                           decoration: BoxDecoration(
//                             color: AppTheme.successDim,
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           child: const Text('Active Client',
//                               style: TextStyle(
//                                   color: AppTheme.success,
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.w600)),
//                         ),
//                         IconButton(
//                             onPressed: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) =>
//                                         EditProfileScreen(client: client),
//                                   ));
//                             },
//                             icon: Icon(Icons.edit))
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             _SectionCard(
//               title: 'Account Information',
//               children: [
//                 _InfoRow(
//                     icon: Icons.email_outlined,
//                     label: 'Email',
//                     value: client.email),
//                 if (client.phone != null)
//                   _InfoRow(
//                       icon: Icons.phone_outlined,
//                       label: 'Phone',
//                       value: client.phone!),
//                 _InfoRow(
//                     icon: Icons.business_outlined,
//                     label: 'Company',
//                     value: client.company),
//                 _InfoRow(
//                   icon: Icons.calendar_today_outlined,
//                   label: 'Member Since',
//                   value: DateFormat('MMMM yyyy').format(client.memberSince),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 14),
//             _SectionCard(
//               title: 'Account Summary',
//               children: [
//                 _InfoRow(
//                     icon: Icons.folder_outlined,
//                     label: 'Projects',
//                     value:
//                         '${client.projects.length} project${client.projects.length != 1 ? 's' : ''}'),
//                 _InfoRow(
//                     icon: Icons.key_outlined,
//                     label: 'Credentials',
//                     value:
//                         '${client.projects.fold<int>(0, (s, p) => s + p.totalCredentials)} total'),
//                 _InfoRow(
//                     icon: Icons.warning_amber_rounded,
//                     label: 'Active Alerts',
//                     value: '${client.totalAlerts}',
//                     valueColor: client.totalAlerts > 0
//                         ? AppTheme.warning
//                         : AppTheme.success),
//               ],
//             ),
//             const SizedBox(height: 14),
//             if (client.supportEmail != null) ...[
//               _SectionCard(
//                 title: 'Support',
//                 children: [
//                   _InfoRow(
//                       icon: Icons.support_agent_outlined,
//                       label: 'Contact Admin',
//                       value: client.supportEmail!),
//                   const Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 4),
//                     child: Text(
//                       'For any credential updates, access issues, or renewals, contact your admin.',
//                       style: const TextStyle(
//                           color: AppTheme.textMuted, fontSize: 12, height: 1.4),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 14),
//             ],
//             const _SectionCard(
//               title: 'App Info',
//               children: [
//                 _InfoRow(
//                     icon: Icons.shield_outlined,
//                     label: 'App Name',
//                     value: 'ClientVault'),
//                 _InfoRow(
//                     icon: Icons.info_outline, label: 'Version', value: '1.0.0'),
//                 _InfoRow(
//                     icon: Icons.lock_outline,
//                     label: 'Auth Type',
//                     value: 'Admin-assigned credentials'),
//               ],
//             ),
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: OutlinedButton.icon(
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (_) => AlertDialog(
//                       backgroundColor: AppTheme.surfaceElevated,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16)),
//                       title: const Text('Sign Out',
//                           style: TextStyle(color: AppTheme.textPrimary)),
//                       content: const Text('Are you sure you want to sign out?',
//                           style: TextStyle(color: AppTheme.textSecondary)),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: const Text('Cancel',
//                               style: TextStyle(color: AppTheme.textSecondary)),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                             auth.logout();
//                           },
//                           child: const Text('Sign Out',
//                               style: TextStyle(color: AppTheme.danger)),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//                 icon:
//                     const Icon(Icons.logout, color: AppTheme.danger, size: 18),
//                 label: const Text('Sign Out',
//                     style: TextStyle(color: AppTheme.danger)),
//                 style: OutlinedButton.styleFrom(
//                   side: BorderSide(color: AppTheme.danger.withOpacity(0.4)),
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 32),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _SectionCard extends StatelessWidget {
//   final String title;
//   final List<Widget> children;
//   const _SectionCard({required this.title, required this.children});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppTheme.surfaceElevated,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppTheme.surfaceBorder),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
//             child: Text(
//               title,
//               style: const TextStyle(
//                   color: AppTheme.textSecondary,
//                   fontSize: 11,
//                   fontWeight: FontWeight.w700,
//                   letterSpacing: 0.5),
//             ),
//           ),
//           const Divider(height: 1, color: AppTheme.surfaceBorder),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(children: children),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _InfoRow extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;
//   final Color? valueColor;
//   const _InfoRow(
//       {required this.icon,
//       required this.label,
//       required this.value,
//       this.valueColor});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         children: [
//           Icon(icon, size: 16, color: AppTheme.textMuted),
//           const SizedBox(width: 10),
//           Text(label,
//               style:
//                   const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
//           const Spacer(),
//           Flexible(
//             child: Text(
//               value,
//               textAlign: TextAlign.right,
//               style: TextStyle(
//                   color: valueColor ?? AppTheme.textPrimary,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

import 'package:client_support_app/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../utils/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  final Client client;
  const ProfileScreen({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthState>();

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
        backgroundColor: const Color(0xFFF7F9FC),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: const Color(0xFFF7F9FC),
          title: const Text(
            'Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://hips.hearstapps.com/hmg-prod/images/henry-cavill-superman-1536761926.jpg?crop=0.49925925925925924xw:1xh;center,top&resize=640:*',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            client.name,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            client.company,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Active Client',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfileScreen(client: client),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              _SectionCard(
                title: 'Account Information',
                children: [
                  _InfoRow(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: client.email,
                  ),
                  if (client.phone != null)
                    _InfoRow(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: client.phone!,
                    ),
                  _InfoRow(
                    icon: Icons.business_outlined,
                    label: 'Company',
                    value: client.company,
                  ),
                  _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Member Since',
                    value: DateFormat('MMMM yyyy').format(client.memberSince),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Account Summary',
                children: [
                  _InfoRow(
                    icon: Icons.folder_outlined,
                    label: 'Projects',
                    value:
                        '${client.projects.length} project${client.projects.length != 1 ? 's' : ''}',
                  ),
                  _InfoRow(
                    icon: Icons.key_outlined,
                    label: 'Credentials',
                    value:
                        '${client.projects.fold<int>(0, (s, p) => s + p.totalCredentials)} total',
                  ),
                  _InfoRow(
                    icon: Icons.warning_amber_rounded,
                    label: 'Active Alerts',
                    value: '${client.totalAlerts}',
                    valueColor:
                        client.totalAlerts > 0 ? Colors.orange : Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (client.supportEmail != null) ...[
                _SectionCard(
                  title: 'Support',
                  children: [
                    _InfoRow(
                      icon: Icons.support_agent_outlined,
                      label: 'Contact Admin',
                      value: client.supportEmail!,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'For any credential updates, access issues, or renewals, contact your admin.',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              const _SectionCard(
                title: 'App Info',
                children: [
                  _InfoRow(
                    icon: Icons.shield_outlined,
                    label: 'App Name',
                    value: 'ClientVault',
                  ),
                  _InfoRow(
                    icon: Icons.info_outline,
                    label: 'Version',
                    value: '1.0.0',
                  ),
                  // _InfoRow(
                  //   icon: Icons.lock_outline,
                  //   label: 'Auth Type',
                  //   value: 'Admin-assigned credentials',
                  // ),
                ],
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        title: const Text(
                          'Sign Out',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        content: const Text(
                          'Are you sure you want to sign out?',
                          style: TextStyle(color: Colors.black54),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              auth.logout();
                            },
                            child: const Text(
                              'Sign Out',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    'Sign Out',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          Column(children: children),
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

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 18,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: valueColor ?? Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
