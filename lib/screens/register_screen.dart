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
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _designationCtrl = TextEditingController();
  final _institutionCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String _delegateType = AppConstants.delegateTypes.first;
  bool _obscure = true;
  bool _obscureConfirm = true;
  int _step = 0;
  final AuthController _auth = Get.find<AuthController>();

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    final error = await _auth.register(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
      delegateType: _delegateType,
      designation: _designationCtrl.text.trim(),
      institution: _institutionCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      country: _countryCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
    );
    if (error == null) {
      Get.offAllNamed('/home');
    } else {
      Get.snackbar('Registration Failed', error,
          backgroundColor: AppColors.error.withOpacity(0.9),
          colorText: AppColors.white,
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 12,
          margin: const EdgeInsets.all(16));
    }
  }

  bool _validateStep0() {
    if (_nameCtrl.text.isEmpty ||
        _emailCtrl.text.isEmpty ||
        _passCtrl.text.isEmpty ||
        _confirmPassCtrl.text.isEmpty) {
      Get.snackbar('Missing Fields', 'Please fill all required fields',
          backgroundColor: AppColors.error.withOpacity(0.9),
          colorText: AppColors.white,
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (_passCtrl.text != _confirmPassCtrl.text) {
      Get.snackbar('Password Mismatch', 'Passwords do not match',
          backgroundColor: AppColors.error.withOpacity(0.9),
          colorText: AppColors.white,
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (!GetUtils.isEmail(_emailCtrl.text)) {
      Get.snackbar('Invalid Email', 'Enter a valid email address',
          backgroundColor: AppColors.error.withOpacity(0.9),
          colorText: AppColors.white,
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.white, size: Responsive.icon(20)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Create Account',
          style: GoogleFonts.playfairDisplay(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
              fontSize: Responsive.font(20)),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Responsive.isDesktop
                  ? 560
                  : Responsive.isTablet
                      ? 520
                      : double.infinity,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.pageHPad(),
                vertical: Responsive.sp(16),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step progress
                    Row(
                      children: List.generate(
                        2,
                        (i) => Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: i < 1 ? 8 : 0),
                            height: 4,
                            decoration: BoxDecoration(
                              color: i <= _step
                                  ? AppColors.accent
                                  : AppColors.white20,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Responsive.sp(8)),
                    Text(
                      _step == 0
                          ? 'Step 1 of 2: Personal Info'
                          : 'Step 2 of 2: Professional Details',
                      style: GoogleFonts.inter(
                          color: AppColors.white50,
                          fontSize: Responsive.font(12)),
                    ),
                    SizedBox(height: Responsive.sp(20)),
                    if (Responsive.isTablet || Responsive.isDesktop) ...[
                      // Show both steps side by side on tablet/desktop
                      if (_step == 0)
                        _twoColumnLayout(_buildStep1Fields())
                      else
                        _twoColumnLayout(_buildStep2Fields()),
                    ] else ...[
                      if (_step == 0)
                        ..._buildStep1Fields()
                      else
                        ..._buildStep2Fields(),
                    ],
                    SizedBox(height: Responsive.sp(24)),
                    if (_step == 0)
                      GradientButton(
                        label: 'Next',
                        icon: Icons.arrow_forward_rounded,
                        onTap: () {
                          if (_validateStep0())
                            setState(() => _step = 1);
                        },
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => setState(() => _step = 0),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: AppColors.white20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        Responsive.radius(12))),
                                padding: EdgeInsets.symmetric(
                                    vertical: Responsive.sp(14)),
                              ),
                              child: Text('Back',
                                  style: GoogleFonts.inter(
                                      color: AppColors.white70,
                                      fontSize: Responsive.font(14))),
                            ),
                          ),
                          SizedBox(width: Responsive.sp(12)),
                          Expanded(
                            flex: 2,
                            child: Obx(() => GradientButton(
                                  label: 'Register',
                                  icon: Icons.check_circle_outline,
                                  onTap: _register,
                                  isLoading: _auth.isLoading.value,
                                )),
                          ),
                        ],
                      ),
                    SizedBox(height: Responsive.sp(32)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _twoColumnLayout(List<Widget> fields) {
    final List<Widget> rows = [];
    for (int i = 0; i < fields.length; i += 2) {
      if (i + 1 < fields.length) {
        rows.add(Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: fields[i]),
            SizedBox(width: Responsive.sp(14)),
            Expanded(child: fields[i + 1]),
          ],
        ));
      } else {
        rows.add(fields[i]);
      }
      if (i + 2 < fields.length) rows.add(SizedBox(height: Responsive.sp(14)));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows);
  }

  List<Widget> _buildStep1Fields() => [
        _field(_nameCtrl, 'Full Name', Icons.person_outline),
        SizedBox(height: Responsive.sp(14)),
        _field(_emailCtrl, 'Email Address', Icons.email_outlined,
            type: TextInputType.emailAddress),
        SizedBox(height: Responsive.sp(14)),
        _field(_phoneCtrl, 'Phone Number', Icons.phone_outlined,
            type: TextInputType.phone),
        SizedBox(height: Responsive.sp(14)),
        _passwordField(_passCtrl, 'Password', _obscure,
            () => setState(() => _obscure = !_obscure)),
        SizedBox(height: Responsive.sp(14)),
        _passwordField(_confirmPassCtrl, 'Confirm Password', _obscureConfirm,
            () => setState(() => _obscureConfirm = !_obscureConfirm),
            validator: (v) =>
                v != _passCtrl.text ? 'Passwords do not match' : null),
      ];

  List<Widget> _buildStep2Fields() => [
        _dropdown(),
        SizedBox(height: Responsive.sp(14)),
        _field(_designationCtrl, 'Designation / Title', Icons.work_outline),
        SizedBox(height: Responsive.sp(14)),
        _field(_institutionCtrl, 'Institution / Organisation',
            Icons.business_outlined),
        SizedBox(height: Responsive.sp(14)),
        _field(_cityCtrl, 'City', Icons.location_city_outlined),
        SizedBox(height: Responsive.sp(14)),
        _field(_countryCtrl, 'Country', Icons.flag_outlined),
      ];

  Widget _field(TextEditingController ctrl, String label, IconData icon,
      {TextInputType type = TextInputType.text}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: type,
      style: GoogleFonts.inter(
          color: AppColors.white, fontSize: Responsive.font(14)),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon:
            Icon(icon, color: AppColors.white50, size: Responsive.icon(20)),
      ),
      validator: (v) =>
          v == null || v.trim().isEmpty ? '$label is required' : null,
    );
  }

  Widget _passwordField(
      TextEditingController ctrl, String label, bool obscure, VoidCallback toggle,
      {String? Function(String?)? validator}) {
    return TextFormField(
      controller: ctrl,
      obscureText: obscure,
      style: GoogleFonts.inter(
          color: AppColors.white, fontSize: Responsive.font(14)),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline,
            color: AppColors.white50, size: 20),
        suffixIcon: IconButton(
          icon: Icon(
              obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: AppColors.white50,
              size: 20),
          onPressed: toggle,
        ),
      ),
      validator: validator ??
          (v) => v == null || v.length < 6 ? 'Min 6 characters' : null,
    );
  }

  Widget _dropdown() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Responsive.sp(14), vertical: Responsive.sp(4)),
      decoration: BoxDecoration(
        color: AppColors.white10,
        borderRadius: BorderRadius.circular(Responsive.radius(12)),
        border: Border.all(color: AppColors.white20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _delegateType,
          isExpanded: true,
          dropdownColor: AppColors.cardBg,
          style: GoogleFonts.inter(
              color: AppColors.white, fontSize: Responsive.font(14)),
          icon: const Icon(Icons.expand_more_rounded,
              color: AppColors.white50),
          items: AppConstants.delegateTypes
              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
              .toList(),
          onChanged: (v) => setState(() => _delegateType = v!),
        ),
      ),
    );
  }
}