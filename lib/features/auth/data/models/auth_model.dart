import '../../domain/entities/auth_entity.dart';
import 'auth_response_model.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    required super.token,
    required super.userId,
    required super.email,
    super.name,
    required super.expiresAt,
    required super.isAuthenticated,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['token'] as String,
      userId: json['userId'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      isAuthenticated: json['isAuthenticated'] as bool? ?? true,
    );
  }

  /// Factory method to create AuthModel from API response
  factory AuthModel.fromApiResponse(
    AuthDataModel data, {
    String? fallbackName,
  }) {
    return AuthModel(
      token: data.token,
      userId: data.user.id,
      email: data.user.email,
      name: data.user.name ?? fallbackName,
      expiresAt: DateTime.now().add(const Duration(days: 7)),
      isAuthenticated: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userId': userId,
      'email': email,
      'name': name,
      'expiresAt': expiresAt.toIso8601String(),
      'isAuthenticated': isAuthenticated,
    };
  }

  factory AuthModel.fromEntity(AuthEntity entity) {
    return AuthModel(
      token: entity.token,
      userId: entity.userId,
      email: entity.email,
      name: entity.name,
      expiresAt: entity.expiresAt,
      isAuthenticated: entity.isAuthenticated,
    );
  }

  // Create a logged out state
  factory AuthModel.loggedOut() {
    return AuthModel(
      token: '',
      userId: '',
      email: '',
      name: null,
      expiresAt: DateTime.now(),
      isAuthenticated: false,
    );
  }
}
