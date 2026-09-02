part of 'session_cubit.dart';

@immutable
sealed class SessionState {}

final class SessionInitial extends SessionState {}

final class SessionLoading extends SessionState {}

final class SessionLoaded extends SessionState {
  final String userName;
  final String? phone;
  final String? address;
  SessionLoaded(this.userName, this.phone, this.address);
}

final class SessionError extends SessionState {
  final String message;
  SessionError(this.message);
}

final class SessionLoggedOut extends SessionState {}
