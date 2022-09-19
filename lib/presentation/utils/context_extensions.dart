import 'package:flutter/cupertino.dart';
import 'package:krainet_task/presentation/theme/app_theme.dart';
import 'package:krainet_task/presentation/theme/theme_provider.dart';

extension ContextExtensions on BuildContext {
  AppTheme get theme => ThemeProvider.of(this).theme;
}