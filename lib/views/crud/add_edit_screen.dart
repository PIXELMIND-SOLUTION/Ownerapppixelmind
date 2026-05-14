import 'package:client_support_app/models/models.dart';
import 'package:client_support_app/theme/app_theme.dart';
import 'package:client_support_app/utils/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AddEditProjectScreen extends StatefulWidget {
  final Project? project;
  const AddEditProjectScreen({super.key, this.project});

  @override
  State<AddEditProjectScreen> createState() => _AddEditProjectScreenState();
}

class _AddEditProjectScreenState extends State<AddEditProjectScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;

  late ProjectType _selectedType;
  late Color _selectedColor;

  bool get _isEditing => widget.project != null;
  bool _isSaving = false;

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;


  static const List<Color> _palette = [
    Color(0xFF00D4FF), // cyan (primary)
    Color(0xFFFFB020), // amber (accent)
    Color(0xFF22C55E), // green
    Color(0xFFEF4444), // red
    Color(0xFF818CF8), // indigo
    Color(0xFFF472B6), // pink
    Color(0xFF34D399), // emerald
    Color(0xFFFB923C), // orange
    Color(0xFF60A5FA), // blue
    Color(0xFFA78BFA), // violet
    Color(0xFF2DD4BF), // teal
    Color(0xFFFACC15), // yellow
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.project;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _selectedType = p?.type ?? ProjectType.mobileApp;
    _selectedColor = p?.accentColor ?? _palette.first;

    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim =
        CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  // ── Save ──────────────────────────────────────────────────────────────────

  // Future<void> _save() async {
  //   if (!_formKey.currentState!.validate()) return;
  //   setState(() => _isSaving = true);

  //   await Future.delayed(const Duration(milliseconds: 600)); // simulate async

  //   final newProject = Project(
  //     id: _isEditing
  //         ? widget.project!.id
  //         : DateTime.now().millisecondsSinceEpoch.toString(),
  //     name: _nameCtrl.text.trim(),
  //     type: _selectedType,
  //     description: _descCtrl.text.trim(),
  //     credentials: _isEditing ? widget.project!.credentials : [],
  //     createdAt: _isEditing ? widget.project!.createdAt : DateTime.now(),
  //     accentColor: _selectedColor,
  //   );

  //   if (mounted) {
  //     // TODO: call auth_state / repository to persist the project
  //     // context.read<AuthState>().saveProject(newProject);
  //     setState(() => _isSaving = false);
  //     Navigator.pop(context, newProject);
  //   }
  // }



  Future<void> _save() async {
  if (!_formKey.currentState!.validate()) return;
  setState(() => _isSaving = true);
  await Future.delayed(const Duration(milliseconds: 600));

  final newProject = Project(
    id: _isEditing
        ? widget.project!.id
        : DateTime.now().millisecondsSinceEpoch.toString(),
    name: _nameCtrl.text.trim(),
    type: _selectedType,
    description: _descCtrl.text.trim(),
    credentials: _isEditing ? widget.project!.credentials : [],
    createdAt: _isEditing ? widget.project!.createdAt : DateTime.now(),
    accentColor: _selectedColor,
  );

  if (mounted) {
    final auth = context.read<AuthState>();
    if (_isEditing) {
      auth.updateProject(newProject); 
    } else {
      auth.addProject(newProject);   
    }
    setState(() => _isSaving = false);
    Navigator.pop(context);          
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                    children: [
                      _buildProjectPreviewCard(),
                      const SizedBox(height: 28),
                      _buildSectionLabel('Project Details'),
                      const SizedBox(height: 12),
                      _buildNameField(),
                      const SizedBox(height: 14),
                      _buildDescField(),
                      const SizedBox(height: 28),
                      _buildSectionLabel('Project Type'),
                      const SizedBox(height: 12),
                      _buildTypePicker(),
                      const SizedBox(height: 28),
                      _buildSectionLabel('Accent Color'),
                      const SizedBox(height: 12),
                      _buildColorPicker(),
                      const SizedBox(height: 36),
                      _buildSaveButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.surfaceBorder)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 18, color: AppTheme.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 70),
          Expanded(
            child: Text(
              _isEditing ? 'Edit Project' : 'New Project',
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (_isEditing)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.primaryDim,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
              ),
              child: const Text(
                'Editing',
                style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }


  Widget _buildProjectPreviewCard() {
    final name =
        _nameCtrl.text.trim().isEmpty ? 'Project Name' : _nameCtrl.text.trim();
    final desc = _descCtrl.text.trim().isEmpty
        ? 'Project description will appear here…'
        : _descCtrl.text.trim();

    final icon = _selectedType == ProjectType.mobileApp
        ? Icons.phone_android
        : _selectedType == ProjectType.webApp
            ? Icons.web
            : Icons.devices;

    return AnimatedBuilder(
      animation: Listenable.merge([_nameCtrl, _descCtrl]),
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppTheme.surfaceElevated,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
                color: _selectedColor.withOpacity(0.4), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: _selectedColor.withOpacity(0.08),
                blurRadius: 20,
                spreadRadius: 0,
              )
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _selectedColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  border:
                      Border.all(color: _selectedColor.withOpacity(0.3)),
                ),
                child: Icon(icon, color: _selectedColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: _nameCtrl.text.trim().isEmpty
                            ? AppTheme.textMuted
                            : AppTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _descCtrl.text.trim().isEmpty
                            ? AppTheme.textMuted
                            : AppTheme.textSecondary,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Section Label ─────────────────────────────────────────────────────────

  Widget _buildSectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.9,
          ),
        ),
      );

  // ── Name Field ────────────────────────────────────────────────────────────

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameCtrl,
      onChanged: (_) => setState(() {}),
      style: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500),
      decoration: _inputDecoration(
        label: 'Project Name',
        hint: 'e.g. MyApp, Client Portal…',
        icon: Icons.folder_outlined,
      ),
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'Project name is required' : null,
    );
  }

  // ── Description Field ─────────────────────────────────────────────────────

  Widget _buildDescField() {
    return TextFormField(
      controller: _descCtrl,
      onChanged: (_) => setState(() {}),
      maxLines: 3,
      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
      decoration: _inputDecoration(
        label: 'Description',
        hint: 'Brief description of the project…',
        icon: Icons.notes_rounded,
      ),
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'Description is required' : null,
    );
  }

  // ── Type Picker ───────────────────────────────────────────────────────────

  Widget _buildTypePicker() {
    return Row(
      children: ProjectType.values.map((type) {
        final selected = _selectedType == type;
        final (label, icon) = switch (type) {
          ProjectType.mobileApp => ('Mobile App', Icons.phone_android),
          ProjectType.webApp => ('Web App', Icons.web),
          ProjectType.both => ('Mobile + Web', Icons.devices),
        };
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedType = type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(
                  right: type != ProjectType.both ? 10 : 0),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: selected
                    ? _selectedColor.withOpacity(0.12)
                    : AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected
                      ? _selectedColor.withOpacity(0.5)
                      : AppTheme.surfaceBorder,
                  width: selected ? 1.5 : 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(icon,
                      color:
                          selected ? _selectedColor : AppTheme.textMuted,
                      size: 22),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: selected
                          ? _selectedColor
                          : AppTheme.textSecondary,
                      fontSize: 11,
                      fontWeight: selected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Color Picker ──────────────────────────────────────────────────────────

  Widget _buildColorPicker() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _palette.map((color) {
        final selected = _selectedColor == color;
        return GestureDetector(
          onTap: () => setState(() => _selectedColor = color),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? color : color.withOpacity(0.25),
                width: selected ? 2.5 : 1.5,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                          color: color.withOpacity(0.35),
                          blurRadius: 10,
                          spreadRadius: 0)
                    ]
                  : [],
            ),
            child: selected
                ? Icon(Icons.check_rounded, color: color, size: 18)
                : Center(
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                          color: color, shape: BoxShape.circle),
                    ),
                  ),
          ),
        );
      }).toList(),
    );
  }

  // ── Save Button ───────────────────────────────────────────────────────────

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: _isSaving ? null : _save,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 54,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isSaving
                ? [AppTheme.surfaceBorder, AppTheme.surfaceBorder]
                : [_selectedColor, _selectedColor.withOpacity(0.75)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isSaving
              ? []
              : [
                  BoxShadow(
                    color: _selectedColor.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  )
                ],
        ),
        child: Center(
          child: _isSaving
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppTheme.textPrimary,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isEditing
                          ? Icons.save_rounded
                          : Icons.add_circle_outline_rounded,
                      color: AppTheme.background,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isEditing ? 'Save Changes' : 'Create Project',
                      style: const TextStyle(
                        color: AppTheme.background,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // ── Input Decoration Helper ───────────────────────────────────────────────

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, size: 18, color: AppTheme.textMuted),
      filled: true,
      fillColor: AppTheme.surfaceElevated,
      labelStyle: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
      hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppTheme.surfaceBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppTheme.surfaceBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
            BorderSide(color: _selectedColor.withOpacity(0.7), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
            const BorderSide(color: AppTheme.danger, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
            const BorderSide(color: AppTheme.danger, width: 1.5),
      ),
      errorStyle: const TextStyle(color: AppTheme.danger, fontSize: 11),
    );
  }
}