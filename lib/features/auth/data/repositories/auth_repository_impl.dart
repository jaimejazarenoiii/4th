import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/storage/jwt_storage_service.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final JwtStorageService _jwtStorageService;

  AuthRepositoryImpl(this._jwtStorageService);

  @override
  Future<Either<Failure, AuthEntity>> checkAuthStatus() async {
    try {
      final authData = await _jwtStorageService.getAuthData();
      
      if (authData == null) {
        return Right(AuthModel.loggedOut());
      }

      if (authData.isValid) {
        return Right(authData);
      } else {
        // Token is expired or invalid, clear storage
        await _jwtStorageService.clearAuthData();
        return Right(AuthModel.loggedOut());
      }
    } catch (e) {
      return const Left(CacheFailure('Failed to check auth status'));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // TODO: Implement actual API call
      // For now, simulate successful login
      final mockAuthData = AuthModel(
        token: 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'user_123',
        email: email,
        name: email.split('@')[0],
        expiresAt: DateTime.now().add(const Duration(days: 7)),
        isAuthenticated: true,
      );

      await _jwtStorageService.storeAuthData(mockAuthData);
      return Right(mockAuthData);
    } catch (e) {
      return const Left(ServerFailure('Sign in failed'));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      // TODO: Implement actual API call
      // For now, simulate successful signup
      final mockAuthData = AuthModel(
        token: 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name ?? email.split('@')[0],
        expiresAt: DateTime.now().add(const Duration(days: 7)),
        isAuthenticated: true,
      );

      await _jwtStorageService.storeAuthData(mockAuthData);
      return Right(mockAuthData);
    } catch (e) {
      return const Left(ServerFailure('Sign up failed'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _jwtStorageService.clearAuthData();
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Sign out failed'));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> refreshToken() async {
    try {
      // TODO: Implement actual token refresh API call
      // For now, simulate token refresh
      final currentAuth = await _jwtStorageService.getAuthData();
      if (currentAuth == null) {
        return const Left(CacheFailure('No stored authentication data'));
      }

      final refreshedAuth = currentAuth.copyWith(
        token: 'refreshed_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
        expiresAt: DateTime.now().add(const Duration(days: 7)),
      );

      await _jwtStorageService.storeAuthData(AuthModel.fromEntity(refreshedAuth));
      return Right(refreshedAuth);
    } catch (e) {
      return const Left(ServerFailure('Token refresh failed'));
    }
  }

  @override
  Future<Either<Failure, AuthEntity?>> getCurrentUser() async {
    try {
      final authData = await _jwtStorageService.getAuthData();
      return Right(authData);
    } catch (e) {
      return const Left(CacheFailure('Failed to get current user'));
    }
  }
}
