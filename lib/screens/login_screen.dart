import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/auth_controller.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
 // final AuthController _auth = Get.find<AuthController>();

  // Future<void> _login() async {
  //   if (!_formKey.currentState!.validate()) return;
  //   final success = await _auth.login(_emailCtrl.text.trim(), _passCtrl.text);
  //   if (success) {
  //     if (_auth.isAdmin) {
  //       Get.offAllNamed('/admin-home');
  //     } else {
  //       Get.offAllNamed('/home');
  //     }
  //   } else {
  //     Get.snackbar(
  //       'Login Failed',
  //       'Invalid email or password',
  //       backgroundColor: AppColors.error.withOpacity(0.9),
  //       colorText: AppColors.white,
  //       snackPosition: SnackPosition.BOTTOM,
  //       borderRadius: 12,
  //       margin: const EdgeInsets.all(16),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D1F3C), AppColors.primary],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 60),
                // Header
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.accent, Color(0xFF0A3D7A)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.35),
                        blurRadius: 20,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'V',
                      style: GoogleFonts.playfairDisplay(
                        color: AppColors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'VIDYEN',
                  style: GoogleFonts.playfairDisplay(
                    color: AppColors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sign in to continue',
                  style: GoogleFonts.inter(
                    color: AppColors.white50,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 48),
                // Form card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.white10),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back',
                          style: GoogleFonts.playfairDisplay(
                            color: AppColors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Enter your credentials to access the portal',
                          style: GoogleFonts.inter(
                            color: AppColors.white50,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 28),
                        TextFormField(
                          controller: _emailCtrl,
                          style: GoogleFonts.inter(color: AppColors.white),
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                            prefixIcon: Icon(Icons.email_outlined, color: AppColors.white50, size: 20),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Email is required';
                            if (!GetUtils.isEmail(v)) return 'Enter valid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passCtrl,
                          obscureText: _obscure,
                          style: GoogleFonts.inter(color: AppColors.white),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.white50, size: 20),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: AppColors.white50,
                                size: 20,
                              ),
                              onPressed: () => setState(() => _obscure = !_obscure),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Password is required';
                            return null;
                          },
                        ),
                        const SizedBox(height: 28),
                        // Obx(() => GradientButton(
                        //   label: 'Sign In',
                        //   icon: Icons.login_rounded,
                        //   onTap: _login,
                        // //  isLoading: _auth.isLoading.value,
                        // )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: GoogleFonts.inter(color: AppColors.white50, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed('/register'),
                      child: Text(
                        'Register',
                        style: GoogleFonts.inter(
                          color: AppColors.accentLight,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Demo hint
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.gold.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.gold, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Admin: admin@vidyen.org / Admin@123',
                          style: GoogleFonts.inter(
                            color: AppColors.goldLight,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}