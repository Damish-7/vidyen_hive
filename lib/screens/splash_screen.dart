import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/auth_controller.dart';
import '../utils/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.6)),
    );
    _scaleAnim = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _slideAnim = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.8, curve: Curves.easeOut)),
    );
    _controller.forward();
    //_navigate();
  }

  // void _navigate() async {
  //   await Future.delayed(const Duration(seconds: 3));
  //   final auth = Get.find<AuthController>();
  //   if (auth.isLoggedIn) {
  //     Get.offAllNamed(auth.isAdmin ? '/admin-home' : '/home');
  //   } else {
  //     Get.offAllNamed('/login');
  //   }
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.2),
            radius: 1.2,
            colors: [Color(0xFF162848), AppColors.primary],
          ),
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -80,
              right: -80,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withOpacity(0.06),
                ),
              ),
            ),
            Positioned(
              bottom: -60,
              left: -60,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.gold.withOpacity(0.06),
                ),
              ),
            ),
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, __) => Opacity(
                  opacity: _fadeAnim.value,
                  child: Transform.scale(
                    scale: _scaleAnim.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo container
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color.fromARGB(255, 224, 234, 247), Color(0xFF0A3D7A)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accent.withOpacity(0.4),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'V',
                              style: GoogleFonts.playfairDisplay(
                                color: const Color.fromARGB(255, 8, 11, 36),
                                fontSize: 52,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Transform.translate(
                          offset: Offset(0, _slideAnim.value),
                          child: Column(
                            children: [
                              Text(
                                'VIDYEN',
                                style: GoogleFonts.playfairDisplay(
                                  color: AppColors.white,
                                  fontSize: 42,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 6,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 60,
                                height: 2,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [AppColors.gold, AppColors.goldLight],
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Text(
                              //   AppConstants.appTagline,
                              //   style: GoogleFonts.inter(
                              //     color: AppColors.white50,
                              //     fontSize: 13,
                              //     letterSpacing: 1.5,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Bottom loader
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, __) => Opacity(
                  opacity: _fadeAnim.value,
                  // child: Center(
                  //   child: SizedBox(
                  //     width: 28,
                  //     height: 28,
                  //     child: CircularProgressIndicator(
                  //       strokeWidth: 2,
                  //       valueColor: AlwaysStoppedAnimation<Color>(
                  //         AppColors.gold.withOpacity(0.7),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}