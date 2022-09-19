import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krainet_task/domain/entities/user.dart';
import 'package:krainet_task/domain/repositories/interfaces/i_authentication_repository.dart';

class AppCubit extends Cubit<AppState> {
  final IAuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User> _userSubscription;

  AppCubit(this._authenticationRepository) : super(AppState());

  void init() async {
    await _updateAuthStatus();
    _userSubscription = _authenticationRepository.user.listen((_) => _updateAuthStatus());
  }

  void dispose() {
    _userSubscription.cancel();
  }

  void logout() async {
    await _authenticationRepository.logOut();
  }

  Future<void> _updateAuthStatus() async {
    final user = await _authenticationRepository.currentUser;
    emit(
      state.newState(
        status: user.isEmpty ? AuthStatus.unauthenticated : AuthStatus.authenticated,
        user: user,
      ),
    );
  }
}

class AppState {
  final AuthStatus status;
  final User user;

  AppState({this.status = AuthStatus.unauthenticated, this.user = User.empty});

  AppState newState({
    AuthStatus? status,
    User? user,
  }) {
    return AppState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}

enum AuthStatus { authenticated, unauthenticated }
