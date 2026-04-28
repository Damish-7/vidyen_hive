import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidyen_hive/controllers/submission_controler.dart';
import '../../models/certificate_model.dart';
import '../../models/user_model.dart';
import '../../services/hive_service.dart';
import '../../utils/app_theme.dart';
import '../../utils/responsive.dart';
import '../../widgets/common_widgets.dart';

class AdminCertificatesTab extends StatefulWidget {
  const AdminCertificatesTab({super.key});

  @override
  State<AdminCertificatesTab> createState() => _AdminCertificatesTabState();
}

class _AdminCertificatesTabState extends State<AdminCertificatesTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    final sub = Get.find<SubmissionController>();
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(Responsive.sp(20), Responsive.sp(20), Responsive.sp(20), 0),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Certificates', style: GoogleFonts.playfairDisplay(color: AppColors.white, fontSize: Responsive.font(20), fontWeight: FontWeight.w700)),
                  SizedBox(height: Responsive.sp(14)),
                  Container(
                    decoration: BoxDecoration(color: AppColors.white10, borderRadius: BorderRadius.circular(Responsive.radius(12))),
                    child: TabBar(
                      controller: _tabCtrl,
                      indicator: BoxDecoration(color: AppColors.gold.withOpacity(0.2), borderRadius: BorderRadius.circular(Responsive.radius(10)), border: Border.all(color: AppColors.gold.withOpacity(0.4))),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelColor: AppColors.goldLight,
                      unselectedLabelColor: AppColors.white50,
                      labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: Responsive.font(13)),
                      unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: Responsive.font(13)),
                      tabs: const [Tab(text: 'Issue Certificate'), Tab(text: 'Issued')],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabCtrl,
            children: [
              _IssueCertTab(sub: sub, onIssued: () => setState(() {})),
              _IssuedCertsTab(sub: sub),
            ],
          ),
        ),
      ],
    );
  }
}

// ── ISSUE CERT ────────────────────────────────────────────────────────────────
class _IssueCertTab extends StatefulWidget {
  final SubmissionController sub;
  final VoidCallback onIssued;
  const _IssueCertTab({required this.sub, required this.onIssued});

  @override
  State<_IssueCertTab> createState() => _IssueCertTabState();
}

class _IssueCertTabState extends State<_IssueCertTab> {
  UserModel? _selectedUser;
  String _certType = 'Participation';
  final _titleCtrl = TextEditingController();
  bool _isLoading = false;

  final List<String> _certTypes = ['Participation', 'Presentation', 'Workshop Completion', 'Best Paper Award', 'Speaker', 'Moderator'];
  List<UserModel> get _approvedUsers => HiveService.getAllUsers().where((u) => u.status == 'approved').toList();

  Future<void> _issue() async {
    if (_selectedUser == null) { Get.snackbar('Select User', 'Please select a participant', backgroundColor: AppColors.error.withOpacity(0.9), colorText: AppColors.white, snackPosition: SnackPosition.BOTTOM); return; }
    if (_titleCtrl.text.trim().isEmpty) { Get.snackbar('Enter Title', 'Please enter certificate title', backgroundColor: AppColors.error.withOpacity(0.9), colorText: AppColors.white, snackPosition: SnackPosition.BOTTOM); return; }
    setState(() => _isLoading = true);
    try {
      final name = _selectedUser!.name;
      await widget.sub.issueCertificate(userId: _selectedUser!.id, userName: name, title: _titleCtrl.text.trim(), type: _certType);
      widget.onIssued();
      setState(() { _selectedUser = null; _titleCtrl.clear(); });
      Get.snackbar('Certificate Issued!', 'Certificate issued to $name', backgroundColor: AppColors.success.withOpacity(0.9), colorText: AppColors.white, snackPosition: SnackPosition.BOTTOM, borderRadius: 12, margin: const EdgeInsets.all(16), icon: const Icon(Icons.workspace_premium_rounded, color: AppColors.white));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    final users = _approvedUsers;
    return SingleChildScrollView(
      padding: EdgeInsets.all(Responsive.sp(20)),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: users.isEmpty
              ? Container(
                  padding: EdgeInsets.all(Responsive.sp(16)),
                  decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(Responsive.radius(12)), border: Border.all(color: AppColors.warning.withOpacity(0.3))),
                  child: Row(children: [
                    const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 18),
                    SizedBox(width: Responsive.sp(10)),
                    Expanded(child: Text('No approved participants yet. Approve users first.', style: GoogleFonts.inter(color: AppColors.warning, fontSize: Responsive.font(13)))),
                  ]),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // On tablet/desktop: two columns
                    if (Responsive.isMobile) ...[
                      _label('Select Participant'),
                      SizedBox(height: Responsive.sp(8)),
                      _userDropdown(users),
                      SizedBox(height: Responsive.sp(16)),
                      _label('Certificate Title'),
                      SizedBox(height: Responsive.sp(8)),
                      _titleField(),
                      SizedBox(height: Responsive.sp(16)),
                      _label('Certificate Type'),
                      SizedBox(height: Responsive.sp(8)),
                      _typeDropdown(),
                    ] else
                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          _label('Select Participant'),
                          SizedBox(height: Responsive.sp(8)),
                          _userDropdown(users),
                          SizedBox(height: Responsive.sp(14)),
                          _label('Certificate Type'),
                          SizedBox(height: Responsive.sp(8)),
                          _typeDropdown(),
                        ])),
                        SizedBox(width: Responsive.sp(16)),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          _label('Certificate Title'),
                          SizedBox(height: Responsive.sp(8)),
                          _titleField(),
                        ])),
                      ]),
                    if (_selectedUser != null) ...[
                      SizedBox(height: Responsive.sp(12)),
                      Container(
                        padding: EdgeInsets.all(Responsive.sp(12)),
                        decoration: BoxDecoration(color: AppColors.success.withOpacity(0.08), borderRadius: BorderRadius.circular(Responsive.radius(10)), border: Border.all(color: AppColors.success.withOpacity(0.2))),
                        child: Row(children: [
                          Icon(Icons.person_rounded, color: AppColors.success, size: Responsive.icon(16)),
                          SizedBox(width: Responsive.sp(8)),
                          Expanded(child: Text('${_selectedUser!.name} · ${_selectedUser!.designation} · ${_selectedUser!.institution}', style: GoogleFonts.inter(color: AppColors.success, fontSize: Responsive.font(12)))),
                        ]),
                      ),
                    ],
                    SizedBox(height: Responsive.sp(24)),
                    GradientButton(label: 'Issue Certificate', icon: Icons.workspace_premium_rounded, onTap: _issue, isLoading: _isLoading),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text, style: GoogleFonts.inter(color: AppColors.white70, fontSize: Responsive.font(12), fontWeight: FontWeight.w600));

  Widget _userDropdown(List<UserModel> users) => Container(
        padding: EdgeInsets.symmetric(horizontal: Responsive.sp(14), vertical: Responsive.sp(4)),
        decoration: BoxDecoration(color: AppColors.white10, borderRadius: BorderRadius.circular(Responsive.radius(12)), border: Border.all(color: AppColors.white20)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<UserModel>(
            value: _selectedUser,
            isExpanded: true,
            dropdownColor: AppColors.cardBg,
            style: GoogleFonts.inter(color: AppColors.white, fontSize: Responsive.font(14)),
            icon: const Icon(Icons.expand_more_rounded, color: AppColors.white50),
            hint: Text('Choose participant...', style: GoogleFonts.inter(color: AppColors.white50, fontSize: Responsive.font(14))),
            items: users.map((u) => DropdownMenuItem(value: u, child: Text('${u.name} (${u.regCode})'))).toList(),
            onChanged: (v) => setState(() => _selectedUser = v),
          ),
        ),
      );

  Widget _titleField() => TextField(
        controller: _titleCtrl,
        style: GoogleFonts.inter(color: AppColors.white, fontSize: Responsive.font(14)),
        maxLines: Responsive.isMobile ? 1 : 3,
        decoration: InputDecoration(
          hintText: 'e.g. Certificate of Participation - VIDYEN 2025',
          prefixIcon: Icon(Icons.workspace_premium_outlined, color: AppColors.white50, size: Responsive.icon(20)),
        ),
      );

  Widget _typeDropdown() => Container(
        padding: EdgeInsets.symmetric(horizontal: Responsive.sp(14), vertical: Responsive.sp(4)),
        decoration: BoxDecoration(color: AppColors.white10, borderRadius: BorderRadius.circular(Responsive.radius(12)), border: Border.all(color: AppColors.white20)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _certType,
            isExpanded: true,
            dropdownColor: AppColors.cardBg,
            style: GoogleFonts.inter(color: AppColors.white, fontSize: Responsive.font(14)),
            icon: const Icon(Icons.expand_more_rounded, color: AppColors.white50),
            items: _certTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
            onChanged: (v) => setState(() => _certType = v!),
          ),
        ),
      );
}

// ── ISSUED CERTS ──────────────────────────────────────────────────────────────
class _IssuedCertsTab extends StatelessWidget {
  final SubmissionController sub;
  const _IssuedCertsTab({required this.sub});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Obx(() {
      final certs = sub.allCertificates;
      if (certs.isEmpty) return Center(child: Text('No certificates issued yet.', style: GoogleFonts.inter(color: AppColors.white50, fontSize: Responsive.font(14))));
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: Responsive.isMobile
              ? ListView.builder(
                  padding: EdgeInsets.all(Responsive.sp(20)),
                  itemCount: certs.length,
                  itemBuilder: (_, i) => _CertRow(cert: certs[i]),
                )
              : GridView.builder(
                  padding: EdgeInsets.all(Responsive.sp(20)),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: Responsive.isDesktop ? 3 : 2,
                    crossAxisSpacing: Responsive.sp(14),
                    mainAxisSpacing: Responsive.sp(14),
                    childAspectRatio: 2.2,
                  ),
                  itemCount: certs.length,
                  itemBuilder: (_, i) => _CertRow(cert: certs[i]),
                ),
        ),
      );
    });
  }
}

class _CertRow extends StatelessWidget {
  final CertificateModel cert;
  const _CertRow({required this.cert});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Container(
      margin: Responsive.isMobile ? EdgeInsets.only(bottom: Responsive.sp(12)) : EdgeInsets.zero,
      padding: EdgeInsets.all(Responsive.sp(14)),
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(Responsive.radius(16)), border: Border.all(color: AppColors.gold.withOpacity(0.2))),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(Responsive.sp(10)),
            decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.12), borderRadius: BorderRadius.circular(Responsive.radius(12))),
            child: Icon(Icons.workspace_premium_rounded, color: AppColors.gold, size: Responsive.icon(22)),
          ),
          SizedBox(width: Responsive.sp(12)),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(cert.userName, style: GoogleFonts.inter(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: Responsive.font(14))),
              Text(cert.title, style: GoogleFonts.inter(color: AppColors.white70, fontSize: Responsive.font(12)), overflow: TextOverflow.ellipsis),
              SizedBox(height: Responsive.sp(4)),
              Row(children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Responsive.sp(7), vertical: Responsive.sp(2)),
                  decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                  child: Text(cert.type, style: GoogleFonts.inter(color: AppColors.goldLight, fontSize: Responsive.font(11))),
                ),
                SizedBox(width: Responsive.sp(8)),
                Text(_fmt(cert.issuedAt), style: GoogleFonts.inter(color: AppColors.white50, fontSize: Responsive.font(11))),
              ]),
            ]),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime dt) {
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${dt.day} ${m[dt.month - 1]} ${dt.year}';
  }
}