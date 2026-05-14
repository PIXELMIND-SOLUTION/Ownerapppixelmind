import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import 'project_detail_screen.dart';


class SearchScreen extends StatefulWidget {
  final List<Project> allProjects;
  const SearchScreen({super.key, required this.allProjects});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  String _query = '';
  _FilterChip _activeFilter = _FilterChip.all;

  final List<String> _recentSearches = [
    'SSL Certificate',
    'Firebase',
    'API Keys',
    'Payment Gateway',
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();

    // Auto-focus
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _animController.dispose();
    super.dispose();
  }


  List<_SearchResult> get _results {
    if (_query.isEmpty) return [];
    final q = _query.toLowerCase();

    final results = <_SearchResult>[];

    for (final project in widget.allProjects) {
      // Match project
      if (_activeFilter == _FilterChip.all ||
          _activeFilter == _FilterChip.projects) {
        if (project.name.toLowerCase().contains(q) ||
            project.description.toLowerCase().contains(q)) {
          results.add(_SearchResult.fromProject(project));
        }
      }

      if (_activeFilter == _FilterChip.all ||
          _activeFilter == _FilterChip.credentials) {
        for (final cred in project.credentials) {
          if (cred.label.toLowerCase().contains(q) ||
              project.name.toLowerCase().contains(q)) {
            results.add(_SearchResult.fromCredential(cred, project));
          }
        }
      }
    }
    return results;
  }

  void _onRecentTap(String term) {
    _searchController.text = term;
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: term.length),
    );
  }

  void _clearRecent(String term) {
    setState(() => _recentSearches.remove(term));
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(context),
              _buildFilterBar(),
              const SizedBox(height: 4),
              Expanded(
                child: _query.isEmpty
                    ? _buildEmptyState()
                    : results.isEmpty
                        ? _buildNoResults()
                        : _buildResults(results),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _focusNode.hasFocus
                      ? AppTheme.primary.withOpacity(0.6)
                      : AppTheme.surfaceBorder,
                ),
                boxShadow: _focusNode.hasFocus
                    ? [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.12),
                          blurRadius: 12,
                          spreadRadius: 0,
                        )
                      ]
                    : [],
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Search projects, credentials…',
                  hintStyle: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 15,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppTheme.textMuted,
                    size: 20,
                  ),
                  suffixIcon: _query.isNotEmpty
                      ? GestureDetector(
                          onTap: () => _searchController.clear(),
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            decoration:const BoxDecoration(
                              color: AppTheme.surfaceBorder,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: AppTheme.textSecondary,
                              size: 14,
                            ),
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppTheme.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildFilterBar() {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: _FilterChip.values.map((chip) {
          final selected = _activeFilter == chip;
          return GestureDetector(
            onTap: () => setState(() => _activeFilter = chip),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.primary
                    : AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? AppTheme.primary
                      : AppTheme.surfaceBorder,
                ),
              ),
              child: Text(
                chip.label,
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }


  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.primary.withOpacity(0.18),
                        AppTheme.primary.withOpacity(0.04),
                      ],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppTheme.primary.withOpacity(0.25), width: 1.5),
                  ),
                  child: const Icon(Icons.search_rounded,
                      color: AppTheme.primary, size: 32),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Find anything instantly',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Projects, credentials, API keys & more',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          if (_recentSearches.isNotEmpty) ...[
            _sectionLabel('Recent Searches'),
            const SizedBox(height: 12),
            ..._recentSearches.map((term) => _RecentItem(
                  term: term,
                  onTap: () => _onRecentTap(term),
                  onClear: () => _clearRecent(term),
                )),
          ],

          const SizedBox(height: 28),

          _sectionLabel('Quick Filters'),
          const SizedBox(height: 12),
          _QuickFiltersGrid(
            onSelect: (term) => _onRecentTap(term),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
        text,
        style: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      );


  Widget _buildNoResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.surfaceElevated,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.surfaceBorder),
              ),
              child: const Icon(Icons.search_off_rounded,
                  color: AppTheme.textMuted, size: 36),
            ),
            const SizedBox(height: 20),
            Text(
              'No results for "$_query"',
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Try different keywords or\ncheck for typos.',
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 13,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildResults(List<_SearchResult> results) {
    // Group results
    final projects =
        results.where((r) => r.type == _ResultType.project).toList();
    final creds =
        results.where((r) => r.type == _ResultType.credential).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Text(
          '${results.length} result${results.length != 1 ? 's' : ''} found',
          style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),

        if (projects.isNotEmpty) ...[
          _GroupLabel(label: 'Projects', count: projects.length),
          const SizedBox(height: 10),
          ...projects.map(
            (r) => _ProjectResultTile(
              result: r,
              query: _query,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ProjectDetailScreen(project: r.project!),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],

        if (creds.isNotEmpty) ...[
          _GroupLabel(label: 'Credentials', count: creds.length),
          const SizedBox(height: 10),
          ...creds.map((r) => _CredentialResultTile(
                result: r,
                query: _query,
              )),
        ],
      ],
    );
  }
}


enum _FilterChip {
  all('All'),
  projects('Projects'),
  credentials('Credentials');

  final String label;
  const _FilterChip(this.label);
}

enum _ResultType { project, credential }

class _SearchResult {
  final _ResultType type;
  final String title;
  final String subtitle;
  final Project? project;
  final Credential? credential;
  final Color accentColor;
  final IconData icon;
  final ExpiryStatus? status;

  const _SearchResult({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.icon,
    this.project,
    this.credential,
    this.status,
  });

  factory _SearchResult.fromProject(Project p) => _SearchResult(
        type: _ResultType.project,
        title: p.name,
        subtitle: p.description,
        accentColor: p.accentColor,
        icon: p.type == ProjectType.mobileApp
            ? Icons.phone_android
            : p.type == ProjectType.webApp
                ? Icons.web
                : Icons.devices,
        project: p,
      );

  factory _SearchResult.fromCredential(Credential c, Project p) =>
      _SearchResult(
        type: _ResultType.credential,
        title: c.label,
        subtitle: p.name,
        accentColor: c.expiryStatus == ExpiryStatus.expired
            ? AppTheme.danger
            : c.expiryStatus == ExpiryStatus.expiringSoon ||
                    c.expiryStatus == ExpiryStatus.critical
                ? AppTheme.warning
                : AppTheme.success,
        icon: Icons.key_rounded,
        credential: c,
        project: p,
        status: c.expiryStatus,
      );
}


class _RecentItem extends StatelessWidget {
  final String term;
  final VoidCallback onTap;
  final VoidCallback onClear;
  const _RecentItem(
      {required this.term, required this.onTap, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: AppTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.surfaceBorder),
        ),
        child: Row(
          children: [
            const Icon(Icons.history_rounded,
                size: 16, color: AppTheme.textMuted),
            const SizedBox(width: 12),
            Expanded(
              child: Text(term,
                  style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
            ),
            GestureDetector(
              onTap: onClear,
              child: const Icon(Icons.close,
                  size: 14, color: AppTheme.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickFiltersGrid extends StatelessWidget {
  final ValueChanged<String> onSelect;
  static const _chips = [
    ('🔑', 'API Keys'),
    ('🔒', 'SSL'),
    ('🔥', 'Firebase'),
    ('💳', 'Payments'),
    ('☁️', 'Cloud'),
    ('📧', 'Email'),
  ];

  const _QuickFiltersGrid({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _chips
          .map((c) => GestureDetector(
                onTap: () => onSelect(c.$2),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.surfaceBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(c.$1, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(c.$2,
                          style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  final String label;
  final int count;
  const _GroupLabel({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label.toUpperCase(),
            style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text('$count',
              style: const TextStyle(
                  color: AppTheme.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}


class _HighlightText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle baseStyle;
  const _HighlightText(
      {required this.text, required this.query, required this.baseStyle});

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) return Text(text, style: baseStyle);
    final lower = text.toLowerCase();
    final q = query.toLowerCase();
    final idx = lower.indexOf(q);
    if (idx == -1) return Text(text, style: baseStyle);

    return RichText(
      text: TextSpan(style: baseStyle, children: [
        TextSpan(text: text.substring(0, idx)),
        TextSpan(
          text: text.substring(idx, idx + q.length),
          style: baseStyle.copyWith(
            color: AppTheme.primary,
            backgroundColor: AppTheme.primary.withOpacity(0.12),
            fontWeight: FontWeight.w700,
          ),
        ),
        TextSpan(text: text.substring(idx + q.length)),
      ]),
    );
  }
}


class _ProjectResultTile extends StatelessWidget {
  final _SearchResult result;
  final String query;
  final VoidCallback onTap;
  const _ProjectResultTile(
      {required this.result, required this.query, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.surfaceBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: result.accentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: result.accentColor.withOpacity(0.3)),
              ),
              child: Icon(result.icon, color: result.accentColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HighlightText(
                    text: result.title,
                    query: query,
                    baseStyle: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  _HighlightText(
                    text: result.subtitle,
                    query: query,
                    baseStyle: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                    ),
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


class _CredentialResultTile extends StatelessWidget {
  final _SearchResult result;
  final String query;
  const _CredentialResultTile(
      {required this.result, required this.query});

  @override
  Widget build(BuildContext context) {
    final statusColor = result.status == ExpiryStatus.expired
        ? AppTheme.danger
        : result.status == ExpiryStatus.expiringSoon ||
                result.status == ExpiryStatus.critical
            ? AppTheme.warning
            : AppTheme.success;

    final statusLabel = result.status == ExpiryStatus.expired
        ? 'Expired'
        : result.status == ExpiryStatus.critical
            ? 'Critical'
            : result.status == ExpiryStatus.expiringSoon
                ? 'Expiring Soon'
                : 'Active';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Icon(Icons.key_rounded, color: statusColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HighlightText(
                  text: result.title,
                  query: query,
                  baseStyle: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    _HighlightText(
                      text: result.subtitle,
                      query: query,
                      baseStyle: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const Text(' · ',
                        style: TextStyle(
                            color: AppTheme.textMuted, fontSize: 12)),
                    Text(
                      statusLabel,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}