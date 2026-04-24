import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:ownerapp_pixelmind/views/auth/auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _particleController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoRotation;
  late Animation<double> _textOpacity;
  late Animation<Offset> _taglineSlide;
  late Animation<double> _taglineOpacity;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _ringScale1;
  late Animation<double> _ringScale2;
  late Animation<double> _ringOpacity1;
  late Animation<double> _ringOpacity2;

  @override
  void initState() {
    super.initState();

    // Logo animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _logoRotation = Tween<double>(begin: -0.3, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    // Ring animations
    _ringScale1 = Tween<double>(begin: 0.8, end: 1.6).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );
    _ringOpacity1 = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );
    _ringScale2 = Tween<double>(begin: 0.8, end: 2.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );
    _ringOpacity2 = Tween<double>(begin: 0.4, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    // Text animation
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );

    _taglineSlide =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    // Pulse animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Particle animation
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // Shimmer animation
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    // Start sequence
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _textController.forward();
    });


    _logoController.addStatusListener((status) {
    if (status == AnimationStatus.completed) {
      _navigateToAuth();
    }
  });
  }




  void _navigateToAuth() async {
  await Future.delayed(const Duration(seconds: 2)); 

  if (!mounted) return;

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const AuthScreen(),
    ),
  );
}

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            // Floating particles
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, _) {
                return CustomPaint(
                  painter: ParticlePainter(_particleController.value),
                  size: Size.infinite,
                );
              },
            ),

            // Radial glow at center
            Center(
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF1565C0).withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Logo section with rings
                  AnimatedBuilder(
                    animation: Listenable.merge(
                        [_logoController, _pulseController]),
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer ring 2
                          Transform.scale(
                            scale: _ringScale2.value,
                            child: Opacity(
                              opacity: _ringOpacity2.value,
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        const Color(0xFF42A5F5).withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Outer ring 1
                          Transform.scale(
                            scale: _ringScale1.value,
                            child: Opacity(
                              opacity: _ringOpacity1.value,
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF1E88E5).withOpacity(0.7),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Subtle pulse ring
                          Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      const Color(0xFF42A5F5).withOpacity(0.18),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),

                          // Logo container
                          Transform.scale(
                            scale: _logoScale.value,
                            child: Transform.rotate(
                              angle: _logoRotation.value,
                              child: Opacity(
                                opacity: _logoOpacity.value,
                                child: Container(
                                  width: 100,
                                  height: 100,
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
                                            .withOpacity(0.6),
                                        blurRadius: 40,
                                        spreadRadius: 5,
                                      ),
                                      BoxShadow(
                                        color: const Color(0xFF42A5F5)
                                            .withOpacity(0.3),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Company logo image
                                      ClipOval(
                                        child: Image.asset(
                                          'assets/companylogo.png',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 44),

                  // App Name with shimmer
                  AnimatedBuilder(
                    animation: Listenable.merge([_textController, _shimmerController]),
                    builder: (context, _) {
                      return FadeTransition(
                        opacity: _textOpacity,
                        child: ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: const [
                                Color(0xFFE3F2FD),
                                Color(0xFFFFFFFF),
                                Color(0xFF90CAF9),
                                Color(0xFFFFFFFF),
                                Color(0xFFE3F2FD),
                              ],
                              stops: [
                                0.0,
                                (_shimmerAnimation.value - 0.3).clamp(0.0, 1.0),
                                _shimmerAnimation.value.clamp(0.0, 1.0),
                                (_shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
                                1.0,
                              ],
                            ).createShader(bounds);
                          },
                          child: const Text(
                            'OwnerApp',
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1.5,
                              fontFamily: 'serif',
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  // Divider line
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, _) {
                      return FadeTransition(
                        opacity: _taglineOpacity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    const Color(0xFF42A5F5).withOpacity(0.8),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF42A5F5),
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF42A5F5).withOpacity(0.8),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  // Tagline
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, _) {
                      return SlideTransition(
                        position: _taglineSlide,
                        child: FadeTransition(
                          opacity: _taglineOpacity,
                          child: const Text(
                            'Manage · Monitor · Grow',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF90CAF9),
                              letterSpacing: 3.0,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const Spacer(flex: 2),

                  // Loading indicator
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, _) {
                      return FadeTransition(
                        opacity: _taglineOpacity,
                        child: Column(
                          children: [
                            SizedBox(
                              width: 160,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: AnimatedBuilder(
                                  animation: _particleController,
                                  builder: (context, _) {
                                    return LinearProgressIndicator(
                                      value: _particleController.value > 0.5
                                          ? null
                                          : _particleController.value * 2,
                                      minHeight: 2,
                                      backgroundColor:
                                          const Color(0xFF1E3A5F),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                        Color(0xFF42A5F5),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Initializing your workspace...',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF4A7BA7),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 48),
                ],
              ),
            ),

            // Top-right corner badge
            Positioned(
              top: 52,
              right: 24,
              child: AnimatedBuilder(
                animation: _textController,
                builder: (context, _) {
                  return FadeTransition(
                    opacity: _taglineOpacity,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF1E88E5).withOpacity(0.4),
                        ),
                        color: const Color(0xFF0D1B2E),
                      ),
                      child: const Text(
                        'v2.0',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64B5F6),
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Floating particles painter
class ParticlePainter extends CustomPainter {
  final double progress;
  final List<_Particle> _particles = [];

  ParticlePainter(this.progress) {
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

      final opacity =
          p.opacity * math.sin(t * math.pi).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = const Color(0xFF42A5F5).withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        p.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
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