import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:ownerapp_pixelmind/views/navbar/navbar_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  late AnimationController _particleController;
  late AnimationController _entryController;
  late AnimationController _shimmerController;
  late AnimationController _buttonPulseController;

  late Animation<double> _logoFade;
  late Animation<Offset> _logoSlide;
  late Animation<double> _cardFade;
  late Animation<Offset> _cardSlide;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _buttonPulse;

  @override
  void initState() {
    super.initState();

    // Particles
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // Entry animations
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    _logoSlide =
        Tween<Offset>(begin: const Offset(0, -0.4), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _cardFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.35, 1.0, curve: Curves.easeOut),
      ),
    );
    _cardSlide =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.35, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    // Button pulse
    _buttonPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _buttonPulse = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _buttonPulseController, curve: Curves.easeInOut),
    );

    _entryController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _particleController.dispose();
    _entryController.dispose();
    _shimmerController.dispose();
    _buttonPulseController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
  if (_formKey.currentState!.validate()) {
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isLoading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const NavbarScreen(),
      ),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0E1A),
              Color(0xFF0D1B2E),
              Color(0xFF0A1628),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Particles background
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, _) => CustomPaint(
                painter: _ParticlePainter(_particleController.value),
                size: Size.infinite,
              ),
            ),

            // Top radial glow
            Positioned(
              top: -60,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF1565C0).withOpacity(0.18),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom glow
            Positioned(
              bottom: -80,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF0D47A1).withOpacity(0.12),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Main scrollable content
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      const SizedBox(height: 48),

                      // ── Logo + Title ──
                      SlideTransition(
                        position: _logoSlide,
                        child: FadeTransition(
                          opacity: _logoFade,
                          child: Column(
                            children: [
                              // Logo circle
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF1565C0),
                                      Color(0xFF0D47A1),
                                      Color(0xFF1A237E),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF1565C0)
                                          .withOpacity(0.55),
                                      blurRadius: 32,
                                      spreadRadius: 4,
                                    ),
                                    BoxShadow(
                                      color: const Color(0xFF42A5F5)
                                          .withOpacity(0.25),
                                      blurRadius: 16,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/companylogo.png',
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // App name shimmer
                              AnimatedBuilder(
                                animation: _shimmerController,
                                builder: (context, _) {
                                  return ShaderMask(
                                    shaderCallback: (bounds) {
                                      return LinearGradient(
                                        colors: const [
                                          Color(0xFFE3F2FD),
                                          Color(0xFFFFFFFF),
                                          Color(0xFF90CAF9),
                                          Color(0xFFFFFFFF),
                                          Color(0xFFE3F2FD),
                                        ],
                                        stops: [
                                          0.0,
                                          (_shimmerAnimation.value - 0.3)
                                              .clamp(0.0, 1.0),
                                          _shimmerAnimation.value
                                              .clamp(0.0, 1.0),
                                          (_shimmerAnimation.value + 0.3)
                                              .clamp(0.0, 1.0),
                                          1.0,
                                        ],
                                      ).createShader(bounds);
                                    },
                                    child: const Text(
                                      'OwnerApp',
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 1.5,
                                        fontFamily: 'serif',
                                      ),
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(height: 6),

                              // Divider dots
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _dividerLine(toRight: false),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    width: 4,
                                    height: 4,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF42A5F5),
                                    ),
                                  ),
                                  _dividerLine(toRight: true),
                                ],
                              ),

                              const SizedBox(height: 6),

                              const Text(
                                'Manage · Monitor · Grow',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF90CAF9),
                                  letterSpacing: 2.8,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // ── Login Card ──
                      SlideTransition(
                        position: _cardSlide,
                        child: FadeTransition(
                          opacity: _cardFade,
                          child: _buildLoginCard(),
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF0D1B2E).withOpacity(0.85),
        border: Border.all(
          color: const Color(0xFF1E3A5F).withOpacity(0.8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 40,
            spreadRadius: 2,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(0.08),
            blurRadius: 30,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card header
              Row(
                children: [
                  Container(
                    width: 3,
                    height: 22,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF42A5F5), Color(0xFF1565C0)],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFE3F2FD),
                          letterSpacing: 0.3,
                        ),
                      ),
                      Text(
                        'Sign in to your account',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4A7BA7),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Email field
              _buildLabel('Email Address'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _emailController,
                hint: 'owner@company.com',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Email is required';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                      .hasMatch(val)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Password field
              _buildLabel('Password'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _passwordController,
                hint: '••••••••••',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFF4A7BA7),
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Password is required';
                  if (val.length < 6) return 'At least 6 characters required';
                  return null;
                },
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _rememberMe = !_rememberMe),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: _rememberMe
                                  ? const Color(0xFF42A5F5)
                                  : const Color(0xFF1E3A5F),
                              width: 1.5,
                            ),
                            color: _rememberMe
                                ? const Color(0xFF1565C0).withOpacity(0.3)
                                : Colors.transparent,
                          ),
                          child: _rememberMe
                              ? const Icon(Icons.check,
                                  size: 12, color: Color(0xFF42A5F5))
                              : null,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Remember me',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF4A7BA7),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Forgot password
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF42A5F5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Login button
              AnimatedBuilder(
                animation: _buttonPulseController,
                builder: (context, _) {
                  return Transform.scale(
                    scale: _isLoading ? 1.0 : _buttonPulse.value,
                    child: GestureDetector(
                      onTap: _isLoading ? null : _handleLogin,
                      child: Container(
                        width: double.infinity,
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xFF1565C0),
                              Color(0xFF1E88E5),
                              Color(0xFF42A5F5),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  const Color(0xFF1565C0).withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 1,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Sign In',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Color(0xFF90CAF9),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        color: Color(0xFFE3F2FD),
        fontSize: 14,
        letterSpacing: 0.3,
      ),
      cursorColor: const Color(0xFF42A5F5),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: const Color(0xFF4A7BA7).withOpacity(0.6),
          fontSize: 14,
        ),
        prefixIcon: Icon(prefixIcon,
            color: const Color(0xFF4A7BA7), size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFF081322),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: const Color(0xFF1E3A5F).withOpacity(0.8),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF1E88E5),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFEF5350),
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFEF5350),
            width: 1.5,
          ),
        ),
        errorStyle: const TextStyle(
          color: Color(0xFFEF9A9A),
          fontSize: 11,
        ),
      ),
    );
  }
  Widget _dividerLine({required bool toRight}) {
    return Container(
      width: 36,
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: toRight
              ? [const Color(0xFF42A5F5).withOpacity(0.8), Colors.transparent]
              : [Colors.transparent, const Color(0xFF42A5F5).withOpacity(0.8)],
        ),
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double progress;
  final List<_Particle> _particles = [];

  _ParticlePainter(this.progress) {
    final rng = math.Random(42);
    for (int i = 0; i < 28; i++) {
      _particles.add(_Particle(
        x: rng.nextDouble(),
        y: rng.nextDouble(),
        radius: rng.nextDouble() * 2.0 + 0.5,
        speed: rng.nextDouble() * 0.12 + 0.04,
        phase: rng.nextDouble() * math.pi * 2,
        opacity: rng.nextDouble() * 0.4 + 0.1,
        driftX: (rng.nextDouble() - 0.5) * 0.04,
      ));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final t = (progress + p.phase / (math.pi * 2)) % 1.0;
      final y = (p.y - t * p.speed) % 1.0;
      final x = p.x + math.sin(t * math.pi * 2 + p.phase) * p.driftX;
      final opacity = p.opacity * math.sin(t * math.pi).clamp(0.0, 1.0);

      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        p.radius,
        Paint()
          ..color = const Color(0xFF42A5F5).withOpacity(opacity)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
}

class _Particle {
  final double x, y, radius, speed, phase, opacity, driftX;
  const _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.phase,
    required this.opacity,
    required this.driftX,
  });
}