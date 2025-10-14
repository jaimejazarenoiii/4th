import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String token;
  final String userId;
  final String email;
  final String? name;
  final DateTime expiresAt;
  final bool isAuthenticated;

  const AuthEntity({
    required this.token,
    required this.userId,
    required this.email,
    this.name,
    required this.expiresAt,
    required this.isAuthenticated,
  });

  @override
  List<Object?> get props => [
        token,
        userId,
        email,
        name,
        expiresAt,
        isAuthenticated,
      ];

  AuthEntity copyWith({
    String? token,
    String? userId,
    String? email,
    String? name,
    DateTime? expiresAt,
    bool? isAuthenticated,
  }) {
    return AuthEntity(
      token: token ?? this.token,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      expiresAt: expiresAt ?? this.expiresAt,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  bool get isTokenExpired {
    return DateTime.now().isAfter(expiresAt);
  }

  bool get isValid {
    return isAuthenticated && !isTokenExpired;
  }
}
