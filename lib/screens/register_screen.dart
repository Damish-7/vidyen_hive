import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/auth_controller.dart';
import '../utils/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/common_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey        = GlobalKey<FormState>();
  final _nameCtrl       = TextEditingController();
  final _emailCtrl      = TextEditingController();
  final _passCtrl       = TextEditingController();
  final _confirmCtrl    = TextEditingController();
  final _designCtrl     = TextEditingController();
  final _institutionCtrl= TextEditingController();
  final _cityCtrl       = TextEditingController();
  final _countryCtrl    = TextEditingController();
  final _phoneCtrl      = TextEditingController();

  String _delegateType  = AppConstants.delegateTypes.first;
  bool   _obscure       = true;
  bool   _obscureConfirm= true;
  int    _step          = 0;

  final AuthController _auth = Get.find<AuthController>();

  // ── Actions ────────────────────────────────────────────────────
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    final error = await _auth.register(
      name:         _nameCtrl.text.trim(),
      email:        _emailCtrl.text.trim(),
      password:     _passCtrl.text,
      delegateType: _delegateType,
      designation:  _designCtrl.text.trim(),
      institution:  _institutionCtrl.text.trim(),
      city:         _cityCtrl.text.trim(),
      country:      _countryCtrl.text.trim(),
      phone:        _phoneCtrl.text.trim(),
    );
    if (error == null) {
      Get.offAllNamed('/home');
    } else {
      _snack('Registration Failed', error, AppColors.error);
    }
  }

  bool _validateStep1() {
    if (_nameCtrl.text.trim().isEmpty  ||
        _emailCtrl.text.trim().isEmpty ||
        _phoneCtrl.text.trim().isEmpty ||
        _passCtrl.text.isEmpty         ||
        _confirmCtrl.text.isEmpty) {
      _snack('Missing Fields', 'Please fill all required fields', AppColors.error);
      return false;
    }
    if (!GetUtils.isEmail(_emailCtrl.text.trim())) {
      _snack('Invalid Email', 'Enter a valid email address', AppColors.error);
      return false;
    }
    if (_passCtrl.text.length < 6) {
      _snack('Weak Password', 'Password must be at least 6 characters', AppColors.error);
      return false;
    }
    if (_passCtrl.text != _confirmCtrl.text) {
      _snack('Password Mismatch', 'Passwords do not match', AppColors.error);
      return false;
    }
    return true;
  }

  void _snack(String title, String msg, Color color) {
    Get.snackbar(title, msg,
        backgroundColor: color.withOpacity(0.9),
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 12,
        margin: const EdgeInsets.all(16));
  }

  // ── Build ───────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text('Create Account',
            style: GoogleFonts.playfairDisplay(
                color: AppColors.white, fontWeight: FontWeight.w700, fontSize: 20)),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Responsive.isDesktop ? 580 : Responsive.isTablet ? 520 : double.infinity),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: Responsive.pageHPad(), vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgressBar(),
                    const SizedBox(height: 8),
                    Text(
                      _step == 0 ? 'Step 1 of 2 — Personal Info' : 'Step 2 of 2 — Professional Details',
                      style: GoogleFonts.inter(color: AppColors.white50, fontSize: 12),
                    ),
                    const SizedBox(height: 24),
                    // ── Fields ──
                    _step == 0 ? _buildStep1() : _buildStep2(),
                    const SizedBox(height: 28),
                    // ── Buttons ──
                    _step == 0 ? _nextButton() : _backRegisterButtons(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Progress bar ───────────────────────────────────────────────
  Widget _buildProgressBar() {
    return Row(
      children: List.generate(2, (i) => Expanded(
        child: Container(
          margin: EdgeInsets.only(right: i == 0 ? 8 : 0),
          height: 4,
          decoration: BoxDecoration(
            color: i <= _step ? AppColors.accent : AppColors.white20,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      )),
    );
  }

  // ── Step 1 — Personal Info ─────────────────────────────────────
  Widget _buildStep1() {
    if (Responsive.isTablet || Responsive.isDesktop) {
      // 2-column layout on wider screens
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full-width name
          _field(_nameCtrl, 'Full Name', Icons.person_outline,
              validator: _required('Full Name')),
          const SizedBox(height: 14),
          // Email + Phone side by side
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: _field(_emailCtrl, 'Email Address', Icons.email_outlined,
                type: TextInputType.emailAddress,
                validator: (v) => v == null || v.trim().isEmpty ? 'Email is required'
                    : !GetUtils.isEmail(v) ? 'Enter valid email' : null)),
            const SizedBox(width: 14),
            Expanded(child: _field(_phoneCtrl, 'Phone Number', Icons.phone_outlined,
                type: TextInputType.phone, validator: _required('Phone'))),
          ]),
          const SizedBox(height: 14),
          // Password + Confirm side by side
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: _passwordField(_passCtrl, 'Password', _obscure,
                () => setState(() => _obscure = !_obscure))),
            const SizedBox(width: 14),
            Expanded(child: _passwordField(_confirmCtrl, 'Confirm Password', _obscureConfirm,
                () => setState(() => _obscureConfirm = !_obscureConfirm),
                validator: (v) => v != _passCtrl.text ? 'Passwords do not match' : null)),
          ]),
        ],
      );
    }
    // Single-column on mobile
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _field(_nameCtrl, 'Full Name', Icons.person_outline,
          validator: _required('Full Name')),
      const SizedBox(height: 14),
      _field(_emailCtrl, 'Email Address', Icons.email_outlined,
          type: TextInputType.emailAddress,
          validator: (v) => v == null || v.trim().isEmpty ? 'Email is required'
              : !GetUtils.isEmail(v) ? 'Enter valid email' : null),
      const SizedBox(height: 14),
      _field(_phoneCtrl, 'Phone Number', Icons.phone_outlined,
          type: TextInputType.phone, validator: _required('Phone')),
      const SizedBox(height: 14),
      _passwordField(_passCtrl, 'Password', _obscure,
          () => setState(() => _obscure = !_obscure)),
      const SizedBox(height: 14),
      _passwordField(_confirmCtrl, 'Confirm Password', _obscureConfirm,
          () => setState(() => _obscureConfirm = !_obscureConfirm),
          validator: (v) => v != _passCtrl.text ? 'Passwords do not match' : null),
    ]);
  }

  // ── Step 2 — Professional Details ──────────────────────────────
  Widget _buildStep2() {
    if (Responsive.isTablet || Responsive.isDesktop) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Delegate type full width
        _delegateDropdown(),
        const SizedBox(height: 14),
        // Designation + Institution
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: _field(_designCtrl, 'Designation / Title', Icons.work_outline,
              validator: _required('Designation'))),
          const SizedBox(width: 14),
          Expanded(child: _field(_institutionCtrl, 'Institution / Organisation',
              Icons.business_outlined, validator: _required('Institution'))),
        ]),
        const SizedBox(height: 14),
        // City + Country
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: _field(_cityCtrl, 'City', Icons.location_city_outlined,
              validator: _required('City'))),
          const SizedBox(width: 14),
          Expanded(child: _field(_countryCtrl, 'Country', Icons.flag_outlined,
              validator: _required('Country'))),
        ]),
      ]);
    }
    // Single column on mobile
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _delegateDropdown(),
      const SizedBox(height: 14),
      _field(_designCtrl, 'Designation / Title', Icons.work_outline,
          validator: _required('Designation')),
      const SizedBox(height: 14),
      _field(_institutionCtrl, 'Institution / Organisation', Icons.business_outlined,
          validator: _required('Institution')),
      const SizedBox(height: 14),
      _field(_cityCtrl, 'City', Icons.location_city_outlined,
          validator: _required('City')),
      const SizedBox(height: 14),
      _field(_countryCtrl, 'Country', Icons.flag_outlined,
          validator: _required('Country')),
    ]);
  }

  // ── Buttons ────────────────────────────────────────────────────
  Widget _nextButton() {
    return GradientButton(
      label: 'Next',
      icon: Icons.arrow_forward_rounded,
      onTap: () { if (_validateStep1()) setState(() => _step = 1); },
    );
  }

  Widget _backRegisterButtons() {
    return Row(children: [
      Expanded(
        child: OutlinedButton(
          onPressed: () => setState(() => _step = 0),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.white20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: Text('Back',
              style: GoogleFonts.inter(color: AppColors.white70, fontSize: 14)),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        flex: 2,
        child: Obx(() => GradientButton(
              label: 'Register',
              icon: Icons.check_circle_outline,
              onTap: _register,
              isLoading: _auth.isLoading.value,
            )),
      ),
    ]);
  }

  // ── Field helpers ──────────────────────────────────────────────
  String? Function(String?) _required(String label) =>
      (v) => v == null || v.trim().isEmpty ? '$label is required' : null;

  Widget _field(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    TextInputType type = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: type,
      style: GoogleFonts.inter(color: AppColors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.white50, size: 20),
      ),
      validator: validator ?? _required(label),
    );
  }

  Widget _passwordField(
    TextEditingController ctrl,
    String label,
    bool obscure,
    VoidCallback toggle, {
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      obscureText: obscure,
      style: GoogleFonts.inter(color: AppColors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.white50, size: 20),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: AppColors.white50, size: 20,
          ),
          onPressed: toggle,
        ),
      ),
      validator: validator ??
          (v) => v == null || v.length < 6 ? 'Min 6 characters required' : null,
    );
  }

  Widget _delegateDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _delegateType,
          isExpanded: true,
          dropdownColor: AppColors.cardBg,
          style: GoogleFonts.inter(color: AppColors.white, fontSize: 14),
          icon: const Icon(Icons.expand_more_rounded, color: AppColors.white50),
          items: AppConstants.delegateTypes
              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
              .toList(),
          onChanged: (v) => setState(() => _delegateType = v!),
        ),
      ),
    );
  }
}