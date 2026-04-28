import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidyen_hive/controllers/submission_controler.dart';
import '../../models/submission_model.dart';
import '../../utils/app_theme.dart';
import '../../utils/responsive.dart';
import '../../widgets/common_widgets.dart';

class AdminSubmissionsTab extends StatefulWidget {
  final String type;
  final String label;
  const AdminSubmissionsTab({super.key, required this.type, required this.label});

  @override
  State<AdminSubmissionsTab> createState() => _AdminSubmissionsTabState();
}

class _AdminSubmissionsTabState extends State<AdminSubmissionsTab> {
  String _filter = 'all';

  List<SubmissionModel> _getList(SubmissionController sub) {
    final list = widget.type == 'abstract' ? sub.allAbstracts : widget.type == 'preconf' ? sub.allPreconfs : sub.allWorkshops;
    if (_filter == 'all') return list;
    return list.where((s) => s.status == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    final sub = Get.find<SubmissionController>();
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(Responsive.sp(20), Responsive.sp(20), Responsive.sp(20), Responsive.sp(12)),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.label, style: GoogleFonts.playfairDisplay(color: AppColors.white, fontSize: Responsive.font(20), fontWeight: FontWeight.w700)),
                  SizedBox(height: Responsive.sp(12)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['all', 'pending', 'approved', 'rejected'].map((v) {
                        final label = v[0].toUpperCase() + v.substring(1);
                        final selected = _filter == v;
                        return Padding(
                          padding: EdgeInsets.only(right: Responsive.sp(8)),
                          child: GestureDetector(
                            onTap: () => setState(() => _filter = v),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: Responsive.sp(14), vertical: Responsive.sp(7)),
                              decoration: BoxDecoration(
                                color: selected ? AppColors.gold.withOpacity(0.2) : AppColors.white10,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: selected ? AppColors.gold.withOpacity(0.5) : AppColors.white20),
                              ),
                              child: Text(label, style: GoogleFonts.inter(color: selected ? AppColors.goldLight : AppColors.white70, fontSize: Responsive.font(13), fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            final list = _getList(sub);
            if (list.isEmpty) {
              return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.inbox_rounded, color: AppColors.white50, size: 48),
                SizedBox(height: Responsive.sp(12)),
                Text('No submissions found', style: GoogleFonts.inter(color: AppColors.white50, fontSize: Responsive.font(14))),
              ]));
            }
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth),
                child: Responsive.isMobile
                    ? ListView.builder(
                        padding: EdgeInsets.fromLTRB(Responsive.sp(20), 0, Responsive.sp(20), Responsive.sp(20)),
                        itemCount: list.length,
                        itemBuilder: (_, i) => _AdminSubmissionCard(
                          submission: list[i],
                          onAction: (status, remark) async { await sub.updateStatus(list[i].id, status, remark); setState(() {}); },
                        ),
                      )
                    : GridView.builder(
                        padding: EdgeInsets.fromLTRB(Responsive.sp(20), 0, Responsive.sp(20), Responsive.sp(20)),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: Responsive.isDesktop ? 3 : 2,
                          crossAxisSpacing: Responsive.sp(14),
                          mainAxisSpacing: Responsive.sp(14),
                          childAspectRatio: 1.15,
                        ),
                        itemCount: list.length,
                        itemBuilder: (_, i) => _AdminSubmissionCard(
                          submission: list[i],
                          onAction: (status, remark) async { await sub.updateStatus(list[i].id, status, remark); setState(() {}); },
                        ),
                      ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _AdminSubmissionCard extends StatelessWidget {
  final SubmissionModel submission;
  final Future<void> Function(String status, String? remark) onAction;
  const _AdminSubmissionCard({required this.submission, required this.onAction});

  void _showReview(BuildContext context) {
    final remarkCtrl = TextEditingController(text: submission.adminRemark ?? '');
    String selectedStatus = submission.status;
    Get.dialog(StatefulBuilder(builder: (_, setState) => AlertDialog(
      backgroundColor: AppColors.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Review Submission', style: GoogleFonts.playfairDisplay(color: AppColors.white, fontWeight: FontWeight.w700, fontSize: 18)),
        Text(submission.title, style: GoogleFonts.inter(color: AppColors.white50, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
      ]),
      content: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.white10, borderRadius: BorderRadius.circular(10)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _iRow(Icons.person_outline, 'Submitted by', submission.userName),
              if (submission.category != null) _iRow(Icons.category_outlined, 'Category', submission.category!),
              if (submission.coAuthors != null && submission.coAuthors!.isNotEmpty)
                _iRow(Icons.group_outlined, 'Co-Authors', submission.coAuthors!),
            ]),
          ),
          const SizedBox(height: 12),
          Text('Description', style: GoogleFonts.inter(color: AppColors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(submission.description, style: GoogleFonts.inter(color: AppColors.white, fontSize: 13)),
          const SizedBox(height: 14),
          Text('Decision', style: GoogleFonts.inter(color: AppColors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: _statusOpt('approve', 'Approve', AppColors.success, selectedStatus, (v) => setState(() => selectedStatus = v))),
            const SizedBox(width: 8),
            Expanded(child: _statusOpt('rejected', 'Reject', AppColors.error, selectedStatus, (v) => setState(() => selectedStatus = v))),
            const SizedBox(width: 8),
            Expanded(child: _statusOpt('pending', 'Pending', AppColors.warning, selectedStatus, (v) => setState(() => selectedStatus = v))),
          ]),
          const SizedBox(height: 14),
          Text('Remarks (optional)', style: GoogleFonts.inter(color: AppColors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(controller: remarkCtrl, style: GoogleFonts.inter(color: AppColors.white, fontSize: 13), maxLines: 3, decoration: const InputDecoration(hintText: 'Add feedback...')),
        ]),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text('Cancel', style: GoogleFonts.inter(color: AppColors.white50))),
        ElevatedButton(
          onPressed: () async {
            Get.back();
            final status = selectedStatus == 'approve' ? 'approved' : selectedStatus;
            await onAction(status, remarkCtrl.text.trim().isEmpty ? null : remarkCtrl.text.trim());
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
          child: Text('Save', style: GoogleFonts.inter(color: AppColors.white, fontWeight: FontWeight.w600)),
        ),
      ],
    )));
  }

  Widget _iRow(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 13, color: AppColors.white50),
          const SizedBox(width: 5),
          Text('$label: ', style: GoogleFonts.inter(color: AppColors.white50, fontSize: 12)),
          Expanded(child: Text(value, style: GoogleFonts.inter(color: AppColors.white70, fontSize: 12))),
        ]),
      );

  Widget _statusOpt(String value, String label, Color color, String selected, Function(String) onSelect) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onSelect(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : AppColors.white10,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? color.withOpacity(0.5) : AppColors.white20),
        ),
        child: Center(child: Text(label, style: GoogleFonts.inter(color: isSelected ? color : AppColors.white50, fontSize: 12, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return GestureDetector(
      onTap: () => _showReview(context),
      child: Container(
        margin: Responsive.isMobile ? EdgeInsets.only(bottom: Responsive.sp(12)) : EdgeInsets.zero,
        padding: EdgeInsets.all(Responsive.sp(14)),
        decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(Responsive.radius(16)), border: Border.all(color: AppColors.white10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(child: Text(submission.title, style: GoogleFonts.inter(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: Responsive.font(14)), maxLines: 2, overflow: TextOverflow.ellipsis)),
              SizedBox(width: Responsive.sp(8)),
              StatusBadge(submission.status),
            ]),
            SizedBox(height: Responsive.sp(6)),
            Row(children: [
              Icon(Icons.person_outline, size: Responsive.icon(12), color: AppColors.white50),
              SizedBox(width: Responsive.sp(4)),
              Expanded(child: Text(submission.userName, style: GoogleFonts.inter(color: AppColors.white50, fontSize: Responsive.font(12)), overflow: TextOverflow.ellipsis)),
            ]),
            if (submission.category != null) ...[
              SizedBox(height: Responsive.sp(4)),
              Text(submission.category!, style: GoogleFonts.inter(color: AppColors.accentLight, fontSize: Responsive.font(11))),
            ],
            SizedBox(height: Responsive.sp(6)),
            Text(submission.description, style: GoogleFonts.inter(color: AppColors.white50, fontSize: Responsive.font(12)), maxLines: 2, overflow: TextOverflow.ellipsis),
            const Spacer(),
            SizedBox(height: Responsive.sp(8)),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(_fmt(submission.submittedAt), style: GoogleFonts.inter(color: AppColors.white50, fontSize: Responsive.font(11))),
              Container(
                padding: EdgeInsets.symmetric(horizontal: Responsive.sp(8), vertical: Responsive.sp(4)),
                decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.15), borderRadius: BorderRadius.circular(Responsive.radius(7))),
                child: Text('Tap to Review', style: GoogleFonts.inter(color: AppColors.accentLight, fontSize: Responsive.font(11), fontWeight: FontWeight.w500)),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime dt) {
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${dt.day} ${m[dt.month - 1]} ${dt.year}';
  }
}