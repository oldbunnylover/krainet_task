import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krainet_task/domain/entities/user.dart';
import 'package:krainet_task/domain/repositories/interfaces/i_authentication_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final IAuthenticationRepository _authenticationRepository;

  RegistrationCubit(this._authenticationRepository)
      : super(RegistrationState(dateOfBirth: DateTime.now(), initialDate: DateTime.now()));

  void changeEmail(String email) {
    emit(state.newState(email: email, errorMessage: ''));
  }

  void changePassword(String password) {
    emit(state.newState(password: password, errorMessage: ''));
  }

  void changeUsername(String username) {
    emit(state.newState(username: username, errorMessage: ''));
  }

  void changeRepeatedPassword(String password) {
    emit(state.newState(repeatedPassword: password, errorMessage: ''));
  }

  void changeDateOfBirth(DateTime? date) {
    emit(state.newState(dateOfBirth: date, errorMessage: ''));
  }

  void openPrivacy() async {
    await launchUrl(Uri.parse('https://krainet.by/'));
  }

  void setCheckBoxValue(bool? value) {
    emit(state.newState(isPrivacyAccepted: value));
  }

  void signup() async {
    _validation();
    if (state.errorMessage.isNotEmpty) {
      return;
    }
    try {
      await _authenticationRepository.signUp(
        UserCredentials(
          email: state.email,
          username: state.username,
          password: state.password,
          dateOfBirth: state.dateOfBirth,
        ),
      );
      emit(state.newState(isSignUpSuccessful: true));
    } catch (e) {
      emit(state.newState(errorMessage: 'Пользователь с таким адресом почты уже зарегестрирован.'));
    }
  }

  void _validation() {
    if (state.password.length < 6) {
      emit(state.newState(errorMessage: 'Минимальная длина пароля - 6 символом.'));
    } else if (state.password != state.repeatedPassword) {
      emit(state.newState(errorMessage: 'Пароли не совпадают.'));
    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-]+\.[a-zA-Z]+")
        .hasMatch(state.email)) {
      emit(state.newState(errorMessage: 'Некорректный адрес почты.'));
    } else if (state.username.length < 6) {
      emit(state.newState(errorMessage: 'Минимальная длина имени пользователя - 6 символом.'));
    }
  }
}

class RegistrationState {
  final String email;
  final String username;
  final String password;
  final String repeatedPassword;
  final DateTime dateOfBirth;
  final DateTime? initialDate;
  final String errorMessage;
  final bool isPrivacyAccepted;
  final bool isSignUpSuccessful;

  RegistrationState({
    this.email = '',
    this.username = '',
    this.password = '',
    this.repeatedPassword = '',
    required this.dateOfBirth,
    this.initialDate,
    this.errorMessage = '',
    this.isPrivacyAccepted = false,
    this.isSignUpSuccessful = false,
  });

  RegistrationState newState({
    String? email,
    String? username,
    String? password,
    String? repeatedPassword,
    DateTime? dateOfBirth,
    String? errorMessage,
    bool? isPrivacyAccepted,
    bool? isSignUpSuccessful,
  }) {
    return RegistrationState(
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      repeatedPassword: repeatedPassword ?? this.repeatedPassword,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      errorMessage: errorMessage ?? this.errorMessage,
      isPrivacyAccepted: isPrivacyAccepted ?? this.isPrivacyAccepted,
      isSignUpSuccessful: isSignUpSuccessful ?? this.isSignUpSuccessful,
    );
  }
}
