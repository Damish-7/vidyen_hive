import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/auth_controller.dart';
import '../utils/app_theme.dart';
import '../utils/responsive.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    final auth = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text('Profile', style: GoogleFonts.playfairDisplay(color: AppColors.white, fontWeight: FontWeight.w700, fontSize: Responsive.font(20))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white, size: Responsive.icon(20)),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final user = auth.currentUser.value;
        if (user == null) return const SizedBox();
        return SingleChildScrollView(
          padding: EdgeInsets.all(Responsive.sp(20)),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth),
              child: Column(
                children: [
                  // Avatar card — side-by-side on tablet/desktop
                  Responsive.isMobile
                      ? _avatarCardMobile(user)
                      : _avatarCardWide(user),
                  SizedBox(height: Responsive.sp(20)),
                  // Details — two columns on tablet/desktop
                  if (Responsive.isMobile) ...[
                    _detailSection('Registration Details', [
                      _DR(Icons.email_outlined, 'Email', user.email),
                      _DR(Icons.phone_outlined, 'Phone', user.phone),
                      _DR(Icons.category_outlined, 'Delegate Type', user.delegateType),
                    ]),
                    SizedBox(height: Responsive.sp(14)),
                    _detailSection('Professional Info', [
                      _DR(Icons.work_outline, 'Designation', user.designation),
                      _DR(Icons.business_outlined, 'Institution', user.institution),
                    ]),
                    SizedBox(height: Responsive.sp(14)),
                    _detailSection('Location', [
                      _DR(Icons.location_city_outlined, 'City', user.city),
                      _DR(Icons.flag_outlined, 'Country', user.country),
                    ]),
                  ] else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(children: [
                            _detailSection('Registration Details', [
                              _DR(Icons.email_outlined, 'Email', user.email),
                              _DR(Icons.phone_outlined, 'Phone', user.phone),
                              _DR(Icons.category_outlined, 'Delegate Type', user.delegateType),
                              _DR(Icons.badge_outlined, 'Reg Code', user.regCode),
                            ]),
                          ]),
                        ),
                        SizedBox(width: Responsive.sp(14)),
                        Expanded(
                          child: Column(children: [
                            _detailSection('Professional & Location', [
                              _DR(Icons.work_outline, 'Designation', user.designation),
                              _DR(Icons.business_outlined, 'Institution', user.institution),
                              _DR(Icons.location_city_outlined, 'City', user.city),
                              _DR(Icons.flag_outlined, 'Country', user.country),
                            ]),
                          ]),
                        ),
                      ],
                    ),
                  SizedBox(height: Responsive.sp(24)),
                  OutlinedButton.icon(
                    onPressed: () => Get.dialog(AlertDialog(
                      backgroundColor: AppColors.cardBg,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      title: Text('Logout', style: GoogleFonts.playfairDisplay(color: AppColors.white, fontWeight: FontWeight.w700)),
                      content: Text('Are you sure you want to logout?', style: GoogleFonts.inter(color: AppColors.white70)),
                      actions: [
                        TextButton(onPressed: () => Get.back(), child: Text('Cancel', style: GoogleFonts.inter(color: AppColors.white50))),
                        ElevatedButton(
                          onPressed: () => auth.logout(),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                          child: Text('Logout', style: GoogleFonts.inter(color: AppColors.white)),
                        ),
                      ],
                    )),
                    icon: Icon(Icons.logout_rounded, color: AppColors.error, size: Responsive.icon(18)),
                    label: Text('Logout', style: GoogleFonts.inter(color: AppColors.error, fontWeight: FontWeight.w600, fontSize: Responsive.font(14))),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.radius(12))),
                      padding: EdgeInsets.symmetric(horizontal: Responsive.sp(24), vertical: Responsive.sp(12)),
                    ),
                  ),
                  SizedBox(height: Responsive.sp(32)),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _avatarCardMobile(user) {
    return Builder(builder: (context) {
      Responsive.init(context);
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(Responsive.sp(24)),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF1557CC), Color(0xFF0A3D7A)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(Responsive.radius(24)),
        ),
        child: Column(
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.white.withOpacity(0.15), border: Border.all(color: AppColors.white.withOpacity(0.3), width: 2)),
              child: Center(child: Text(user.name[0].toUpperCase(), style: GoogleFonts.playfairDisplay(color: AppColors.white, fontSize: Responsive.font(34), fontWeight: FontWeight.w700))),
            ),
            SizedBox(height: Responsive.sp(12)),
            Text(user.name, style: GoogleFonts.playfairDisplay(color: AppColors.white, fontSize: Responsive.font(22), fontWeight: FontWeight.w700)),
            SizedBox(height: Responsive.sp(4)),
            Text(user.designation, style: GoogleFonts.inter(color: AppColors.white70, fontSize: Responsive.font(13))),
            SizedBox(height: Responsive.sp(10)),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _badge(user.delegateType, AppColors.goldLight, AppColors.gold),
              SizedBox(width: Responsive.sp(8)),
              _badge(user.status.toUpperCase(), user.status == 'approved' ? AppColors.success : AppColors.warning, user.status == 'approved' ? AppColors.success : AppColors.warning),
            ]),
            SizedBox(height: Responsive.sp(12)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Responsive.sp(14), vertical: Responsive.sp(6)),
              decoration: BoxDecoration(color: AppColors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.badge_outlined, color: AppColors.white70, size: Responsive.icon(15)),
                SizedBox(width: Responsive.sp(6)),
                Text(user.regCode, style: GoogleFonts.inter(color: AppColors.white, fontWeight: FontWeight.w700, letterSpacing: 1.5, fontSize: Responsive.font(13))),
              ]),
            ),
          ],
        ),
      );
    });
  }

  Widget _avatarCardWide(user) {
    return Builder(builder: (context) {
      Responsive.init(context);
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(Responsive.sp(28)),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF1557CC), Color(0xFF0A3D7A)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(Responsive.radius(24)),
        ),
        child: Row(
          children: [
            Container(
              width: 90, height: 90,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.white.withOpacity(0.15), border: Border.all(color: AppColors.white.withOpacity(0.3), width: 2)),
              child: Center(child: Text(user.name[0].toUpperCase(), style: GoogleFonts.playfairDisplay(color: AppColors.white, fontSize: Responsive.font(38), fontWeight: FontWeight.w700))),
            ),
            SizedBox(width: Responsive.sp(24)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: GoogleFonts.playfairDisplay(color: AppColors.white, fontSize: Responsive.font(24), fontWeight: FontWeight.w700)),
                  SizedBox(height: Responsive.sp(4)),
                  Text(user.designation, style: GoogleFonts.inter(color: AppColors.white70, fontSize: Responsive.font(14))),
                  SizedBox(height: Responsive.sp(10)),
                  Row(children: [
                    _badge(user.delegateType, AppColors.goldLight, AppColors.gold),
                    SizedBox(width: Responsive.sp(8)),
                    _badge(user.status.toUpperCase(), user.status == 'approved' ? AppColors.success : AppColors.warning, user.status == 'approved' ? AppColors.success : AppColors.warning),
                  ]),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Responsive.sp(14), vertical: Responsive.sp(8)),
              decoration: BoxDecoration(color: AppColors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Column(children: [
                Icon(Icons.badge_outlined, color: AppColors.white70, size: Responsive.icon(18)),
                SizedBox(height: Responsive.sp(4)),
                Text(user.regCode, style: GoogleFonts.inter(color: AppColors.white, fontWeight: FontWeight.w700, letterSpacing: 1.5, fontSize: Responsive.font(13))),
              ]),
            ),
          ],
        ),
      );
    });
  }

  Widget _badge(String text, Color textColor, Color borderColor) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: borderColor.withOpacity(0.15), borderRadius: BorderRadius.circular(20), border: Border.all(color: borderColor.withOpacity(0.4))),
        child: Text(text, style: GoogleFonts.inter(color: textColor, fontSize: 11, fontWeight: FontWeight.w600)),
      );

  Widget _detailSection(String title, List<_DR> rows) {
    return Builder(builder: (context) {
      Responsive.init(context);
      return Container(
        padding: EdgeInsets.all(Responsive.sp(18)),
        decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(Responsive.radius(16)), border: Border.all(color: AppColors.white10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.inter(color: AppColors.white70, fontSize: Responsive.font(12), fontWeight: FontWeight.w600, letterSpacing: 0.8)),
            SizedBox(height: Responsive.sp(14)),
            ...rows.map((r) => Padding(
              padding: EdgeInsets.only(bottom: Responsive.sp(12)),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(r.icon, color: AppColors.accent, size: Responsive.icon(17)),
                SizedBox(width: Responsive.sp(12)),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(r.label, style: GoogleFonts.inter(color: AppColors.white50, fontSize: Responsive.font(11))),
                  Text(r.value, style: GoogleFonts.inter(color: AppColors.white, fontSize: Responsive.font(14), fontWeight: FontWeight.w500)),
                ])),
              ]),
            )),
          ],
        ),
      );
    });
  }
}

class _DR {
  final IconData icon;
  final String label;
  final String value;
  const _DR(this.icon, this.label, this.value);
}