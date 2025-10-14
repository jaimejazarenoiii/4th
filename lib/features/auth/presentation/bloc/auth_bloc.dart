import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/check_auth_status.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/usecases/sign_out.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuthStatus _checkAuthStatus;
  final SignIn _signIn;
  final SignUp _signUp;
  final SignOut _signOut;

  AuthBloc({
    required CheckAuthStatus checkAuthStatus,
    required SignIn signIn,
    required SignUp signUp,
    required SignOut signOut,
  })  : _checkAuthStatus = checkAuthStatus,
        _signIn = signIn,
        _signUp = signUp,
        _signOut = signOut,
        super(const AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<SignInEvent>(_onSignIn);
    on<SignUpEvent>(_onSignUp);
    on<SignOutEvent>(_onSignOut);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthChecking());
    
    final result = await _checkAuthStatus(const NoParams());
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (authEntity) {
        if (authEntity.isAuthenticated && authEntity.isValid) {
          emit(AuthAuthenticated(authEntity));
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onSignIn(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    final result = await _signIn(SignInParams(
      email: event.email,
      password: event.password,
    ));
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (authEntity) => emit(AuthAuthenticated(authEntity)),
    );
  }

  Future<void> _onSignUp(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    final result = await _signUp(SignUpParams(
      email: event.email,
      password: event.password,
      name: event.name,
    ));
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (authEntity) => emit(AuthAuthenticated(authEntity)),
    );
  }

  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    final result = await _signOut(const NoParams());
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }
}
