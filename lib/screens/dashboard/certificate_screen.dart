import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidyen_hive/controllers/submission_controler.dart';
import '../../../models/certificate_model.dart';
import '../../../utils/app_theme.dart';
import '../../../utils/responsive.dart';

class CertificateScreen extends StatelessWidget {
  const CertificateScreen({super.key});

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
              final certs = sub.certificates;
              if (certs.isEmpty) {
                return Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: AppColors.white10, shape: BoxShape.circle),
                      child: const Icon(Icons.workspace_premium_outlined, color: AppColors.white50, size: 40),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No certificates issued yet.\nCertificates will appear here\nonce approved by admin.',
                      style: GoogleFonts.inter(color: AppColors.white50, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ]),
                );
              }
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth),
                  child: Responsive.isTablet || Responsive.isDesktop
                      ? GridView.builder(
                          padding: EdgeInsets.all(Responsive.sp(20)),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: Responsive.isDesktop ? 3 : 2,
                            crossAxisSpacing: Responsive.sp(14),
                            mainAxisSpacing: Responsive.sp(14),
                            childAspectRatio: 1.4,
                          ),
                          itemCount: certs.length,
                          itemBuilder: (_, i) => _CertCard(cert: certs[i]),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(Responsive.sp(20)),
                          itemCount: certs.length,
                          itemBuilder: (_, i) => Padding(
                            padding: EdgeInsets.only(bottom: Responsive.sp(14)),
                            child: _CertCard(cert: certs[i]),
                          ),
                        ),
                ),
              );
            }),
          ),
        ],
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
                  decoration: BoxDecoration(color: const Color(0xFFAB47BC).withOpacity(0.15), borderRadius: BorderRadius.circular(Responsive.radius(10))),
                  child: Icon(Icons.workspace_premium_rounded, color: const Color(0xFFAB47BC), size: Responsive.icon(20)),
                ),
                SizedBox(width: Responsive.sp(12)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Certificates', style: GoogleFonts.playfairDisplay(color: AppColors.white, fontSize: Responsive.font(20), fontWeight: FontWeight.w700)),
                    Obx(() => Text('${sub.certificates.length} certificate${sub.certificates.length == 1 ? '' : 's'}', style: GoogleFonts.inter(color: AppColors.white50, fontSize: Responsive.font(12)))),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _CertCard extends StatelessWidget {
  final CertificateModel cert;
  const _CertCard({required this.cert});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Container(
      padding: EdgeInsets.all(Responsive.sp(18)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF2C1A3E), Color(0xFF1A2A4A)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(Responsive.radius(20)),
        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: AppColors.gold.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.workspace_premium_rounded, color: AppColors.gold, size: Responsive.icon(26)),
              SizedBox(width: Responsive.sp(8)),
              Expanded(
                child: Text(cert.title, style: GoogleFonts.playfairDisplay(color: AppColors.white, fontSize: Responsive.font(14), fontWeight: FontWeight.w700), maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 8),
          _row(Icons.category_outlined, cert.type),
          SizedBox(height: Responsive.sp(4)),
          _row(Icons.person_outline, 'Issued by ${cert.issuedBy}'),
          SizedBox(height: Responsive.sp(4)),
          _row(Icons.calendar_today_outlined, _fmt(cert.issuedAt)),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String text) => Row(
        children: [
          Icon(icon, size: 13, color: AppColors.gold.withOpacity(0.7)),
          const SizedBox(width: 6),
          Expanded(child: Text(text, style: GoogleFonts.inter(color: AppColors.white70, fontSize: 12), overflow: TextOverflow.ellipsis)),
        ],
      );

  String _fmt(DateTime dt) {
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${dt.day} ${m[dt.month - 1]} ${dt.year}';
  }
}