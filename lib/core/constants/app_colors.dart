import 'package:flutter/material.dart';

/// App color constants for consistent color usage
class AppColors {
  // Prevent instantiation
  AppColors._();

  // Primary colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFFD2D2D2);

  // Additional shades if needed
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF808080);

  // Semantic colors
  static const Color primary = black;
  static const Color onPrimary = white;
  static const Color secondary = grey;
  static const Color onSecondary = black;
  static const Color surface = white;
  static const Color onSurface = black;
  static const Color background = white;
  static const Color onBackground = black;

  // Status colors (keep minimal)
  static const Color error = Color(0xFFFF0000);
  static const Color onError = white;
  static const Color success = Color(0xFF00AA00);
  static const Color onSuccess = white;
}

/// Usage examples:
/// 
/// Container(
///   color: AppColors.black,
///   child: Text(
///     'White text',
///     style: TextStyle(color: AppColors.white),
///   ),
/// )
/// 
/// Card(
///   color: AppColors.white,
///   child: ListTile(
///     title: Text('Black text'),
///   ),
/// )
