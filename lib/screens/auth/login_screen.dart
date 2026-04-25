import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vidyen_hive/utils/app_colors.dart';
import 'package:vidyen_hive/utils/responsive.dart';
import 'package:vidyen_hive/widgets/vidyen_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final r = context.r;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
          colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: r.screenPadding,
                vertical: 24),  
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: r.topSpacing),
                      _Branding(r: r),
                      SizedBox(height: 40),
                      SizedBox(
                        width: r.cardWidth,
                        //child: _LoginCard(controller: controller, r: r),
                  ),
                  const SizedBox(height: 24),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text("Don't have an account? ",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 201, 215, 234),
                            fontSize: r.sp(13), fontFamily: 'Sora')),
                    GestureDetector(
                      //onTap: () => Get.toNamed(AppRoutes.register),
                      child: Text('Register',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 210, 212, 217),
                              fontSize: r.sp(13),
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Sora')),
                    ),
                  ]),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Branding extends StatelessWidget {
  final Responsive r;
  const _Branding({required this.r});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: r.logoSize, height: r.logoSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
              colors: [AppColors.secondary, AppColors.accent]),
          boxShadow: [BoxShadow(
              color: AppColors.secondary.withOpacity(0.35),
              blurRadius: 28, spreadRadius: 4)],
        ),
        child: Center(
          child: Text('V',
              style: TextStyle(fontFamily: 'Sora',
                  fontSize: r.logoSize * 0.47,
                  fontWeight: FontWeight.w700,
                  color: AppColors.background)),
        ),
      ),
      const SizedBox(height: 20),
      ShaderMask(
        shaderCallback: (b) => AppColors.primaryGradient.createShader(b),
        child: Text('VIDYEN',
            style: TextStyle(fontFamily: 'Sora',
                fontSize: r.appNameSize,
                fontWeight: FontWeight.w700,
                color: Colors.white, letterSpacing: 8)),
      ),
      const SizedBox(height: 6),
      Text('Conference Portal',
          style: TextStyle(color: AppColors.textSecondary,
              fontSize: r.sp(13), fontFamily: 'Sora', letterSpacing: 1.5)),
    ]);
  }
}

// class _LoginCard extends StatelessWidget {
//   //final AuthController controller;
//   //final Responsive r;
//   //const _LoginCard({required this.controller, required this.r});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(r.cardPadding),
//       decoration: BoxDecoration(
//         gradient: AppColors.cardGradient,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: const Color(0xFF1E3A5F)),
//         boxShadow: [BoxShadow(
//             color: Colors.black.withOpacity(0.3),
//             blurRadius: 30, offset: const Offset(0, 10))],
//       ),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Text('Welcome Back',
//             style: TextStyle(fontFamily: 'Sora', fontSize: r.sp(22),
//                 fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
//         const SizedBox(height: 6),
//         Text('Sign in to access the portal',
//             style: TextStyle(color: AppColors.textSecondary,
//                 fontSize: r.sp(13), fontFamily: 'Sora')),
//         const SizedBox(height: 28),

//         VidyenTextField(
//           controller: controller.identifierController,
//           label: 'Email or Username',
//           hint: 'Enter your email or username',
//           prefixIcon: Icons.person_outline_rounded,
//           keyboardType: TextInputType.emailAddress,
//           onChanged: (_) => controller.clearError(),
//         ),
//         const SizedBox(height: 16),

//         Obx(() => VidyenTextField(
//               controller: controller.loginPasswordController,
//               label: 'Password', hint: 'Enter your password',
//               prefixIcon: Icons.lock_outline_rounded,
//               isPassword: true,
//               passwordVisible: controller.loginPasswordVisible.value,
//               onTogglePassword: controller.toggleLoginPasswordVisibility,
//               onChanged: (_) => controller.clearError(),
//             )),
//         const SizedBox(height: 8),

//         Align(
//           alignment: Alignment.centerRight,
//           child: TextButton(
//             onPressed: () {},
//             style: TextButton.styleFrom(
//                 padding: EdgeInsets.zero, minimumSize: Size.zero,
//                 tapTargetSize: MaterialTapTargetSize.shrinkWrap),
//             child: Text('Forgot Password?',
//                 style: TextStyle(color: AppColors.secondary,
//                     fontSize: r.sp(12), fontFamily: 'Sora')),
//           ),
//         ),
//         const SizedBox(height: 20),

//         // Error banner
//         Obx(() {
//           if (controller.errorMessage.value.isEmpty) return const SizedBox.shrink();
//           return Container(
//             margin: const EdgeInsets.only(bottom: 16),
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//             decoration: BoxDecoration(
//               color: AppColors.error.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(color: AppColors.error.withOpacity(0.3)),
//             ),
//             child: Row(children: [
//               const Icon(Icons.error_outline_rounded,
//                   color: AppColors.error, size: 16),
//               const SizedBox(width: 8),
//               Expanded(child: Text(controller.errorMessage.value,
//                   style: TextStyle(color: AppColors.error,
//                       fontSize: r.sp(12), fontFamily: 'Sora'))),
//             ]),
//           );
//         }),

        
//       ]),
//     );
//   }
// }