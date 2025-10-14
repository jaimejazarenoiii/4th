import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../../core/navigation/navigation_service.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/constants/asset_constants.dart';
import '../../core/constants/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _pulseController;
  
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoRotateAnimation;
  
  late Animation<double> _appNameSlideAnimation;
  late Animation<double> _appNameFadeAnimation;
  
  late Animation<double> _taglineSlideAnimation;
  late Animation<double> _taglineFadeAnimation;
  
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Pulse animation controller
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Logo animations
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.elasticOut,
      ),
    );

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _logoRotateAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    // App name animations
    _appNameSlideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _appNameFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Tagline animations
    _taglineSlideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.3, 0.9, curve: Curves.easeOut),
      ),
    );

    _taglineFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
      ),
    );

    // Pulse animation
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    // Start logo animation
    await _logoController.forward();
    
    // Start text animation shortly after logo
    await Future.delayed(const Duration(milliseconds: 200));
    await _textController.forward();
    
    // Start pulse animation
    _pulseController.repeat(reverse: true);
    
    // Wait for pulse to complete at least one cycle plus 1 second
    await Future.delayed(const Duration(milliseconds: 2000 + 1000));
    
    // Animation complete - signal that we're ready to navigate
    // The AppWrapper will handle the actual navigation based on auth state
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: Listenable.merge([_logoController, _textController, _pulseController]),
          builder: (context, child) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  
                  // Logo with multiple animations
                  Transform.scale(
                    scale: _logoScaleAnimation.value * _pulseAnimation.value,
                    child: Transform.rotate(
                      angle: _logoRotateAnimation.value,
                      child: Opacity(
                        opacity: _logoFadeAnimation.value,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.width * 0.8,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              AssetConstants.logo,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // App name with slide and fade animation
                  Transform.translate(
                    offset: Offset(0, _appNameSlideAnimation.value),
                    child: Opacity(
                      opacity: _appNameFadeAnimation.value,
                      child: Text(
                        '4th',
                        style: GoogleFonts.outfit(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Tagline at the bottom with slide and fade animation
                  Transform.translate(
                    offset: Offset(0, _taglineSlideAnimation.value),
                    child: Opacity(
                      opacity: _taglineFadeAnimation.value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Column(
                          children: [
                            // Small divider line above tagline
                            Container(
                              width: 60,
                              height: 2,
                              decoration: BoxDecoration(
                                color: AppColors.black,
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Track what matters',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
