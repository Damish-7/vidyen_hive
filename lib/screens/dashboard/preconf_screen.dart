import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidyen_hive/controllers/submission_controler.dart';
import '../../utils/app_theme.dart';
import '../../utils/responsive.dart';
import '../../widgets/common_widgets.dart';
import 'submission_form_sheet.dart';

class PreconfScreen extends StatelessWidget {
  const PreconfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    final sub = Get.find<SubmissionController>();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          _buildHeader(sub),
          Expanded(
            child: Obx(() {
              final list = sub.preconfs;
              if (list.isEmpty) return _emptyState();
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth),
                  child: ListView.builder(
                    padding: EdgeInsets.all(Responsive.sp(20)),
                    itemCount: list.length,
                    itemBuilder: (_, i) => SubmissionCard(submission: list[i]),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(sub),
        backgroundColor: AppColors.gold,
        icon: Icon(Icons.add_rounded, color: AppColors.white, size: Responsive.icon(22)),
        label: Text('Submit Pre-Conf', style: GoogleFonts.inter(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: Responsive.font(14))),
      ),
    );
  }

  Widget _buildHeader(SubmissionController sub) {
    return Builder(builder: (context) {
      Responsive.init(context);
      return Padding(
        padding: EdgeInsets.fromLTRB(Responsive.sp(20), Responsive.sp(20), Responsive.sp(20), Responsive.sp(12)),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(Responsive.sp(8)),
                  decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(Responsive.radius(10))),
                  child: Icon(Icons.event_rounded, color: AppColors.gold, size: Responsive.icon(20)),
                ),
                SizedBox(width: Responsive.sp(12)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pre-Conference', style: GoogleFonts.playfairDisplay(color: AppColors.white, fontSize: Responsive.font(20), fontWeight: FontWeight.w700)),
                    Obx(() => Text('${sub.preconfs.length} submission${sub.preconfs.length == 1 ? '' : 's'}', style: GoogleFonts.inter(color: AppColors.white50, fontSize: Responsive.font(12)))),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _emptyState() => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.white10, shape: BoxShape.circle), child: const Icon(Icons.event_outlined, color: AppColors.white50, size: 40)),
          const SizedBox(height: 16),
          Text('No pre-conference submissions yet.\nTap the button below to register.', style: GoogleFonts.inter(color: AppColors.white50, fontSize: 14), textAlign: TextAlign.center),
        ]),
      );

  void _showForm(SubmissionController sub) {
    Get.bottomSheet(
      SubmissionFormSheet(
        type: 'preconf',
        title: 'Pre-Conf Session',
        categories: AppConstants.abstractCategories,
        onSubmit: ({required title, required description, coAuthors, keywords, category, filePath}) =>
            sub.submitPreconf(title: title, description: description, coAuthors: coAuthors, keywords: keywords, category: category, filePath: filePath),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}