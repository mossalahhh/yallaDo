import 'package:yallado/features/auth/data/models/auth_token.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

/// Emitted when the password obscure toggle changes (UI-only state).
class AuthPasswordVisibilityChanged extends AuthState {
  final bool obscure;
  AuthPasswordVisibilityChanged(this.obscure);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class LoginSuccess extends AuthState {
  final AuthToken token;
  LoginSuccess(this.token);
}

class RegisterSuccess extends AuthState {
  final String email;
  final String message;
  RegisterSuccess(this.email, this.message);
}

class VerifyEmailSuccess extends AuthState {
  final String message;
  VerifyEmailSuccess(this.message);
}

class ForgetPasswordSuccess extends AuthState {
  final String email;
  final String message;
  ForgetPasswordSuccess(this.email, this.message);
}

class ResetPasswordSuccess extends AuthState {
  final String message;
  ResetPasswordSuccess(this.message);
}

class ResendCodeSuccess extends AuthState {
  final String message;
  ResendCodeSuccess(this.message);
}

class LogoutSuccess extends AuthState {}
