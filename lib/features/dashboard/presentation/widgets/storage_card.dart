import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/asset_constants.dart';
import 'icon_count.dart';

class StorageCard extends StatelessWidget {
  final String name;
  final String description;
  final int totalStorages;
  final int totalItems;
  final VoidCallback onTap;

  const StorageCard({
    super.key,
    required this.name,
    required this.description,
    required this.totalStorages,
    required this.totalItems,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppColors.white,
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              AssetConstants.storageDefaultImage,
              height: 176,
              width: double.infinity,
              fit: BoxFit.cover,
              cacheHeight: 176, // Cache at display size for better memory usage
              gaplessPlayback: true, // Smoother image transitions
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // If the name is too long, wrap to multi-line, measurements here are rough
                  Expanded(
                    child: Text(
                      name,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconCount(
                        iconPath: AssetConstants.storageIcon,
                        count: totalStorages,
                      ),
                      const SizedBox(width: 8),
                      IconCount(
                        iconPath: AssetConstants.itemIcon,
                        count: totalItems,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Text(
                description,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
