// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}
// class LogOutState extends AuthState {}

class Authenticated extends AuthState {
  User user;
  Position? position;
  String? address;

  Authenticated({
    required this.user, 
    this.position,
    this.address,
  });
}

class UnAuthenticated extends AuthState {}

class AuthenticatedError extends AuthState {
  final String message;

  AuthenticatedError({
    required this.message,
  });
}

class UpdateFieldState extends AuthState {}

class UpdationError extends AuthState {
  final String msg;
  UpdationError({
    required this.msg,
  });
}

class DeleteState extends AuthState {}

class DeleteErrorState extends AuthState {
  final String msg;
  DeleteErrorState({
    required this.msg,
  });
}
