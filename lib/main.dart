import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidyen_hive/controllers/submission_controler.dart';
import 'services/hive_service.dart';
import 'controllers/auth_controller.dart';
import 'utils/app_theme.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/admin/admin_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Disable Google Fonts from looking up fonts in the asset bundle.
  // This prevents 404 errors for fonts (e.g. Sora) that belong to
  // other projects and may linger in the Flutter web asset cache.
  // All fonts are fetched directly from fonts.google.com at runtime.
  GoogleFonts.config.allowRuntimeFetching = true;

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  // Initialize Hive
  await HiveService.init();

  runApp(const VidyenApp());
}

class VidyenApp extends StatelessWidget {
  const VidyenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      initialBinding: AppBindings(),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),
        GetPage(
          name: '/home',
          page: () => const HomeScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/admin-home',
          page: () => const AdminHomeScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(name: '/profile', page: () => const ProfileScreen()),
      ],
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<SubmissionController>(SubmissionController(), permanent: true);
  }
}

//admin login
// email: admin@vidyen.org
// passsword: Admin@123