import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_entity.dart';

abstract class AuthRepository {
  /// Check if user is authenticated by validating stored JWT
  Future<Either<Failure, AuthEntity>> checkAuthStatus();

  /// Sign in user with email and password
  Future<Either<Failure, AuthEntity>> signIn({
    required String email,
    required String password,
  });

  /// Sign up user with email and password
  Future<Either<Failure, AuthEntity>> signUp({
    required String email,
    required String password,
    String? name,
  });

  /// Sign out user and clear stored tokens
  Future<Either<Failure, void>> signOut();

  /// Refresh JWT token
  Future<Either<Failure, AuthEntity>> refreshToken();

  /// Get current authenticated user
  Future<Either<Failure, AuthEntity?>> getCurrentUser();
}
