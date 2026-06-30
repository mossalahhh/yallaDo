import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/core/network/token_storage.dart';
import 'package:yallado/features/auth/data/auth_service.dart';
import 'package:yallado/features/auth/data/models/auth_token.dart';
import 'auth_state.dart';

/// Single cubit driving every Auth screen (login, register, verify-email,
/// resend-code, forget/reset password, logout). Each screen provides its own
/// instance via `BlocProvider` and reacts through `BlocConsumer`.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthService _service = AuthService();

  /// Resend-code `type` values accepted by the backend.
  static const String typeActivation = 'activationCode';
  static const String typeForgetPassword = 'forgetPassword';

  bool obscurePassword = true;
  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    emit(AuthPasswordVisibilityChanged(obscurePassword));
  }

  String _msg(String fallback, String serverMessage) =>
      serverMessage.isNotEmpty ? serverMessage : fallback;

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    final res = await _service.login(email: email, password: password);
    final token = (res.data is Map) ? res.data['token'] as String? : null;
    if (res.status && token != null && token.isNotEmpty) {
      await TokenStorage.saveToken(token);
      emit(LoginSuccess(AuthToken.fromJwt(token)));
    } else {
      emit(AuthError(_msg('Login failed', res.message)));
    }
  }

  Future<void> register({
    required String name,
    required String userName,
    required String email,
    required String password,
    required String confirmPassword,
    required String gender,
    required String dateOfBirth,
    required String role,
  }) async {
    emit(AuthLoading());
    final res = await _service.register(
      name: name,
      userName: userName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      gender: gender,
      dateOfBirth: dateOfBirth,
      role: role,
    );
    if (res.status) {
      emit(RegisterSuccess(email, _msg('Account created', res.message)));
    } else {
      emit(AuthError(_msg('Registration failed', res.message)));
    }
  }

  Future<void> verifyEmail({
    required String email,
    required String activationCode,
  }) async {
    emit(AuthLoading());
    final res =
        await _service.verifyEmail(email: email, activationCode: activationCode);
    if (res.status) {
      emit(VerifyEmailSuccess(_msg('Email verified', res.message)));
    } else {
      emit(AuthError(_msg('Verification failed', res.message)));
    }
  }

  Future<void> resendCode({
    required String email,
    required String type,
  }) async {
    emit(AuthLoading());
    final res = await _service.resendCode(email: email, type: type);
    if (res.status) {
      emit(ResendCodeSuccess(_msg('Code sent', res.message)));
    } else {
      emit(AuthError(_msg('Could not resend code', res.message)));
    }
  }

  Future<void> forgetPassword({required String email}) async {
    emit(AuthLoading());
    final res = await _service.forgetPassword(email: email);
    if (res.status) {
      emit(ForgetPasswordSuccess(email, _msg('Reset code sent', res.message)));
    } else {
      emit(AuthError(_msg('Could not send reset code', res.message)));
    }
  }

  Future<void> resetPassword({
    required String email,
    required String resetCode,
    required String newPassword,
  }) async {
    emit(AuthLoading());
    final res = await _service.resetPassword(
      email: email,
      resetCode: resetCode,
      newPassword: newPassword,
    );
    if (res.status) {
      emit(ResetPasswordSuccess(_msg('Password updated', res.message)));
    } else {
      emit(AuthError(_msg('Could not reset password', res.message)));
    }
  }

  /// Best-effort logout: hit the endpoint, then always clear the local token.
  Future<void> logout() async {
    emit(AuthLoading());
    await _service.logout();
    await TokenStorage.clear();
    emit(LogoutSuccess());
  }
}
