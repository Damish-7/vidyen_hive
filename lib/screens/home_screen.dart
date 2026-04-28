import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/auth_controller.dart';
import '../utils/app_theme.dart';
import '../utils/responsive.dart';
import 'dashboard/dashboard_home_tab.dart';
import 'dashboard/abstract_screen.dart';
import 'dashboard/preconf_screen.dart';
import 'dashboard/workshop_screen.dart';
import 'dashboard/certificate_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final AuthController _auth = Get.find<AuthController>();

  final List<_NavItem> _navItems = [
    _NavItem('Home', Icons.home_outlined, Icons.home_rounded),
    _NavItem('Abstract', Icons.article_outlined, Icons.article_rounded),
    _NavItem('Pre-Conf', Icons.event_outlined, Icons.event_rounded),
    _NavItem('Workshop', Icons.build_circle_outlined, Icons.build_circle_rounded),
    _NavItem('Certificates', Icons.workspace_premium_outlined, Icons.workspace_premium_rounded),
  ];

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0: return const DashboardHomeTab();
      case 1: return const AbstractScreen();
      case 2: return const PreconfScreen();
      case 3: return const WorkshopScreen();
      case 4: return const CertificateScreen();
      default: return const DashboardHomeTab();
    }
  }

  void _confirmLogout() {
    Get.dialog(AlertDialog(
      backgroundColor: AppColors.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Logout', style: GoogleFonts.playfairDisplay(color: AppColors.white, fontWeight: FontWeight.w700)),
      content: Text('Are you sure you want to logout?', style: GoogleFonts.inter(color: AppColors.white70)),
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
      bottomNavigationBar:
          Responsive.isMobile ? _buildBottomNavBar() : null,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: Responsive.isMobile
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          Text('VID', style: GoogleFonts.playfairDisplay(color: AppColors.white, fontSize: Responsive.font(22), fontWeight: FontWeight.w700, letterSpacing: 2)),
          Text('YEN', style: GoogleFonts.playfairDisplay(color: AppColors.gold, fontSize: Responsive.font(22), fontWeight: FontWeight.w700, letterSpacing: 2)),
        ],
      ),
      actions: [
        IconButton(
          icon: Obx(() {
            final name = _auth.currentUser.value?.name ?? '';
            return Container(
              width: Responsive.isMobile ? 34 : 40,
              height: Responsive.isMobile ? 34 : 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withOpacity(0.2),
                border: Border.all(color: AppColors.accent.withOpacity(0.3)),
              ),
              child: Center(
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'U',
                  style: GoogleFonts.inter(color: AppColors.accentLight, fontWeight: FontWeight.w700, fontSize: Responsive.font(15)),
                ),
              ),
            );
          }),
          onPressed: () => Get.to(() => const ProfileScreen()),
        ),
        IconButton(
          icon: Icon(Icons.logout_rounded, color: AppColors.white70, size: Responsive.icon(20)),
          onPressed: _confirmLogout,
        ),
      ],
    );
  }

  // ── TABLET / DESKTOP: Navigation Rail ────────────────────────
  Widget _buildNavRail() {
    return NavigationRail(
      backgroundColor: AppColors.surface,
      selectedIndex: _selectedIndex,
      onDestinationSelected: (i) => setState(() => _selectedIndex = i),
      extended: Responsive.isDesktop,
      minWidth: 72,
      minExtendedWidth: 200,
      selectedIconTheme: const IconThemeData(color: AppColors.accentLight),
      unselectedIconTheme: const IconThemeData(color: AppColors.white50),
      selectedLabelTextStyle: GoogleFonts.inter(color: AppColors.accentLight, fontWeight: FontWeight.w600, fontSize: Responsive.font(13)),
      unselectedLabelTextStyle: GoogleFonts.inter(color: AppColors.white50, fontSize: Responsive.font(12)),
      indicatorColor: AppColors.accent.withOpacity(0.15),
      destinations: _navItems.map((item) => NavigationRailDestination(
        icon: Icon(item.icon),
        selectedIcon: Icon(item.activeIcon),
        label: Text(item.label),
      )).toList(),
    );
  }

  // ── MOBILE: Bottom Nav Bar ────────────────────────────────────
  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.white10)),
      ),
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
                        width: 40,
                        height: 36,
                        decoration: BoxDecoration(
                          color: selected ? AppColors.accent.withOpacity(0.15) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          selected ? item.activeIcon : item.icon,
                          color: selected ? AppColors.accentLight : AppColors.white50,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: GoogleFonts.inter(
                          color: selected ? AppColors.accentLight : AppColors.white50,
                          fontSize: 10,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
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