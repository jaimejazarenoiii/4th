import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/asset_constants.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/animated_page_wrapper.dart';
import '../auth/presentation/widgets/auth_bottom_sheet.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  void _showSignInBottomSheet(BuildContext context) {
    showAuthBottomSheet(context, true);
  }

  void _showSignUpBottomSheet(BuildContext context) {
    showAuthBottomSheet(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        left: false,
        right: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // Top spacing
              const SizedBox(height: 40),

              // Main illustration with fade and slide
              AnimatedFadeSlide(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 100),
                offsetY: 40,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AssetConstants.splashImage),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Title with fade and slide
              AnimatedFadeSlide(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 200),
                offsetY: 30,
                child: Text(
                  'Your Things,\nPerfectly Organized.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                    height: 1.2,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Subtitle with fade and slide
              AnimatedFadeSlide(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 300),
                offsetY: 25,
                child: Text(
                  'The simple, beautiful way to track your things.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: AppColors.black,
                    height: 1.4,
                  ),
                ),
              ),

              const Spacer(),

              // Buttons with fade and slide
              AnimatedFadeSlide(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 400),
                offsetY: 20,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Row(
                    children: [
                      // Sign in button
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () => _showSignInBottomSheet(context),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: AppColors.black,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: Text(
                              'Sign in',
                              style: GoogleFonts.outfit(
                                color: AppColors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Sign up button
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: FilledButton(
                            onPressed: () => _showSignUpBottomSheet(context),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: Text(
                              'Sign up',
                              style: GoogleFonts.outfit(
                                color: AppColors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
