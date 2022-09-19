import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krainet_task/presentation/di/injector.dart';
import 'package:krainet_task/presentation/pages/login/login_cubit.dart';
import 'package:krainet_task/presentation/pages/registration/registration_page.dart';
import 'package:krainet_task/presentation/utils/context_extensions.dart';
import 'package:krainet_task/presentation/widgets/primary_appbar.dart';
import 'package:krainet_task/presentation/widgets/primary_button.dart';
import 'package:krainet_task/presentation/widgets/primary_text_button.dart';
import 'package:krainet_task/presentation/widgets/primary_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Page<void> page() => const MaterialPage<void>(child: LoginPage());

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _cubit = i.get<LoginCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      bloc: _cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: kIsWeb ? null : const PrimaryAppbarWidget(title: 'Авторизация'),
          backgroundColor: context.theme.primaryBackgroundColor,
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            child: Column(
              children: [
                Image.asset('assets/logo.png', width: 150, height: 150),
                const SizedBox(height: 16),
                PrimaryTextFieldWidget(
                  hint: 'Электронная почта',
                  type: TextFieldType.email,
                  onChanged: _cubit.changeEmail,
                ),
                const SizedBox(height: 16),
                PrimaryTextFieldWidget(
                  hint: 'Пароль',
                  type: TextFieldType.password,
                  onChanged: _cubit.changePassword,
                ),
                const SizedBox(height: 4),
                PrimaryTextButtonWidget(
                  title: 'Нет аккаунта?',
                  onPressed: () => Navigator.of(context).push<void>(RegistrationPage.route()),
                ),
                PrimaryButtonWidget(
                  title: 'Войти',
                  onPressed: state.email.isEmpty || state.password.isEmpty ? null : _cubit.login,
                ),
                const SizedBox(height: 4),
                if (state.errorMessage.isNotEmpty)
                  Text(state.errorMessage, style: const TextStyle(color: Colors.red)),
              ],
            ),
          ),
        );
      },
    );
  }
}
