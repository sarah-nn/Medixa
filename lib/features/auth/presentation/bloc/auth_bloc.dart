import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._login, this._logout, this._getCurrentUser)
    : super(const AuthState()) {
    on<AuthStarted>(_onStarted);
    on<LoginSubmitted>(_onLogin);
    on<LogoutRequested>(_onLogout);
  }
  final LoginUseCase _login;
  final LogoutUseCase _logout;
  final GetCurrentUserUseCase _getCurrentUser;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, message: null));
    final result = await _getCurrentUser(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          message: failure.message,
          clearUser: true,
        ),
      ),
      (user) => emit(
        user == null
            ? state.copyWith(
              status: AuthStatus.unauthenticated,
              clearUser: true,
            )
            : state.copyWith(status: AuthStatus.authenticated, user: user),
      ),
    );
  }

  Future<void> _onLogin(LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, message: null));
    final result = await _login(
      LoginParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.failure, message: failure.message),
      ),
      (user) =>
          emit(state.copyWith(status: AuthStatus.authenticated, user: user)),
    );
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _logout(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.failure, message: failure.message),
      ),
      (_) => emit(
        state.copyWith(status: AuthStatus.unauthenticated, clearUser: true),
      ),
    );
  }
}
