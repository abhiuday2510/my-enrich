import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final IconData? icon;
  final TextEditingController? controller;

  // ✨ New (form-friendly) props
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final bool enabled;
  final int? maxLines; // ignored when obscureText = true
  final int? minLines;
  final Widget? suffixIcon;
  final AutovalidateMode? autovalidateMode;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    this.icon,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.onChanged,
    this.focusNode,
    this.enabled = true,
    this.maxLines,
    this.minLines,
    this.suffixIcon,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    // If obscured, force single line
    final effectiveMaxLines = obscureText ? 1 : (maxLines ?? 1);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(w * 0.035),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        validator: validator,                // ✅ enables form validation
        autovalidateMode: autovalidateMode,  // e.g., AutovalidateMode.onUserInteraction
        maxLines: effectiveMaxLines,
        minLines: minLines,
        style: TextStyle(fontSize: w * 0.04),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: h * 0.02,
            horizontal: w * 0.04,
          ),
          prefixIcon: icon != null
              ? Icon(icon, color: theme.colorScheme.primary)
              : null,
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(w * 0.035),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(w * 0.035),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(w * 0.035),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(w * 0.035),
            borderSide: BorderSide(color: theme.colorScheme.error, width: 1.2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(w * 0.035),
            borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
          ),
          filled: true,
          fillColor: theme.colorScheme.surface,
        ),
      ),
    );
  }
}
