// lib/widgets/vidyen_text_field.dart
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class VidyenTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final bool isPassword;
  final bool passwordVisible;
  final VoidCallback? onTogglePassword;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;

  const VidyenTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.isPassword = false,
    this.passwordVisible = false,
    this.onTogglePassword,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: const TextStyle(
              fontFamily: 'Sora', fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary, letterSpacing: 0.3)),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        obscureText: isPassword && !passwordVisible,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: const TextStyle(
            fontFamily: 'Sora', fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 12),
            child: Icon(prefixIcon, color: AppColors.textMuted, size: 20),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          suffixIcon: isPassword
              ? GestureDetector(
                  onTap: onTogglePassword,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(
                      passwordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textMuted, size: 20),
                  ))
              : null,
          suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        ),
      ),
    ]);
  }
}