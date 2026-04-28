import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/app_theme.dart';
import '../../utils/responsive.dart';
import 'admin_dashboard_tab.dart';
import 'admin_users_tab.dart';
import 'admin_submissions_tab.dart';
import 'admin_certificates_tab.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;
  final AuthController _auth = Get.find<AuthController>();

  final List<_NavItem> _navItems = [
    _NavItem('Dashboard', Icons.dashboard_outlined, Icons.dashboard_rounded),
    _NavItem('Users', Icons.people_outlined, Icons.people_rounded),
    _NavItem('Abstracts', Icons.article_outlined, Icons.article_rounded),
    _NavItem('Sessions', Icons.event_outlined, Icons.event_rounded),
    _NavItem('Certs', Icons.workspace_premium_outlined, Icons.workspace_premium_rounded),
  ];

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0: return const AdminDashboardTab();
      case 1: return const AdminUsersTab();
      case 2: return const AdminSubmissionsTab(type: 'abstract', label: 'Abstracts');
      case 3: return const AdminSubmissionsTab(type: 'preconf', label: 'Pre-Conference');
      case 4: return const AdminCertificatesTab();
      default: return const AdminDashboardTab();
    }
  }

  void _confirmLogout() {
    Get.dialog(AlertDialog(
      backgroundColor: AppColors.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Logout', style: GoogleFonts.playfairDisplay(color: AppColors.white, fontWeight: FontWeight.w700)),
      content: Text('Logout from admin portal?', style: GoogleFonts.inter(color: AppColors.white70)),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text('Cancel', style: GoogleFonts.inter(color: AppColors.white50))),
        ElevatedButton(
          onPressed: () => _auth.logout(),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          child: Text('Logout', style: GoogleFonts.inter(color: AppColors.white)),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: _buildAppBar(),
      body: Responsive.isMobile
          ? _buildBody()
          : Row(
              children: [
                _buildNavRail(),
                const VerticalDivider(color: AppColors.divider, width: 1),
                Expanded(child: _buildBody()),
              ],
            ),
      bottomNavigationBar: Responsive.isMobile ? _buildBottomNavBar() : null,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: Responsive.sp(8), vertical: Responsive.sp(3)),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.gold.withOpacity(0.3)),
            ),
            child: Text('ADMIN', style: GoogleFonts.inter(color: AppColors.gold, fontSize: Responsive.font(10), fontWeight: FontWeight.w700, letterSpacing: 1.5)),
          ),
          SizedBox(width: Responsive.sp(10)),
          Text('VID', style: GoogleFonts.playfairDisplay(color: AppColors.white, fontSize: Responsive.font(20), fontWeight: FontWeight.w700, letterSpacing: 2)),
          Text('YEN', style: GoogleFonts.playfairDisplay(color: AppColors.gold, fontSize: Responsive.font(20), fontWeight: FontWeight.w700, letterSpacing: 2)),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.logout_rounded, color: AppColors.white70, size: Responsive.icon(20)),
          onPressed: _confirmLogout,
        ),
      ],
    );
  }

  Widget _buildNavRail() {
    return NavigationRail(
      backgroundColor: AppColors.surface,
      selectedIndex: _selectedIndex,
      onDestinationSelected: (i) => setState(() => _selectedIndex = i),
      extended: Responsive.isDesktop,
      minWidth: 72,
      minExtendedWidth: 200,
      selectedIconTheme: const IconThemeData(color: AppColors.goldLight),
      unselectedIconTheme: const IconThemeData(color: AppColors.white50),
      selectedLabelTextStyle: GoogleFonts.inter(color: AppColors.goldLight, fontWeight: FontWeight.w600, fontSize: Responsive.font(13)),
      unselectedLabelTextStyle: GoogleFonts.inter(color: AppColors.white50, fontSize: Responsive.font(12)),
      indicatorColor: AppColors.gold.withOpacity(0.15),
      destinations: _navItems.map((item) => NavigationRailDestination(
        icon: Icon(item.icon),
        selectedIcon: Icon(item.activeIcon),
        label: Text(item.label),
      )).toList(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.white10))),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: List.generate(_navItems.length, (i) {
              final item = _navItems[i];
              final selected = i == _selectedIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIndex = i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 40, height: 36,
                        decoration: BoxDecoration(
                          color: selected ? AppColors.gold.withOpacity(0.15) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(selected ? item.activeIcon : item.icon, color: selected ? AppColors.goldLight : AppColors.white50, size: 22),
                      ),
                      const SizedBox(height: 2),
                      Text(item.label, style: GoogleFonts.inter(color: selected ? AppColors.goldLight : AppColors.white50, fontSize: 10, fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  const _NavItem(this.label, this.icon, this.activeIcon);
}