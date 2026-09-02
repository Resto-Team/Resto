import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:resto/features/auth/domain/repositories/auth_repo.dart';

part 'session_state.dart';

/// Holds the current signed-in user's session info (name, phone) so
/// features that need it (Home greeting, Profile header) share a single
/// source of truth instead of each fetching it independently.
class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this.authRepo) : super(SessionInitial());

  final AuthRepo authRepo;

  Future<void> loadSession() async {
    emit(SessionLoading());
    try {
      final user = await authRepo.getMe();
      emit(SessionLoaded(user.name, user.phone,user.address));
    } catch (e) {
      emit(SessionError(e.toString()));
    }
  }

  Future<void> logout() async {
    await authRepo.logout();
    emit(SessionLoggedOut());
  }
}
