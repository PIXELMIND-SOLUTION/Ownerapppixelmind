// // ignore_for_file: curly_braces_in_flow_control_structures, deprecated_member_use

// import 'package:flutter/material.dart';
// import '../models/models.dart';
// import '../theme/app_theme.dart';

// class EditProfileScreen extends StatefulWidget {
//   final Client client;
//   const EditProfileScreen({super.key, required this.client});

//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   bool _isSaving = false;
//   bool _hasChanges = false;

//   late final TextEditingController _nameController;
//   late final TextEditingController _emailController;
//   late final TextEditingController _phoneController;
//   late final TextEditingController _companyController;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.client.name);
//     _emailController = TextEditingController(text: widget.client.email);
//     _phoneController = TextEditingController(text: widget.client.phone ?? '');
//     _companyController = TextEditingController(text: widget.client.company);

//     for (final c in [
//       _nameController,
//       _emailController,
//       _phoneController,
//       _companyController
//     ]) {
//       c.addListener(_onFieldChanged);
//     }
//   }

//   void _onFieldChanged() {
//     final changed = _nameController.text != widget.client.name ||
//         _emailController.text != widget.client.email ||
//         _phoneController.text != (widget.client.phone ?? '') ||
//         _companyController.text != widget.client.company;
//     if (changed != _hasChanges) setState(() => _hasChanges = changed);
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _companyController.dispose();
//     super.dispose();
//   }

//   Future<void> _save() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _isSaving = true);

//     await Future.delayed(const Duration(milliseconds: 800));

//     if (!mounted) return;
//     setState(() => _isSaving = false);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: AppTheme.surfaceElevated,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         content: const Row(
//           children: const [
//             Icon(Icons.check_circle_outline, color: AppTheme.success, size: 18),
//             SizedBox(width: 10),
//             Text('Profile updated',
//                 style: TextStyle(color: AppTheme.textPrimary, fontSize: 13)),
//           ],
//         ),
//       ),
//     );

//     Navigator.pop(context);
//   }

//   void _discardChanges() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: AppTheme.surfaceElevated,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('Discard Changes',
//             style: TextStyle(color: AppTheme.textPrimary)),
//         content: const Text('You have unsaved changes. Discard them?',
//             style: TextStyle(color: AppTheme.textSecondary)),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Keep Editing',
//                 style: TextStyle(color: AppTheme.textSecondary)),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pop(context);
//             },
//             child:
//                 const Text('Discard', style: TextStyle(color: AppTheme.danger)),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: !_hasChanges,
//       onPopInvoked: (didPop) {
//         if (!didPop && _hasChanges) _discardChanges();
//       },
//       child: Scaffold(
//         backgroundColor: AppTheme.background,
//         appBar: AppBar(
//           centerTitle: true,
//           backgroundColor: AppTheme.background,
//           title: const Text(
//             'Edit Profile',
//             style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 color: AppTheme.textPrimary),
//           ),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
//             onPressed:
//                 _hasChanges ? _discardChanges : () => Navigator.pop(context),
//           ),
//           actions: [
//             if (_hasChanges)
//               Padding(
//                 padding: const EdgeInsets.only(right: 8),
//                 child: TextButton(
//                   onPressed: _isSaving ? null : _save,
//                   child: _isSaving
//                       ? const SizedBox(
//                           width: 16,
//                           height: 16,
//                           child: CircularProgressIndicator(
//                               strokeWidth: 2, color: AppTheme.primary),
//                         )
//                       : const Text('Save',
//                           style: TextStyle(
//                               color: AppTheme.primary,
//                               fontWeight: FontWeight.w700,
//                               fontSize: 14)),
//                 ),
//               ),
//           ],
//         ),
//         body: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _AvatarSection(client: widget.client),
//                 const SizedBox(height: 24),
//                 _EditSectionCard(
//                   title: 'Personal Information',
//                   children: [
//                     _EditField(
//                       controller: _nameController,
//                       label: 'Full Name',
//                       icon: Icons.person_outline,
//                       validator: (v) => (v == null || v.trim().isEmpty)
//                           ? 'Name is required'
//                           : null,
//                       textInputAction: TextInputAction.next,
//                       keyboardType: TextInputType.name,
//                     ),
//                     const SizedBox(height: 14),
//                     _EditField(
//                       controller: _companyController,
//                       label: 'Company',
//                       icon: Icons.business_outlined,
//                       validator: (v) => (v == null || v.trim().isEmpty)
//                           ? 'Company is required'
//                           : null,
//                       textInputAction: TextInputAction.next,
//                       keyboardType: TextInputType.text,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 14),
//                 _EditSectionCard(
//                   title: 'Contact Information',
//                   children: [
//                     _EditField(
//                       controller: _emailController,
//                       label: 'Email Address',
//                       icon: Icons.email_outlined,
//                       validator: (v) {
//                         if (v == null || v.trim().isEmpty)
//                           return 'Email is required';
//                         final emailReg = RegExp(r'^[\w.-]+@[\w.-]+\.\w+$');
//                         if (!emailReg.hasMatch(v.trim()))
//                           return 'Enter a valid email';
//                         return null;
//                       },
//                       textInputAction: TextInputAction.next,
//                       keyboardType: TextInputType.emailAddress,
//                     ),
//                     const SizedBox(height: 14),
//                     _EditField(
//                       controller: _phoneController,
//                       label: 'Phone Number',
//                       hint: 'Optional',
//                       icon: Icons.phone_outlined,
//                       textInputAction: TextInputAction.done,
//                       keyboardType: TextInputType.phone,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 14),
//                 _ReadOnlyNotice(),
//                 const SizedBox(height: 24),
//                 SizedBox(
//                   width: double.infinity,
//                   child: FilledButton(
//                     onPressed: (_hasChanges && !_isSaving) ? _save : null,
//                     style: FilledButton.styleFrom(
//                       backgroundColor: AppTheme.primary,
//                       disabledBackgroundColor: AppTheme.surfaceBorder,
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                     ),
//                     child: _isSaving
//                         ? const SizedBox(
//                             width: 18,
//                             height: 18,
//                             child: CircularProgressIndicator(
//                                 strokeWidth: 2, color: Colors.white),
//                           )
//                         : Text(
//                             _hasChanges ? 'Save Changes' : 'No Changes',
//                             style: TextStyle(
//                               color: _hasChanges
//                                   ? Colors.white
//                                   : AppTheme.textMuted,
//                               fontWeight: FontWeight.w700,
//                               fontSize: 15,
//                             ),
//                           ),
//                   ),
//                 ),
//                 const SizedBox(height: 32),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _AvatarSection extends StatelessWidget {
//   final Client client;
//   const _AvatarSection({required this.client});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: AppTheme.surfaceElevated,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: AppTheme.surfaceBorder),
//       ),
//       child: Row(
//         children: [
//           Stack(
//             children: [
//               Container(
//                 width: 60,
//                 height: 60,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   image: const DecorationImage(
//                     image: NetworkImage(
//                       'https://hips.hearstapps.com/hmg-prod/images/henry-cavill-superman-1536761926.jpg?crop=0.49925925925925924xw:1xh;center,top&resize=640:*',
//                     ),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: 0,
//                 right: 0,
//                 child: Container(
//                   width: 22,
//                   height: 22,
//                   decoration: BoxDecoration(
//                     color: AppTheme.primary,
//                     borderRadius: BorderRadius.circular(6),
//                     border: Border.all(color: AppTheme.background, width: 2),
//                   ),
//                   child: const Icon(Icons.edit, size: 11, color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(client.name,
//                     style: const TextStyle(
//                         color: AppTheme.textPrimary,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700)),
//                 const SizedBox(height: 4),
//                 Text(client.email,
//                     style: const TextStyle(
//                         color: AppTheme.textSecondary, fontSize: 12)),
//                 const SizedBox(height: 8),
//                 GestureDetector(
//                   onTap: () {},
//                   child: Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: AppTheme.primary.withOpacity(0.12),
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                     child: const Text(
//                       'Change Photo',
//                       style: TextStyle(
//                           color: AppTheme.primary,
//                           fontSize: 11,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _EditSectionCard extends StatelessWidget {
//   final String title;
//   final List<Widget> children;
//   const _EditSectionCard({required this.title, required this.children});

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
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: children,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _EditField extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final String? hint;
//   final IconData icon;
//   final String? Function(String?)? validator;
//   final TextInputAction textInputAction;
//   final TextInputType keyboardType;

//   const _EditField({
//     required this.controller,
//     required this.label,
//     required this.icon,
//     required this.textInputAction,
//     required this.keyboardType,
//     this.hint,
//     this.validator,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(icon, size: 14, color: AppTheme.textMuted),
//             const SizedBox(width: 6),
//             Text(label,
//                 style: const TextStyle(
//                     color: AppTheme.textSecondary,
//                     fontSize: 11,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 0.3)),
//           ],
//         ),
//         const SizedBox(height: 6),
//         TextFormField(
//           controller: controller,
//           validator: validator,
//           textInputAction: textInputAction,
//           keyboardType: keyboardType,
//           style: const TextStyle(
//               color: AppTheme.textPrimary,
//               fontSize: 14,
//               fontWeight: FontWeight.w500),
//           decoration: InputDecoration(
//             hintText: hint,
//             hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 14),
//             contentPadding:
//                 const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//             filled: true,
//             fillColor: AppTheme.background,
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: const BorderSide(color: AppTheme.surfaceBorder),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: const BorderSide(color: AppTheme.danger),
//             ),
//             focusedErrorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: const BorderSide(color: AppTheme.danger, width: 1.5),
//             ),
//             errorStyle: const TextStyle(color: AppTheme.danger, fontSize: 11),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _ReadOnlyNotice extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: AppTheme.surfaceElevated,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: AppTheme.surfaceBorder),
//       ),
//       child: const Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: const [
//           Icon(Icons.info_outline, size: 15, color: AppTheme.textMuted),
//           SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               'Some account details like credentials and membership date are managed by your admin and cannot be changed here.',
//               style: TextStyle(
//                   color: AppTheme.textMuted, fontSize: 12, height: 1.5),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

















// ignore_for_file: curly_braces_in_flow_control_structures, deprecated_member_use

import 'package:flutter/material.dart';
import '../models/models.dart';

class EditProfileScreen extends StatefulWidget {
  final Client client;

  const EditProfileScreen({
    super.key,
    required this.client,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isSaving = false;
  bool _hasChanges = false;

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _companyController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.client.name);
    _emailController = TextEditingController(text: widget.client.email);
    _phoneController =
        TextEditingController(text: widget.client.phone ?? '');
    _companyController =
        TextEditingController(text: widget.client.company);

    for (final c in [
      _nameController,
      _emailController,
      _phoneController,
      _companyController,
    ]) {
      c.addListener(_onFieldChanged);
    }
  }

  void _onFieldChanged() {
    final changed = _nameController.text != widget.client.name ||
        _emailController.text != widget.client.email ||
        _phoneController.text != (widget.client.phone ?? '') ||
        _companyController.text != widget.client.company;

    if (changed != _hasChanges) {
      setState(() => _hasChanges = changed);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        content: const Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 20,
            ),
            SizedBox(width: 10),
            Text(
              'Profile updated successfully',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );

    Navigator.pop(context);
  }

  void _discardChanges() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text(
          'Discard Changes',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          'You have unsaved changes. Discard them?',
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Keep Editing',
              style: TextStyle(color: Colors.black54),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'Discard',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasChanges,
      onPopInvoked: (didPop) {
        if (!didPop && _hasChanges) {
          _discardChanges();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: const Color(0xFFF7F9FC),
          title: const Text(
            'Edit Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87,
            ),
            onPressed:
                _hasChanges ? _discardChanges : () => Navigator.pop(context),
          ),
          actions: [
            if (_hasChanges)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: TextButton(
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                ),
              ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _AvatarSection(client: widget.client),

                const SizedBox(height: 22),

                _EditSectionCard(
                  title: 'Personal Information',
                  children: [
                    _EditField(
                      controller: _nameController,
                      label: 'Full Name',
                      icon: Icons.person_outline,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _EditField(
                      controller: _companyController,
                      label: 'Company',
                      icon: Icons.business_outlined,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Company is required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _EditSectionCard(
                  title: 'Contact Information',
                  children: [
                    _EditField(
                      controller: _emailController,
                      label: 'Email Address',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Email is required';
                        }

                        final emailReg =
                            RegExp(r'^[\w.-]+@[\w.-]+\.\w+$');

                        if (!emailReg.hasMatch(v.trim())) {
                          return 'Enter valid email';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _EditField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      icon: Icons.phone_outlined,
                      hint: 'Optional',
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                const _ReadOnlyNotice(),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        (_hasChanges && !_isSaving) ? _save : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      disabledBackgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _hasChanges
                                ? 'Save Changes'
                                : 'No Changes',
                            style: TextStyle(
                              color: _hasChanges
                                  ? Colors.white
                                  : Colors.black45,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AvatarSection extends StatelessWidget {
  final Client client;

  const _AvatarSection({
    required this.client,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
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
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
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
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  client.email,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Change Photo',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditSectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _EditSectionCard({
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
          const SizedBox(height: 18),
          Column(children: children),
        ],
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;

  const _EditField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.textInputAction,
    required this.keyboardType,
    this.hint,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 15,
              color: Colors.black54,
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
            ),
            filled: true,
            fillColor: const Color(0xFFF7F9FC),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReadOnlyNotice extends StatelessWidget {
  const _ReadOnlyNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orange.withOpacity(0.2),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.orange,
            size: 18,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Some account details like credentials and membership date are managed by your admin and cannot be changed here.',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
