import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:krainet_task/presentation/di/injector.dart';
import 'package:krainet_task/presentation/pages/registration/registration_cubit.dart';
import 'package:krainet_task/presentation/utils/context_extensions.dart';
import 'package:krainet_task/presentation/widgets/primary_appbar.dart';
import 'package:krainet_task/presentation/widgets/primary_button.dart';
import 'package:krainet_task/presentation/widgets/primary_text_button.dart';
import 'package:krainet_task/presentation/widgets/primary_text_field.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  static Page<void> page() => const MaterialPage<void>(child: RegistrationPage());

  static Route<void> route() {
    return CupertinoPageRoute<void>(builder: (_) => const RegistrationPage());
  }

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _cubit = i.get<RegistrationCubit>();
  final _dateController = TextEditingController();

  void _openDatePickerDialog(DateTime initialDate) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: context.theme.secondaryBackgroundColor,
              onPrimary: context.theme.textColor,
              onSurface: context.theme.textColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: context.theme.actionColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      _dateController.text = DateFormat.yMd().format(date);
      _cubit.changeDateOfBirth(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegistrationCubit, RegistrationState>(
      bloc: _cubit,
      listenWhen: (previous, current) => previous.isSignUpSuccessful != current.isSignUpSuccessful,
      listener: (context, state) => Navigator.of(context).pop(),
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.theme.primaryBackgroundColor,
          appBar: kIsWeb ? null : const PrimaryAppbarWidget(title: 'Регистрация'),
          body: SingleChildScrollView(
            child: Container(
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
                    hint: 'Имя пользователя',
                    type: TextFieldType.name,
                    onChanged: _cubit.changeUsername,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _openDatePickerDialog(state.dateOfBirth),
                    child: PrimaryTextFieldWidget(
                      controller: _dateController,
                      hint: 'Дата рождения',
                      value: state.dateOfBirth == state.initialDate
                          ? null
                          : state.dateOfBirth.toString(),
                      onDatePickerClicked: () => _openDatePickerDialog(state.dateOfBirth),
                      type: TextFieldType.date,
                    ),
                  ),
                  const SizedBox(height: 16),
                  PrimaryTextFieldWidget(
                    hint: 'Пароль',
                    type: TextFieldType.password,
                    onChanged: _cubit.changePassword,
                  ),
                  const SizedBox(height: 16),
                  PrimaryTextFieldWidget(
                    hint: 'Повторите пароль',
                    type: TextFieldType.password,
                    onChanged: _cubit.changeRepeatedPassword,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        activeColor: context.theme.actionColor,
                        side: BorderSide(color: context.theme.actionColor),
                        value: state.isPrivacyAccepted,
                        onChanged: _cubit.setCheckBoxValue,
                      ),
                      PrimaryTextButtonWidget(
                        title: 'Согласен с политикой конфиденциальности',
                        onPressed: _cubit.openPrivacy,
                      ),
                    ],
                  ),
                  PrimaryButtonWidget(
                    title: 'Зарегистрироваться',
                    onPressed: state.email.isEmpty ||
                            state.username.isEmpty ||
                            state.password.isEmpty ||
                            state.repeatedPassword.isEmpty ||
                            state.initialDate == state.dateOfBirth ||
                            !state.isPrivacyAccepted
                        ? null
                        : _cubit.signup,
                  ),
                  const SizedBox(height: 4),
                  if (state.errorMessage.isNotEmpty)
                    Text(state.errorMessage, style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
