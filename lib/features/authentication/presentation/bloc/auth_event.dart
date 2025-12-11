
part of 'auth_bloc.dart';
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AppLoaded extends AuthEvent {}  // Trigger khi app start, load current user

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String fullName;
  final String password;

  const RegisterEvent(this.email, this.fullName, this.password);

  @override
  List<Object?> get props => [email, fullName, password];
}

class LogoutEvent extends AuthEvent {}