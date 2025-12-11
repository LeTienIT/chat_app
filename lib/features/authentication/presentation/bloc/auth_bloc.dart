import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/register.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final Register register;
  final Logout logout;
  final GetCurrentUser getCurrentUser;
  StreamSubscription<User?>? _authSubscription;

  AuthBloc({
    required this.login,
    required this.register,
    required this.logout,
    required this.getCurrentUser,
  }) : super(AuthInitial()) {
    on<AppLoaded>(_onAppLoaded);
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  Future<void> _onAppLoaded(AppLoaded event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await getCurrentUser(NoParams());
    result.fold(
          (failure) => emit(AuthUnauthenticated()),
          (user) => emit(AuthAuthenticated(user ?? const User(id: '', email: ''))),
    );
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await login(LoginParams(email: event.email, password: event.password));
    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await register(RegisterParams(email: event.email, fullName: event.fullName, password: event.password));
    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    final result = await logout(NoParams());
    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (_) => emit(AuthUnauthenticated()),
    );
  }
}