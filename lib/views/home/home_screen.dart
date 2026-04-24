import 'package:flutter/material.dart';

// ─── Data Models ────────────────────────────────────────────────────────────

class ProjectModel {
  final String id;
  final String name;
  final String clientName;
  final String clientAvatar; 
  final double totalAmount;
  final double paidAmount;
  final String status; 
  final String category;
  final int progressPercent;
  final Color accentColor;
  final String dueDate;

  const ProjectModel({
    required this.id,
    required this.name,
    required this.clientName,
    required this.clientAvatar,
    required this.totalAmount,
    required this.paidAmount,
    required this.status,
    required this.category,
    required this.progressPercent,
    required this.accentColor,
    required this.dueDate,
  });

  double get pendingAmount => totalAmount - paidAmount;
  double get paidPercent => (paidAmount / totalAmount).clamp(0, 1);
}


final _mockProjects = [
  ProjectModel(
    id: '001',
    name: 'Vegiffy App',
    clientName: 'Rahul Jain',
    clientAvatar: 'AM',
    totalAmount: 180000,
    paidAmount: 135000,
    status: 'active',
    category: 'Mobile App',
    progressPercent: 72,
    accentColor: const Color(0xFF3D8EFF),
    dueDate: 'Jun 15, 2025',
  ),
  ProjectModel(
    id: '002',
    name: 'EditEzy',
    clientName: 'Jainam Singhvi',
    clientAvatar: 'PS',
    totalAmount: 250000,
    paidAmount: 250000,
    status: 'completed',
    category: 'Web App',
    progressPercent: 100,
    accentColor: const Color(0xFF00D4AA),
    dueDate: 'Apr 01, 2025',
  ),
  ProjectModel(
    id: '003',
    name: 'ClyNix',
    clientName: 'Ashok',
    clientAvatar: 'RN',
    totalAmount: 320000,
    paidAmount: 80000,
    status: 'pending',
    category: 'Web Portal',
    progressPercent: 24,
    accentColor: const Color(0xFFFF7C3D),
    dueDate: 'Aug 30, 2025',
  ),
  ProjectModel(
    id: '004',
    name: 'Redemly',
    clientName: 'Shiva',
    clientAvatar: 'SK',
    totalAmount: 150000,
    paidAmount: 112500,
    status: 'active',
    category: 'Dashboard',
    progressPercent: 58,
    accentColor: const Color(0xFFA855F7),
    dueDate: 'Jul 20, 2025',
  ),
];

// ─── Summary Stats ───────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F2E),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.45),
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Project Card ────────────────────────────────────────────────────────────

class _ProjectCard extends StatelessWidget {
  final ProjectModel project;

  const _ProjectCard({required this.project});

  Color get _statusColor {
    switch (project.status) {
      case 'completed':
        return const Color(0xFF00D4AA);
      case 'pending':
        return const Color(0xFFFF7C3D);
      default:
        return const Color(0xFF3D8EFF);
    }
  }

  String get _statusLabel {
    switch (project.status) {
      case 'completed':
        return 'Completed';
      case 'pending':
        return 'Pending';
      default:
        return 'Active';
    }
  }

  String _formatAmount(double amount) {
    if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(0)}K';
    }
    return '₹${amount.toInt()}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: project.accentColor.withOpacity(0.06),
            blurRadius: 20,
            spreadRadius: -2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ──
          Row(
            children: [
              // Client avatar
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      project.accentColor.withOpacity(0.8),
                      project.accentColor.withOpacity(0.4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
                alignment: Alignment.center,
                child: Text(
                  project.clientAvatar,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
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
                        color: Colors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      project.clientName,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              // Status chip
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: _statusColor.withOpacity(0.3), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: _statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _statusLabel,
                      style: TextStyle(
                        color: _statusColor,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Category + Due date ──
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  project.category,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.55),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              Icon(Icons.calendar_today_outlined,
                  size: 11, color: Colors.white.withOpacity(0.35)),
              const SizedBox(width: 4),
              Text(
                project.dueDate,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 10.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Progress bar ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Project Progress',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.45),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${project.progressPercent}%',
                style: TextStyle(
                  color: project.accentColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: project.progressPercent / 100,
              minHeight: 5,
              backgroundColor: Colors.white.withOpacity(0.07),
              valueColor: AlwaysStoppedAnimation<Color>(project.accentColor),
            ),
          ),

          const SizedBox(height: 16),

          // ── Payment info ──
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                // Paid
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Paid',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 10.5,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _formatAmount(project.paidAmount),
                        style: const TextStyle(
                          color: Color(0xFF00D4AA),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                // Divider
                Container(
                    height: 32,
                    width: 1,
                    color: Colors.white.withOpacity(0.07)),
                // Pending
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pending',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 10.5,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _formatAmount(project.pendingAmount),
                          style: const TextStyle(
                            color: Color(0xFFFF7C3D),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Divider
                Container(
                    height: 32,
                    width: 1,
                    color: Colors.white.withOpacity(0.07)),
                // Total
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 10.5,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _formatAmount(project.totalAmount),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Payment fill bar ──
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: project.paidPercent,
              minHeight: 3,
              backgroundColor: const Color(0xFFFF7C3D).withOpacity(0.2),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF00D4AA)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── HomeScreen ──────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedFilter = 'All';
  final _filters = ['All', 'Active', 'Pending', 'Completed'];

  List<ProjectModel> get _filtered {
    if (_selectedFilter == 'All') return _mockProjects;
    return _mockProjects
        .where((p) =>
            p.status.toLowerCase() == _selectedFilter.toLowerCase())
        .toList();
  }

  double get _totalRevenue =>
      _mockProjects.fold(0, (s, p) => s + p.totalAmount);
  double get _totalCollected =>
      _mockProjects.fold(0, (s, p) => s + p.paidAmount);
  int get _activeCount =>
      _mockProjects.where((p) => p.status == 'active').length;
  int get _completedCount =>
      _mockProjects.where((p) => p.status == 'completed').length;

  String _formatCrore(double val) {
    if (val >= 10000000) return '₹${(val / 10000000).toStringAsFixed(2)}Cr';
    if (val >= 100000) return '₹${(val / 100000).toStringAsFixed(1)}L';
    return '₹${(val / 1000).toStringAsFixed(0)}K';
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1420),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Sliver App Bar ──
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, topPad + 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good Morning 👋',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.45),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Your Dashboard',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Notification bell
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1F2E),
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.07)),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(Icons.notifications_outlined,
                                color: Colors.white.withOpacity(0.7),
                                size: 20),
                            Positioned(
                              right: 9,
                              top: 9,
                              child: Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3D8EFF),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: const Color(0xFF0F1420),
                                      width: 1.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // ── Revenue Hero Card ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E3A5F), Color(0xFF152845)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                          color: const Color(0xFF3D8EFF).withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3D8EFF).withOpacity(0.15),
                          blurRadius: 30,
                          spreadRadius: -4,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Total Revenue',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3D8EFF).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'FY 2025',
                                style: TextStyle(
                                  color: Color(0xFF3D8EFF),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatCrore(_totalRevenue),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Collected vs pending visual
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            children: [
                              Container(
                                height: 7,
                                color: Colors.white.withOpacity(0.08),
                              ),
                              FractionallySizedBox(
                                widthFactor: _totalCollected / _totalRevenue,
                                child: Container(
                                  height: 7,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF3D8EFF),
                                        Color(0xFF00D4AA),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _dot(const Color(0xFF3D8EFF)),
                            const SizedBox(width: 5),
                            Text(
                              'Collected ${_formatCrore(_totalCollected)}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 11.5,
                              ),
                            ),
                            const SizedBox(width: 16),
                            _dot(Colors.white.withOpacity(0.2)),
                            const SizedBox(width: 5),
                            Text(
                              'Pending ${_formatCrore(_totalRevenue - _totalCollected)}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 11.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Stat Cards Row ──
                  Row(
                    children: [
                      _StatCard(
                        label: 'Projects',
                        value: '${_mockProjects.length}',
                        icon: Icons.folder_open_rounded,
                        color: const Color(0xFF3D8EFF),
                      ),
                      const SizedBox(width: 10),
                      _StatCard(
                        label: 'Active',
                        value: '$_activeCount',
                        icon: Icons.bolt_rounded,
                        color: const Color(0xFFA855F7),
                      ),
                      const SizedBox(width: 10),
                      _StatCard(
                        label: 'Done',
                        value: '$_completedCount',
                        icon: Icons.check_circle_outline_rounded,
                        color: const Color(0xFF00D4AA),
                      ),
                    ],
                  ),

                  const SizedBox(height: 26),

                  // ── Section Header ──
                  Row(
                    children: [
                      const Text(
                        'Projects',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'See all',
                        style: TextStyle(
                          color: const Color(0xFF3D8EFF).withOpacity(0.85),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ── Filter Chips ──
                  SizedBox(
                    height: 34,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final f = _filters[i];
                        final sel = f == _selectedFilter;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedFilter = f),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: sel
                                  ? const Color(0xFF3D8EFF)
                                  : const Color(0xFF1A1F2E),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: sel
                                    ? const Color(0xFF3D8EFF)
                                    : Colors.white.withOpacity(0.08),
                              ),
                            ),
                            child: Text(
                              f,
                              style: TextStyle(
                                color: sel
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                                fontSize: 12,
                                fontWeight: sel
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // ── Project List ──
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _ProjectCard(project: _filtered[i]),
                childCount: _filtered.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) => Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}