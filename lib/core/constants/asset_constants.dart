/// Asset constants for easy reference throughout the app
/// This helps avoid typos and makes refactoring easier
class AssetConstants {
  // Prevent instantiation
  AssetConstants._();

  // ========== IMAGES ==========
  
  // Logo
  static const String logo = 'assets/images/logo.png';
  
  // Splash/Welcome screen
  static const String splashImage = 'assets/images/splash_image.png';
  
  // Example images (add your actual image paths here)
  // static const String splashBackground = 'assets/images/splash_background.jpg';
  // static const String placeholder = 'assets/images/placeholder.png';
  
  // Backgrounds
  // static const String homeBackground = 'assets/images/backgrounds/home_bg.png';
  
  // ========== ICONS ==========
  
  // Example icons (add your actual icon paths here)
  // static const String homeIcon = 'assets/icons/home.png';
  // static const String searchIcon = 'assets/icons/search.svg';
  
  // ========== ANIMATIONS ==========
  
  // Example animations (add your actual animation paths here)
  // static const String loadingAnimation = 'assets/animations/loading.json';
  // static const String successAnimation = 'assets/animations/success.json';
  
  // ========== FONTS ==========
  
  // Google Fonts
  static const String primaryFont = 'Outfit';
  static const String secondaryFont = 'Outfit'; // Using same font for consistency
}

/// Usage example:
/// 
/// Image.asset(AssetConstants.logo)
/// 
/// Text(
///   'Hello',
///   style: TextStyle(fontFamily: AssetConstants.primaryFont),
/// )

