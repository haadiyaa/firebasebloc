// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  Authenticated(
    this.user,
  );
}

class UnAuthenticated extends AuthState {}

class AuthenticatedError extends AuthState {
  final String message;

  AuthenticatedError({
    required this.message,
  });
}

class DeleteState extends AuthState {}

class DeleteErrorState extends AuthState {
  final String msg;
  DeleteErrorState({
    required this.msg,
  });
}
