import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krainet_task/presentation/app/app_cubit.dart';
import 'package:krainet_task/presentation/app/app_themes.dart';
import 'package:krainet_task/presentation/di/injector.dart';
import 'package:krainet_task/presentation/pages/login/login_page.dart';
import 'package:krainet_task/presentation/pages/main/main_page.dart';
import 'package:krainet_task/presentation/theme/theme_provider.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _cubit = i.get<AppCubit>();

  @override
  void initState() {
    _cubit.init();
    super.initState();
  }

  @override
  void dispose() {
    _cubit.dispose();
    super.dispose();
  }

  List<Page<dynamic>> _onGeneratePages(AuthStatus state, List<Page<dynamic>> pages) {
    switch (state) {
      case AuthStatus.authenticated:
        return [MainPage.page()];
      case AuthStatus.unauthenticated:
        return [LoginPage.page()];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      bloc: _cubit,
      builder: (context, state) {
        return ThemeProvider(
          theme: darkTheme,
          child: MaterialApp(
            home: FlowBuilder<AuthStatus>(
              state: state.status,
              onGeneratePages: _onGeneratePages,
            ),
          ),
        );
      },
    );
  }
}
