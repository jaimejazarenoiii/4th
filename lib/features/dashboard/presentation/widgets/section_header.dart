import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final IconData? actionIcon;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionPressed,
    this.actionIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // Border removed as requested
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
                height: 1,
              ),
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 4, right: 4, top: 4),
              child: Container(height: 5, color: AppColors.black),
            ),
          ),

          if (actionText != null && onActionPressed != null)
            Container(
              margin: const EdgeInsets.only(top: 4),
              child: TextButton(
                onPressed: onActionPressed,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      actionText!,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: AppColors.black,
                      ),
                    ),
                    if (actionIcon != null) ...[
                      const SizedBox(width: 4),
                      Icon(actionIcon, size: 20),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
