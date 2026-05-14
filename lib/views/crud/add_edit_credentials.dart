import 'package:client_support_app/models/models.dart';
import 'package:client_support_app/theme/app_theme.dart';
import 'package:client_support_app/utils/auth_state.dart';
import 'package:client_support_app/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEditCredentialScreen extends StatefulWidget {
  final Project project;
  final Credential? credential;
  const AddEditCredentialScreen({
    super.key,
    required this.project,
    this.credential,
  });

  @override
  State<AddEditCredentialScreen> createState() =>
      _AddEditCredentialScreenState();
}

class _AddEditCredentialScreenState extends State<AddEditCredentialScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _labelCtrl;
  late final TextEditingController _notesCtrl;

  late CredentialType _selectedType;
  DateTime? _expiryDate;
  DateTime? _secondaryExpiryDate;
  late final TextEditingController _secondaryLabelCtrl;

  final List<_KVEntry> _fields = [];

  bool get _isEditing => widget.credential != null;
  bool _isSaving = false;

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;


  static const Map<CredentialType, List<String>> _fieldTemplates = {
    CredentialType.appStore: ['Apple ID', 'App Name', 'Bundle ID', 'Team ID'],
    CredentialType.playStore: [
      'Google Account',
      'Package Name',
      'Developer Account'
    ],
    CredentialType.twilio: ['Account SID', 'Auth Token', 'Phone Number'],
    CredentialType.hosting: ['Provider', 'Username', 'Password', 'Server IP'],
    CredentialType.domain: ['Registrar', 'Username', 'Password', 'Nameservers'],
    CredentialType.apiKey: ['Service', 'API Key', 'API Secret', 'Endpoint'],
    CredentialType.database: [
      'Host',
      'Port',
      'Database',
      'Username',
      'Password'
    ],
    CredentialType.email: ['Provider', 'Email', 'Password', 'SMTP Host'],
    CredentialType.aws: [
      'Access Key ID',
      'Secret Access Key',
      'Region',
      'Account ID'
    ],
    CredentialType.mongodb: [
      'Connection String',
      'Username',
      'Password',
      'Cluster'
    ],
    CredentialType.payment: [
      'Provider',
      'Public Key',
      'Secret Key',
      'Webhook Secret'
    ],
    CredentialType.firebase: [
      'Project ID',
      'API Key',
      'Auth Domain',
      'Storage Bucket'
    ],
    CredentialType.other: ['Key', 'Value'],
  };

  @override
  void initState() {
    super.initState();
    final c = widget.credential;
    _labelCtrl = TextEditingController(text: c?.label ?? '');
    _notesCtrl = TextEditingController(text: c?.notes ?? '');
    _secondaryLabelCtrl =
        TextEditingController(text: c?.secondaryExpiryLabel ?? '');
    _selectedType = c?.type ?? CredentialType.apiKey;
    _expiryDate = c?.expiryDate;
    _secondaryExpiryDate = c?.secondaryExpiryDate;

    if (c != null) {
      c.fields.forEach((k, v) => _fields.add(_KVEntry(key: k, value: v)));
    } else {
      _applyTemplate(_selectedType);
    }

    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    _notesCtrl.dispose();
    _secondaryLabelCtrl.dispose();
    for (final e in _fields) {
      e.keyCtrl.dispose();
      e.valueCtrl.dispose();
    }
    _animCtrl.dispose();
    super.dispose();
  }

  void _applyTemplate(CredentialType type) {
    for (final e in _fields) {
      e.keyCtrl.dispose();
      e.valueCtrl.dispose();
    }
    _fields.clear();
    final keys = _fieldTemplates[type] ?? ['Key', 'Value'];
    for (final k in keys) {
      _fields.add(_KVEntry(key: k));
    }
  }

  void _onTypeChanged(CredentialType type) {
    setState(() {
      _selectedType = type;
      _applyTemplate(type);
    });
  }

  void _addField() {
    setState(() => _fields.add(_KVEntry()));
  }

  void _removeField(int index) {
    setState(() {
      _fields[index].keyCtrl.dispose();
      _fields[index].valueCtrl.dispose();
      _fields.removeAt(index);
    });
  }


  Future<void> _pickDate({required bool isPrimary}) async {
    final initial = isPrimary
        ? (_expiryDate ?? DateTime.now().add(const Duration(days: 365)))
        : (_secondaryExpiryDate ??
            DateTime.now().add(const Duration(days: 365)));

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppTheme.primary,
            onPrimary: AppTheme.background,
            surface: AppTheme.surfaceElevated,
            onSurface: AppTheme.textPrimary,
          ),
          dialogBackgroundColor: AppTheme.surface,
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        if (isPrimary) {
          _expiryDate = picked;
        } else {
          _secondaryExpiryDate = picked;
        }
      });
    }
  }

  // ── Save ──────────────────────────────────────────────────────────────────

  // Future<void> _save() async {
  //   if (!_formKey.currentState!.validate()) return;
  //   setState(() => _isSaving = true);
  //   await Future.delayed(const Duration(milliseconds: 600));

  //   final fieldsMap = <String, String>{};
  //   for (final e in _fields) {
  //     final k = e.keyCtrl.text.trim();
  //     final v = e.valueCtrl.text.trim();
  //     if (k.isNotEmpty) fieldsMap[k] = v;
  //   }

  //   final newCredential = Credential(
  //     id: _isEditing
  //         ? widget.credential!.id
  //         : DateTime.now().millisecondsSinceEpoch.toString(),
  //     label: _labelCtrl.text.trim(),
  //     type: _selectedType,
  //     fields: fieldsMap,
  //     expiryDate: _expiryDate,
  //     secondaryExpiryDate: _secondaryExpiryDate,
  //     secondaryExpiryLabel: _secondaryLabelCtrl.text.trim().isNotEmpty
  //         ? _secondaryLabelCtrl.text.trim()
  //         : null,
  //     notes: _notesCtrl.text.trim().isNotEmpty
  //         ? _notesCtrl.text.trim()
  //         : null,
  //   );

  //   if (mounted) {
  //     // TODO: context.read<AuthState>().saveCredential(widget.project.id, newCredential);
  //     setState(() => _isSaving = false);
  //     Navigator.pop(context, newCredential);
  //   }
  // }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 600));

    final fieldsMap = <String, String>{};
    for (final e in _fields) {
      final k = e.keyCtrl.text.trim();
      final v = e.valueCtrl.text.trim();
      if (k.isNotEmpty) fieldsMap[k] = v;
    }

    final newCredential = Credential(
      id: _isEditing
          ? widget.credential!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      label: _labelCtrl.text.trim(),
      type: _selectedType,
      fields: fieldsMap,
      expiryDate: _expiryDate,
      secondaryExpiryDate: _secondaryExpiryDate,
      secondaryExpiryLabel: _secondaryLabelCtrl.text.trim().isNotEmpty
          ? _secondaryLabelCtrl.text.trim()
          : null,
      notes: _notesCtrl.text.trim().isNotEmpty ? _notesCtrl.text.trim() : null,
    );

    if (mounted) {
      final auth = context.read<AuthState>();
      if (_isEditing) {
        auth.updateCredential(widget.project.id, newCredential); 
      } else {
        auth.addCredential(widget.project.id, newCredential); 
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
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                    children: [
                      _buildProjectContext(),
                      const SizedBox(height: 24),
                      _buildSectionLabel('Credential Type'),
                      const SizedBox(height: 12),
                      _buildTypePicker(),
                      const SizedBox(height: 24),
                      _buildSectionLabel('Label'),
                      const SizedBox(height: 12),
                      _buildLabelField(),
                      const SizedBox(height: 24),
                      _buildSectionLabel('Fields'),
                      const SizedBox(height: 12),
                      _buildFieldsList(),
                      const SizedBox(height: 10),
                      _buildAddFieldButton(),
                      const SizedBox(height: 24),
                      _buildSectionLabel('Expiry Dates'),
                      const SizedBox(height: 12),
                      _buildExpiryRow(),
                      const SizedBox(height: 24),
                      _buildSectionLabel('Notes (optional)'),
                      const SizedBox(height: 12),
                      _buildNotesField(),
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
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              _isEditing ? 'Edit Credential' : 'Add Credential',
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (_isEditing)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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


  Widget _buildProjectContext() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: widget.project.accentColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: widget.project.accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              widget.project.type == ProjectType.mobileApp
                  ? Icons.phone_android
                  : widget.project.type == ProjectType.webApp
                      ? Icons.web
                      : Icons.devices,
              color: widget.project.accentColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Adding to project',
                    style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(widget.project.name,
                    style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.surfaceBorder,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${widget.project.totalCredentials} creds',
              style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSectionLabel(String text) => Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: AppTheme.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.9,
        ),
      );


  Widget _buildTypePicker() {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: CredentialType.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final type = CredentialType.values[i];
          final selected = _selectedType == type;
          return GestureDetector(
            onTap: () => _onTypeChanged(type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 78,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.primary.withOpacity(0.12)
                    : AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected
                      ? AppTheme.primary.withOpacity(0.6)
                      : AppTheme.surfaceBorder,
                  width: selected ? 1.5 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CredentialTypeIcon(type: type, size: 22),
                  const SizedBox(height: 6),
                  Text(
                    _typeLabel(type),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color:
                          selected ? AppTheme.primary : AppTheme.textSecondary,
                      fontSize: 10,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _typeLabel(CredentialType t) => switch (t) {
        CredentialType.appStore => 'App Store',
        CredentialType.playStore => 'Play Store',
        CredentialType.twilio => 'Twilio',
        CredentialType.hosting => 'Hosting',
        CredentialType.domain => 'Domain',
        CredentialType.apiKey => 'API Key',
        CredentialType.database => 'Database',
        CredentialType.email => 'Email',
        CredentialType.aws => 'AWS',
        CredentialType.mongodb => 'MongoDB',
        CredentialType.payment => 'Payment',
        CredentialType.firebase => 'Firebase',
        CredentialType.other => 'Other',
      };


  Widget _buildLabelField() {
    return TextFormField(
      controller: _labelCtrl,
      style: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500),
      decoration: _inputDecoration(
        label: 'Credential Label',
        hint: 'e.g. Production Firebase, Stripe Live…',
        icon: Icons.label_outline_rounded,
      ),
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'Label is required' : null,
    );
  }


  Widget _buildFieldsList() {
    return Column(
      children: List.generate(_fields.length, (i) {
        final entry = _fields[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _KVFieldRow(
            entry: entry,
            onRemove: _fields.length > 1 ? () => _removeField(i) : null,
          ),
        );
      }),
    );
  }

  Widget _buildAddFieldButton() {
    return GestureDetector(
      onTap: _addField,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: AppTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: AppTheme.primary.withOpacity(0.3),
              style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded,
                color: AppTheme.primary.withOpacity(0.8), size: 18),
            const SizedBox(width: 6),
            Text(
              'Add Field',
              style: TextStyle(
                  color: AppTheme.primary.withOpacity(0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildExpiryRow() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _DatePickerTile(
                label: 'Primary Expiry',
                date: _expiryDate,
                onTap: () => _pickDate(isPrimary: true),
                onClear: _expiryDate != null
                    ? () => setState(() => _expiryDate = null)
                    : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _DatePickerTile(
                label: 'Secondary Expiry',
                date: _secondaryExpiryDate,
                onTap: () => _pickDate(isPrimary: false),
                onClear: _secondaryExpiryDate != null
                    ? () => setState(() => _secondaryExpiryDate = null)
                    : null,
              ),
            ),
          ],
        ),
        if (_secondaryExpiryDate != null) ...[
          const SizedBox(height: 10),
          TextFormField(
            controller: _secondaryLabelCtrl,
            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
            decoration: _inputDecoration(
              label: 'Secondary Label',
              hint: 'e.g. SSL Certificate',
              icon: Icons.label_outline,
            ),
          ),
        ],
      ],
    );
  }


  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesCtrl,
      maxLines: 3,
      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
      decoration: _inputDecoration(
        label: 'Notes',
        hint: 'Any additional information…',
        icon: Icons.notes_rounded,
      ),
    );
  }


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
                : [AppTheme.primary, const Color(0xFF0065FF)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isSaving
              ? []
              : [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
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
                      _isEditing ? 'Save Changes' : 'Add Credential',
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
        borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppTheme.danger, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppTheme.danger, width: 1.5),
      ),
      errorStyle: const TextStyle(color: AppTheme.danger, fontSize: 11),
    );
  }
}


class _KVEntry {
  final TextEditingController keyCtrl;
  final TextEditingController valueCtrl;

  _KVEntry({String key = '', String value = ''})
      : keyCtrl = TextEditingController(text: key),
        valueCtrl = TextEditingController(text: value);
}


class _KVFieldRow extends StatefulWidget {
  final _KVEntry entry;
  final VoidCallback? onRemove;
  const _KVFieldRow({required this.entry, this.onRemove});

  @override
  State<_KVFieldRow> createState() => _KVFieldRowState();
}

class _KVFieldRowState extends State<_KVFieldRow> {
  bool _obscure = true;

  bool get _looksSecret {
    final k = widget.entry.keyCtrl.text.toLowerCase();
    return k.contains('key') ||
        k.contains('secret') ||
        k.contains('password') ||
        k.contains('token') ||
        k.contains('sid');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        children: [
          TextFormField(
            controller: widget.entry.keyCtrl,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: 'Field name',
              hintStyle:
                  const TextStyle(color: AppTheme.textMuted, fontSize: 12),
              prefixIcon: const Icon(Icons.label_outline,
                  size: 16, color: AppTheme.textMuted),
              suffixIcon: widget.onRemove != null
                  ? GestureDetector(
                      onTap: widget.onRemove,
                      child: const Icon(Icons.remove_circle_outline,
                          size: 16, color: AppTheme.danger),
                    )
                  : null,
              filled: false,
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.surfaceBorder),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.surfaceBorder),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.primary, width: 1.5),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          TextFormField(
            controller: widget.entry.valueCtrl,
            obscureText: _looksSecret && _obscure,
            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Value',
              hintStyle:
                  const TextStyle(color: AppTheme.textMuted, fontSize: 13),
              prefixIcon: const Icon(Icons.edit_outlined,
                  size: 16, color: AppTheme.textMuted),
              suffixIcon: _looksSecret
                  ? GestureDetector(
                      onTap: () => setState(() => _obscure = !_obscure),
                      child: Icon(
                        _obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 16,
                        color: AppTheme.textMuted,
                      ),
                    )
                  : null,
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}


class _DatePickerTile extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  const _DatePickerTile({
    required this.label,
    required this.date,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasDate = date != null;
    final daysLeft = date?.difference(DateTime.now()).inDays;
    final isExpired = daysLeft != null && daysLeft < 0;
    final isCritical = daysLeft != null && daysLeft >= 0 && daysLeft <= 7;

    final statusColor = isExpired
        ? AppTheme.danger
        : isCritical
            ? AppTheme.warning
            : hasDate
                ? AppTheme.success
                : AppTheme.textMuted;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
                hasDate ? statusColor.withOpacity(0.4) : AppTheme.surfaceBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  hasDate
                      ? Icons.event_available_rounded
                      : Icons.event_outlined,
                  size: 14,
                  color: statusColor,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                if (onClear != null)
                  GestureDetector(
                    onTap: onClear,
                    child: const Icon(Icons.close,
                        size: 12, color: AppTheme.textMuted),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              hasDate
                  ? '${date!.day}/${date!.month}/${date!.year}'
                  : 'Tap to set',
              style: TextStyle(
                color: hasDate ? AppTheme.textPrimary : AppTheme.textMuted,
                fontSize: 13,
                fontWeight: hasDate ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (hasDate) ...[
              const SizedBox(height: 4),
              Text(
                isExpired
                    ? '${daysLeft.abs()} days ago'
                    : '$daysLeft days left',
                style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
