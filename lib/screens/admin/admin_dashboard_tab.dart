import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidyen_hive/controllers/submission_controler.dart';
import '../../services/hive_service.dart';
import '../../utils/app_theme.dart';
import '../../utils/responsive.dart';
import '../../widgets/common_widgets.dart';

class AdminDashboardTab extends StatelessWidget {
  const AdminDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    final sub = Get.find<SubmissionController>();
    final users = HiveService.getAllUsers();
    final approved = users.where((u) => u.status == 'approved').length;
    final pending = users.where((u) => u.status == 'pending').length;

    return SingleChildScrollView(
      padding: EdgeInsets.all(Responsive.sp(20)),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(Responsive.sp(22)),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF8B6914), Color(0xFF5C4409)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(Responsive.radius(20)),
                  boxShadow: [BoxShadow(color: AppColors.gold.withOpacity(0.25), blurRadius: 20, offset: const Offset(0, 8))],
                ),
                child: Row(
                  children: [
                    Icon(Icons.admin_panel_settings_rounded, color: AppColors.goldLight, size: Responsive.icon(40)),
                    SizedBox(width: Responsive.sp(16)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Admin Control Panel', style: GoogleFonts.playfairDisplay(color: AppColors.white, fontSize: Responsive.font(18), fontWeight: FontWeight.w700)),
                          Text('Manage submissions & participants', style: GoogleFonts.inter(color: AppColors.white70, fontSize: Responsive.font(13))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Responsive.sp(24)),
              SectionHeader(title: 'Overview', subtitle: 'Conference at a glance'),
              SizedBox(height: Responsive.sp(16)),
              Obx(() => GridView.count(
                crossAxisCount: Responsive.gridCrossAxisCount(mobile: 2, tablet: 4, desktop: 4),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: Responsive.sp(12),
                mainAxisSpacing: Responsive.sp(12),
                childAspectRatio: Responsive.isMobile ? 1.2 : 1.3,
                children: [
                  StatCard(value: users.length.toString(), label: 'Total Participants', icon: Icons.people_rounded, color: AppColors.accent),
                  StatCard(value: approved.toString(), label: 'Approved Users', icon: Icons.verified_rounded, color: AppColors.success),
                  StatCard(value: pending.toString(), label: 'Pending Approval', icon: Icons.hourglass_empty_rounded, color: AppColors.warning),
                  StatCard(value: sub.allAbstracts.length.toString(), label: 'Abstracts', icon: Icons.article_rounded, color: AppColors.accentLight),
                  StatCard(value: sub.allPreconfs.length.toString(), label: 'Pre-Conf Sessions', icon: Icons.event_rounded, color: AppColors.gold),
                  StatCard(value: sub.allWorkshops.length.toString(), label: 'Workshops', icon: Icons.build_circle_rounded, color: AppColors.success),
                  StatCard(value: sub.allCertificates.length.toString(), label: 'Certs Issued', icon: Icons.workspace_premium_rounded, color: const Color(0xFFAB47BC)),
                  StatCard(
                    value: [...sub.allAbstracts, ...sub.allPreconfs, ...sub.allWorkshops].where((s) => s.status == 'pending').length.toString(),
                    label: 'Pending Reviews',
                    icon: Icons.pending_actions_rounded,
                    color: AppColors.error,
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}