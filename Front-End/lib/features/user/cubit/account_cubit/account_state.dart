abstract class AccountState {}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class EmailChangeSent extends AccountState {
  final String message;
  EmailChangeSent(this.message);
}

class EmailConfirmed extends AccountState {
  final String message;
  EmailConfirmed(this.message);
}

class PasswordUpdated extends AccountState {
  final String message;
  PasswordUpdated(this.message);
}

class AccountError extends AccountState {
  final String message;
  AccountError(this.message);
}
