import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/asset_constants.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/navigation/navigation_service.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class AuthBottomSheet extends StatefulWidget {
  final bool isSignIn;

  const AuthBottomSheet({super.key, required this.isSignIn});

  @override
  State<AuthBottomSheet> createState() => _AuthBottomSheetState();
}

class _AuthBottomSheetState extends State<AuthBottomSheet> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  String? _validateFields() {
    // Validate email
    if (_emailController.text.isEmpty) {
      return 'Email is required';
    } else if (!_isValidEmail(_emailController.text)) {
      return 'Please enter a valid email address';
    }

    // Validate password
    if (_passwordController.text.isEmpty) {
      return 'Password is required';
    } else if (_passwordController.text.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null; // No errors
  }

  void _showValidationError(String message) {
    final overlay = Overlay.of(context);

    late AnimationController controller;
    late Animation<double> animation;
    OverlayEntry? entry;

    controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      reverseDuration: const Duration(milliseconds: 250),
      vsync: Navigator.of(context),
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    entry = OverlayEntry(
      builder: (ctx) => Positioned(
        top: MediaQuery.of(context).viewInsets.top + 50,
        left: 24,
        right: 24,
        child: Material(
          color: Colors.transparent,
          child: FadeTransition(
            opacity: animation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                message,
                style: GoogleFonts.outfit(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(entry);

    controller.forward();

    Future.delayed(const Duration(seconds: 2), () async {
      await controller.reverse();
      entry?.remove();
      controller.dispose();
    });
  }

  void _handleSubmit() {
    final validationError = _validateFields();
    if (validationError != null) {
      _showValidationError(validationError);
      return;
    }

    if (widget.isSignIn) {
      context.read<AuthBloc>().add(
        SignInEvent(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    } else {
      context.read<AuthBloc>().add(
        SignUpEvent(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          NavigationService.showSuccess('Signed in successfully!');
          Navigator.pop(context);
          NavigationService.replaceWith(AppRoutes.dashboard);
        } else if (state is AuthError) {
          // Animated error overlay using a FadeTransition (with AnimationController and OverlayEntry)
          _showValidationError(state.message);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 24.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      widget.isSignIn ? 'Sign in' : 'Sign up',
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),

                    // Horizontal divider line in the middle
                    Expanded(
                      child: Container(
                        height: 5,
                        color: AppColors.black,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),

                    // Logo
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Image.asset(
                        AssetConstants.logo,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),

              // Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    // Email field
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: Icons.email_outlined,
                    ),

                    const SizedBox(height: 16),

                    // Password field
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                    ),

                    if (widget.isSignIn) ...[
                      const SizedBox(height: 12),

                      // Forgot password link
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Handle forgot password
                            Navigator.pop(context);
                            // TODO: Implement forgot password flow
                          },
                          child: Text(
                            'Forgot password?',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              color: AppColors.black,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],

                    SizedBox(height: widget.isSignIn ? 16 : 32),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: state is AuthLoading
                                ? null
                                : _handleSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.black,
                              foregroundColor: AppColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: state is AuthLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    widget.isSignIn ? 'Sign in' : 'Sign up',
                                    style: GoogleFonts.outfit(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData prefixIcon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.outfit(color: AppColors.grey, fontSize: 16),
            prefixIcon: Icon(prefixIcon, color: AppColors.grey, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.grey, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.grey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.black, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            filled: true,
            fillColor: AppColors.white,
          ),
          style: GoogleFonts.outfit(fontSize: 16, color: AppColors.black),
        ),
      ],
    );
  }
}

/// Helper function to show auth bottom sheet
void showAuthBottomSheet(BuildContext context, bool isSignIn) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => AuthBottomSheet(isSignIn: isSignIn),
  );
}
