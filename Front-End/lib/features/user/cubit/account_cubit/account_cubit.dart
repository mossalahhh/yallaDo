import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/features/user/data/user_service.dart';
import 'account_state.dart';

/// Drives the account-security screens: change email (+ confirm) and update
/// password. Each screen provides its own instance via `BlocProvider`.
class AccountCubit extends Cubit<AccountState> {
  AccountCubit() : super(AccountInitial());

  final UserService _service = UserService();

  String _msg(String fallback, String serverMessage) =>
      serverMessage.isNotEmpty ? serverMessage : fallback;

  Future<void> changeEmail({
    required String newEmail,
    required String password,
  }) async {
    emit(AccountLoading());
    final res = await _service.changeEmail(newEmail: newEmail, password: password);
    if (res.status) {
      emit(EmailChangeSent(_msg('Confirmation code sent', res.message)));
    } else {
      emit(AccountError(_msg('Could not change email', res.message)));
    }
  }

  Future<void> confirmEmail({required String code}) async {
    emit(AccountLoading());
    final res = await _service.confirmEmail(code: code);
    if (res.status) {
      emit(EmailConfirmed(_msg('Email updated', res.message)));
    } else {
      emit(AccountError(_msg('Could not confirm email', res.message)));
    }
  }

  Future<void> updatePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(AccountLoading());
    final res = await _service.updatePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
    if (res.status) {
      emit(PasswordUpdated(_msg('Password updated', res.message)));
    } else {
      emit(AccountError(_msg('Could not update password', res.message)));
    }
  }
}
