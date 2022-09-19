import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krainet_task/domain/entities/user.dart';
import 'package:krainet_task/domain/repositories/interfaces/i_authentication_repository.dart';

class LoginCubit extends Cubit<LoginState> {
  final IAuthenticationRepository _authenticationRepository;

  LoginCubit(this._authenticationRepository) : super(LoginState());

  void changeEmail(String email) {
    emit(state.newState(email: email, errorMessage: ''));
  }

  void changePassword(String password) {
    emit(state.newState(password: password, errorMessage: ''));
  }

  void login() async {
    if (state.errorMessage.isNotEmpty) {
      return;
    }
    try {
      await _authenticationRepository.logIn(
        UserCredentials(
          email: state.email,
          password: state.password,
        ),
      );
    } catch (e) {
      emit(state.newState(errorMessage: 'Неверный адрес почты или пароль.'));
    }
  }
}

class LoginState {
  final String email;
  final String password;
  final String errorMessage;

  LoginState({
    this.email = '',
    this.password = '',
    this.errorMessage = '',
  });

  LoginState newState({
    String? email,
    String? password,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
