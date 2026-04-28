import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidyen_hive/controllers/submission_controler.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/app_theme.dart';
import '../../utils/responsive.dart';
import '../../widgets/common_widgets.dart';

class DashboardHomeTab extends StatelessWidget {
  const DashboardHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    final auth = Get.find<AuthController>();
    final sub = Get.find<SubmissionController>();

    return SingleChildScrollView(
      padding: EdgeInsets.all(Responsive.sp(20)),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Banner
              Obx(() {
                final user = auth.currentUser.value;
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(Responsive.sp(24)),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1557CC), Color(0xFF0A3D7A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(Responsive.radius(20)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Responsive.isMobile
                      ? _bannerContent(user)
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: _bannerContent(user)),
                            // Avatar on tablet/desktop
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.white.withOpacity(0.1),
                                border: Border.all(color: AppColors.white.withOpacity(0.3), width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  (user?.name ?? 'U')[0].toUpperCase(),
                                  style: GoogleFonts.playfairDisplay(color: AppColors.white, fontSize: 34, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ],
                        ),
                );
              }),
              SizedBox(height: Responsive.sp(24)),
              // Stats
              Obx(() => GridView.count(
                crossAxisCount: Responsive.gridCrossAxisCount(mobile: 4, tablet: 4, desktop: 4),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: Responsive.sp(10),
                mainAxisSpacing: Responsive.sp(10),
                childAspectRatio: Responsive.isMobile ? 0.9 : 1.1,
                children: [
                  StatCard(value: sub.abstracts.length.toString(), label: 'Abstracts', icon: Icons.article_rounded, color: AppColors.accent),
                  StatCard(value: sub.preconfs.length.toString(), label: 'Pre-Conf', icon: Icons.event_rounded, color: AppColors.gold),
                  StatCard(value: sub.workshops.length.toString(), label: 'Workshops', icon: Icons.build_circle_rounded, color: AppColors.success),
                  StatCard(value: sub.certificates.length.toString(), label: 'Certs', icon: Icons.workspace_premium_rounded, color: const Color(0xFFAB47BC)),
                ],
              )),
              SizedBox(height: Responsive.sp(24)),
              SectionHeader(title: 'Quick Actions', subtitle: 'Submit your conference contributions'),
              SizedBox(height: Responsive.sp(14)),
              GridView.count(
                crossAxisCount: Responsive.gridCrossAxisCount(mobile: 2, tablet: 4, desktop: 4),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: Responsive.sp(12),
                mainAxisSpacing: Responsive.sp(12),
                childAspectRatio: Responsive.isMobile ? 1.35 : 1.4,
                children: [
                  _QuickActionCard(icon: Icons.article_rounded, label: 'Submit Abstract', color: AppColors.accent, onTap: () => Get.toNamed('/submit-abstract')),
                  _QuickActionCard(icon: Icons.event_rounded, label: 'Pre-Conf Session', color: AppColors.gold, onTap: () => Get.toNamed('/submit-preconf')),
                  _QuickActionCard(icon: Icons.build_circle_rounded, label: 'Register Workshop', color: AppColors.success, onTap: () => Get.toNamed('/submit-workshop')),
                  _QuickActionCard(icon: Icons.person_rounded, label: 'My Profile', color: const Color(0xFFAB47BC), onTap: () => Get.toNamed('/profile')),
                ],
              ),
              SizedBox(height: Responsive.sp(24)),
              Container(
                padding: EdgeInsets.all(Responsive.sp(20)),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(Responsive.radius(16)),
                  border: Border.all(color: AppColors.gold.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: AppColors.gold, size: Responsive.icon(18)),
                        SizedBox(width: Responsive.sp(8)),
                        Text('Conference Portal', style: GoogleFonts.inter(color: AppColors.gold, fontWeight: FontWeight.w600, fontSize: Responsive.font(14))),
                      ],
                    ),
                    SizedBox(height: Responsive.sp(12)),
                    _infoRow('Abstracts', 'Submit research abstracts for review'),
                    _infoRow('Pre-Conference', 'Register for pre-conference sessions'),
                    _infoRow('Workshops', 'Join interactive workshop sessions'),
                    _infoRow('Certificates', 'Download issued certificates'),
                  ],
                ),
              ),
              SizedBox(height: Responsive.sp(20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bannerContent(user) {
    return Builder(builder: (context) {
      Responsive.init(context);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: Responsive.sp(10), vertical: Responsive.sp(4)),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.gold.withOpacity(0.4)),
                ),
                child: Text(user?.delegateType ?? 'Delegate', style: GoogleFonts.inter(color: AppColors.goldLight, fontSize: Responsive.font(11), fontWeight: FontWeight.w600)),
              ),
              SizedBox(width: Responsive.sp(8)),
              StatusBadge(user?.status ?? 'pending'),
            ],
          ),
          SizedBox(height: Responsive.sp(12)),
          Text('Welcome back,', style: GoogleFonts.inter(color: AppColors.white70, fontSize: Responsive.font(14))),
          Text(user?.name ?? 'Participant', style: GoogleFonts.playfairDisplay(color: AppColors.white, fontSize: Responsive.font(24), fontWeight: FontWeight.w700)),
          SizedBox(height: Responsive.sp(4)),
          Text(user?.institution ?? '', style: GoogleFonts.inter(color: AppColors.white50, fontSize: Responsive.font(13))),
          SizedBox(height: Responsive.sp(12)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: Responsive.sp(12), vertical: Responsive.sp(6)),
            decoration: BoxDecoration(color: AppColors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.badge_outlined, color: AppColors.white70, size: Responsive.icon(14)),
                SizedBox(width: Responsive.sp(6)),
                Text(user?.regCode ?? 'N/A', style: GoogleFonts.inter(color: AppColors.white, fontSize: Responsive.font(13), fontWeight: FontWeight.w600, letterSpacing: 1)),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _infoRow(String title, String desc) {
    return Builder(builder: (context) {
      Responsive.init(context);
      return Padding(
        padding: EdgeInsets.symmetric(vertical: Responsive.sp(5)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 6, height: 6, margin: const EdgeInsets.only(top: 5), decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.6), shape: BoxShape.circle)),
            SizedBox(width: Responsive.sp(10)),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.inter(fontSize: Responsive.font(13)),
                  children: [
                    TextSpan(text: '$title: ', style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600)),
                    TextSpan(text: desc, style: const TextStyle(color: AppColors.white50)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Responsive.sp(14)),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(Responsive.radius(16)),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(Responsive.sp(8)),
              decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(Responsive.radius(10))),
              child: Icon(icon, color: color, size: Responsive.icon(20)),
            ),
            const Spacer(),
            Text(label, style: GoogleFonts.inter(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: Responsive.font(13))),
          ],
        ),
      ),
    );
  }
}