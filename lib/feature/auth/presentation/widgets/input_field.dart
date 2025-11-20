import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final TextInputType keyboardType;
  final String? errorText;

  const InputField({
    super.key,
    required this.controller,
    required this.label,
    this.obscure = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.keyboardType = TextInputType.text,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final width = constraints.maxWidth;
        final height = MediaQuery.of(context).size.height;

        final double fontSize = width * 0.038;
        final double hintFontSize = width * 0.033;
        final double errorFontSize = width * 0.034;
        final double iconSize = width * 0.07;
        final double padV = height * 0.018;
        final double padH = width * 0.04;

        const labelColor = Color(0xFF2C2C2C);
        const hintColor = Color(0xFF9A9A9A);
        const borderColor = Color(0xFFE1E1E1);
        const focusColor = Color(0xFF1E88E5);
        const iconColor = Color(0xFF5A5A5A);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: labelColor,
              ),
            ),
            SizedBox(height: height * 0.008),

            TextField(
              controller: controller,
              obscureText: obscure,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: label,
                hintStyle: TextStyle(
                  color: hintColor,
                  fontSize: hintFontSize,
                ),
                prefixIcon: prefixIcon != null
                    ? Icon(prefixIcon, size: iconSize, color: iconColor)
                    : null,
                suffixIcon: suffixIcon != null
                    ? GestureDetector(
                        onTap: onSuffixTap,
                        child: Icon(suffixIcon, size: iconSize, color: iconColor),
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: focusColor, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.red),
                ),

                contentPadding: EdgeInsets.symmetric(
                  horizontal: padH,
                  vertical: padV,
                ),
              ),
              style: TextStyle(fontSize: fontSize),
            ),

            if (errorText != null && errorText!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: padH * 0.2, top: 4),
                child: Text(
                  errorText!,
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: errorFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
