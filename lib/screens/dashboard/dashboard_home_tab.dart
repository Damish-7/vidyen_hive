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
    final sub  = Get.find<SubmissionController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Welcome Banner ───────────────────────────────
              Obx(() {
                final user = auth.currentUser.value;
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1557CC), Color(0xFF0A3D7A)],
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.gold.withOpacity(0.4)),
                          ),
                          child: Text(user?.delegateType ?? 'Delegate',
                              style: GoogleFonts.inter(color: AppColors.goldLight, fontSize: 11, fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 8),
                        StatusBadge(user?.status ?? 'pending'),
                      ]),
                      const SizedBox(height: 12),
                      Text('Welcome back,', style: GoogleFonts.inter(color: AppColors.white70, fontSize: 13)),
                      Text(user?.name ?? 'Participant',
                          style: GoogleFonts.playfairDisplay(color: AppColors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(user?.institution ?? '', style: GoogleFonts.inter(color: AppColors.white50, fontSize: 13)),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: AppColors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.badge_outlined, color: AppColors.white70, size: 14),
                          const SizedBox(width: 6),
                          Text(user?.regCode ?? 'N/A',
                              style: GoogleFonts.inter(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1)),
                        ]),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 22),
              // ── Stats ────────────────────────────────────────
              Obx(() => Row(children: [
                Expanded(child: StatCard(value: sub.abstracts.length.toString(),    label: 'Abstracts',  icon: Icons.article_rounded,            color: AppColors.accent)),
                const SizedBox(width: 10),
                Expanded(child: StatCard(value: sub.preconfs.length.toString(),     label: 'Pre-Conf',   icon: Icons.event_rounded,              color: AppColors.gold)),
                const SizedBox(width: 10),
                Expanded(child: StatCard(value: sub.workshops.length.toString(),    label: 'Workshops',  icon: Icons.build_circle_rounded,       color: AppColors.success)),
                const SizedBox(width: 10),
                Expanded(child: StatCard(value: sub.certificates.length.toString(), label: 'Certs',      icon: Icons.workspace_premium_rounded,  color: const Color(0xFFAB47BC))),
              ])),
              const SizedBox(height: 22),
              // ── Quick Actions ────────────────────────────────
              const SectionHeader(title: 'Quick Actions', subtitle: 'Submit your conference contributions'),
              const SizedBox(height: 14),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  _QCard(icon: Icons.article_rounded,       label: 'Submit Abstract',   color: AppColors.accent,             onTap: () {}),
                  _QCard(icon: Icons.event_rounded,         label: 'Pre-Conf Session',  color: AppColors.gold,               onTap: () {}),
                  _QCard(icon: Icons.build_circle_rounded,  label: 'Register Workshop', color: AppColors.success,            onTap: () {}),
                  _QCard(icon: Icons.person_rounded,        label: 'My Profile',        color: const Color(0xFFAB47BC),      onTap: () => Get.toNamed('/profile')),
                ],
              ),
              const SizedBox(height: 22),
              // ── Info ─────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.gold.withOpacity(0.2)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const Icon(Icons.info_outline, color: AppColors.gold, size: 16),
                    const SizedBox(width: 8),
                    Text('Conference Portal', style: GoogleFonts.inter(color: AppColors.gold, fontWeight: FontWeight.w600, fontSize: 13)),
                  ]),
                  const SizedBox(height: 10),
                  _infoRow('Abstracts',        'Submit research abstracts for review'),
                  _infoRow('Pre-Conference',   'Register for pre-conference sessions'),
                  _infoRow('Workshops',        'Join interactive workshop sessions'),
                  _infoRow('Certificates',     'Download issued certificates'),
                ]),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 5, height: 5, margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.6), shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Expanded(child: RichText(text: TextSpan(style: GoogleFonts.inter(fontSize: 13), children: [
          TextSpan(text: '$title: ', style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600)),
          TextSpan(text: desc,       style: const TextStyle(color: AppColors.white50)),
        ]))),
      ]),
    );
  }
}

class _QCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QCard({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 20),
          ),
          const Spacer(),
          Text(label, style: GoogleFonts.inter(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: 13)),
        ]),
      ),
    );
  }
}