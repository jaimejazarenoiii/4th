import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/storage/jwt_storage_service.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_model.dart';
import '../models/auth_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final JwtStorageService _jwtStorageService;
  final DioClient _dioClient;

  AuthRepositoryImpl(this._jwtStorageService, this._dioClient);

  /// Handles API response parsing and creates AuthModel using fromJson
  Either<Failure, AuthModel> _handleAuthResponse(
    Map<String, dynamic> responseData,
  ) {
    try {
      final authResponse = AuthResponseModel.fromJson(responseData);

      if (authResponse.isSuccess && authResponse.data != null) {
        final authData = AuthModel.fromApiResponse(authResponse.data!);
        return Right(authData);
      } else {
        return _handleErrorResponse(authResponse);
      }
    } catch (e) {
      return Left(ServerFailure('Failed to parse response: ${e.toString()}'));
    }
  }

  /// Handles error response format using typed models
  Either<Failure, AuthModel> _handleErrorResponse(AuthResponseModel response) {
    String errorMessage = response.status.message;

    // If there are specific error messages, append them
    if (response.errors != null && response.errors!.isNotEmpty) {
      final errorList = response.errors!.join(', ');
      errorMessage = '$errorMessage. $errorList';
    }

    return Left(ServerFailure(errorMessage));
  }

  /// Handles DioException and returns appropriate Failure
  Either<Failure, AuthModel> _handleDioException(DioException e) {
    // Try to parse error response if available
    if (e.response?.data != null) {
      try {
        final errorResponse = AuthResponseModel.fromJson(e.response!.data);
        return _handleErrorResponse(errorResponse);
      } catch (_) {
        // Fall back to status code handling if parsing fails
      }
    }

    // Fallback to status code based error handling
    if (e.response?.statusCode == 401) {
      return const Left(ServerFailure('Invalid credentials'));
    } else if (e.response?.statusCode == 422) {
      return const Left(ServerFailure('Invalid input data'));
    } else if (e.response?.statusCode == 409) {
      return const Left(ServerFailure('Email already exists'));
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return const Left(ServerFailure('Connection timeout'));
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return const Left(ServerFailure('Server timeout'));
    } else {
      return Left(ServerFailure(e.message ?? 'Request failed'));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> checkAuthStatus() async {
    try {
      final authData = await _jwtStorageService.getAuthData();

      if (authData == null) {
        return Right(AuthModel.loggedOut());
      }

      if (authData.isValid) {
        // Set the auth token for future requests
        _dioClient.setAuthToken(authData.token);
        return Right(authData);
      } else {
        // Token is expired or invalid, clear storage
        await _jwtStorageService.clearAuthData();
        _dioClient.clearAuthToken();
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
      final response = await _dioClient.post(
        '/login',
        data: {
          'user': {'email': email, 'password': password},
        },
      );

      final authResult = _handleAuthResponse(response.data);

      return authResult.fold((failure) => Left(failure), (authData) async {
        // Set the auth token for future requests
        _dioClient.setAuthToken(authData.token);
        await _jwtStorageService.storeAuthData(authData);
        return Right(authData);
      });
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final response = await _dioClient.post(
        '/signup',
        data: {
          'email': email,
          'password': password,
          if (name != null) 'name': name,
        },
      );

      final authResult = _handleAuthResponse(response.data);

      return authResult.fold((failure) => Left(failure), (authData) async {
        // Set the auth token for future requests
        _dioClient.setAuthToken(authData.token);
        await _jwtStorageService.storeAuthData(authData);
        return Right(authData);
      });
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _jwtStorageService.clearAuthData();
      // Clear the auth token from Dio client
      _dioClient.clearAuthToken();
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Sign out failed'));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> refreshToken() async {
    try {
      final response = await _dioClient.post('refresh');

      final authResult = _handleAuthResponse(response.data);

      return authResult.fold((failure) => Left(failure), (authData) async {
        // Update the auth token for future requests
        _dioClient.setAuthToken(authData.token);
        await _jwtStorageService.storeAuthData(authData);
        return Right(authData);
      });
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Refresh token is invalid, sign out user
        await _jwtStorageService.clearAuthData();
        _dioClient.clearAuthToken();
        return const Left(
          ServerFailure('Session expired. Please sign in again.'),
        );
      } else {
        return _handleDioException(e);
      }
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
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
