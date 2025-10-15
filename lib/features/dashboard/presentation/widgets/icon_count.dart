import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IconCount extends StatelessWidget {
  final String iconPath;
  final int count;

  const IconCount({super.key, required this.iconPath, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          iconPath,
          width: 16,
          height: 16,
          cacheWidth: 16,
          cacheHeight: 16,
        ),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
