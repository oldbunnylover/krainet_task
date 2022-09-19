import 'package:flutter/material.dart';
import 'package:krainet_task/presentation/utils/context_extensions.dart';

class PrimaryTextButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;

  const PrimaryTextButtonWidget({
    required this.title,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: context.theme.actionPressedColor,
      ),
      child: Text(
        title,
        style: TextStyle(color: context.theme.textColor),
      ),
    );
  }
}
