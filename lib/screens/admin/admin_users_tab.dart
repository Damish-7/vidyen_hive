import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_model.dart';
import '../../services/hive_service.dart';
import '../../utils/app_theme.dart';
import '../../utils/responsive.dart';
import '../../widgets/common_widgets.dart';

class AdminUsersTab extends StatefulWidget {
  const AdminUsersTab({super.key});

  @override
  State<AdminUsersTab> createState() => _AdminUsersTabState();
}

class _AdminUsersTabState extends State<AdminUsersTab> {
  String _filter = 'all';
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  List<UserModel> get _filteredUsers {
    var users = HiveService.getAllUsers();
    if (_filter != 'all') users = users.where((u) => u.status == _filter).toList();
    if (_searchQuery.isNotEmpty) {
      users = users.where((u) =>
          u.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          u.email.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Column(
      children: [
        // Header bar
        Padding(
          padding: EdgeInsets.fromLTRB(Responsive.sp(20), Responsive.sp(20), Responsive.sp(20), Responsive.sp(12)),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Participants', style: GoogleFonts.playfairDisplay(color: AppColors.white, fontSize: Responsive.font(20), fontWeight: FontWeight.w700)),
                  SizedBox(height: Responsive.sp(12)),
                  // On tablet/desktop search + filters in one row
                  if (Responsive.isMobile) ...[
                    _searchField(),
                    SizedBox(height: Responsive.sp(10)),
                    _filterChips(),
                  ] else
                    Row(
                      children: [
                        Expanded(child: _searchField()),
                        SizedBox(width: Responsive.sp(14)),
                        _filterChips(),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth),
              child: Responsive.isMobile
                  ? _listView()
                  : _gridView(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _searchField() => TextField(
        controller: _searchCtrl,
        style: GoogleFonts.inter(color: AppColors.white, fontSize: Responsive.font(14)),
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: const InputDecoration(
          hintText: 'Search by name or email...',
          prefixIcon: Icon(Icons.search_rounded, color: AppColors.white50, size: 20),
        ),
      );

  Widget _filterChips() => SingleChildScrollView(
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
      );

  Widget _listView() => ListView.builder(
        padding: EdgeInsets.fromLTRB(Responsive.sp(20), 0, Responsive.sp(20), Responsive.sp(20)),
        itemCount: _filteredUsers.length,
        itemBuilder: (_, i) => _UserCard(
          user: _filteredUsers[i],
          onStatusChange: (s) async { await HiveService.updateUserStatus(_filteredUsers[i].id, s); setState(() {}); },
        ),
      );

  Widget _gridView() => GridView.builder(
        padding: EdgeInsets.fromLTRB(Responsive.sp(20), 0, Responsive.sp(20), Responsive.sp(20)),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: Responsive.isDesktop ? 3 : 2,
          crossAxisSpacing: Responsive.sp(14),
          mainAxisSpacing: Responsive.sp(14),
          childAspectRatio: 1.05,
        ),
        itemCount: _filteredUsers.length,
        itemBuilder: (_, i) => _UserCard(
          user: _filteredUsers[i],
          onStatusChange: (s) async { await HiveService.updateUserStatus(_filteredUsers[i].id, s); setState(() {}); },
        ),
      );
}

class _UserCard extends StatelessWidget {
  final UserModel user;
  final Function(String) onStatusChange;
  const _UserCard({required this.user, required this.onStatusChange});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Container(
      margin: Responsive.isMobile ? EdgeInsets.only(bottom: Responsive.sp(12)) : EdgeInsets.zero,
      padding: EdgeInsets.all(Responsive.sp(14)),
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(Responsive.radius(16)), border: Border.all(color: AppColors.white10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: Responsive.sp(40), height: Responsive.sp(40),
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.accent.withOpacity(0.15), border: Border.all(color: AppColors.accent.withOpacity(0.3))),
                child: Center(child: Text(user.name[0].toUpperCase(), style: GoogleFonts.inter(color: AppColors.accentLight, fontWeight: FontWeight.w700, fontSize: Responsive.font(16)))),
              ),
              SizedBox(width: Responsive.sp(10)),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(user.name, style: GoogleFonts.inter(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: Responsive.font(14)), overflow: TextOverflow.ellipsis),
                  Text(user.email, style: GoogleFonts.inter(color: AppColors.white50, fontSize: Responsive.font(11)), overflow: TextOverflow.ellipsis),
                ]),
              ),
              StatusBadge(user.status),
            ],
          ),
          SizedBox(height: Responsive.sp(8)),
          Text(user.delegateType, style: GoogleFonts.inter(color: AppColors.accentLight, fontSize: Responsive.font(11), fontWeight: FontWeight.w500)),
          Text(user.institution, style: GoogleFonts.inter(color: AppColors.white50, fontSize: Responsive.font(11)), overflow: TextOverflow.ellipsis),
          SizedBox(height: Responsive.sp(2)),
          Text(user.regCode, style: GoogleFonts.inter(color: AppColors.white50, fontSize: Responsive.font(11), letterSpacing: 0.8)),
          const Spacer(),
          SizedBox(height: Responsive.sp(10)),
          Row(
            children: [
              Expanded(child: _actionBtn('Details', Icons.info_outline, AppColors.accent, () => _showDetails(context))),
              if (user.status != 'approved') ...[
                SizedBox(width: Responsive.sp(6)),
                Expanded(child: _actionBtn('Approve', Icons.check_circle_outline, AppColors.success, () => onStatusChange('approved'))),
              ],
              if (user.status != 'rejected') ...[
                SizedBox(width: Responsive.sp(6)),
                Expanded(child: _actionBtn('Reject', Icons.cancel_outlined, AppColors.error, () => onStatusChange('rejected'))),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Responsive.sp(7)),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(Responsive.radius(8)), border: Border.all(color: color.withOpacity(0.3))),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: color, size: Responsive.icon(13)),
          SizedBox(width: Responsive.sp(3)),
          Text(label, style: GoogleFonts.inter(color: color, fontSize: Responsive.font(11), fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    Get.dialog(AlertDialog(
      backgroundColor: AppColors.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(user.name, style: GoogleFonts.playfairDisplay(color: AppColors.white, fontWeight: FontWeight.w700)),
      content: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          _dRow('Email', user.email), _dRow('Phone', user.phone),
          _dRow('Reg Code', user.regCode), _dRow('Type', user.delegateType),
          _dRow('Designation', user.designation), _dRow('Institution', user.institution),
          _dRow('City', user.city), _dRow('Country', user.country), _dRow('Status', user.status),
        ]),
      ),
      actions: [TextButton(onPressed: () => Get.back(), child: Text('Close', style: GoogleFonts.inter(color: AppColors.accentLight)))],
    ));
  }

  Widget _dRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 100, child: Text(label, style: GoogleFonts.inter(color: AppColors.white50, fontSize: 13))),
          Expanded(child: Text(value, style: GoogleFonts.inter(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.w500))),
        ]),
      );
}