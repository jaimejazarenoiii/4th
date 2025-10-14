import 'package:flutter/foundation.dart';

/// Abstract interface for network connectivity checking
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Implementation of NetworkInfo
/// For now, returns true. Can be enhanced with connectivity_plus package
class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // TODO: Implement actual network check using connectivity_plus package
    // For now, return true
    debugPrint('NetworkInfo: Checking connection (always returns true for now)');
    return true;
  }
}

