import 'package:flutter/material.dart';
import 'package:krainet_task/presentation/utils/context_extensions.dart';

class PrimaryButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;

  const PrimaryButtonWidget({
    required this.title,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: context.theme.actionColor,
        foregroundColor: context.theme.actionPressedColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 32),
        visualDensity: const VisualDensity(vertical: 0.3),
      ),
      child: Text(
        title,
        style: TextStyle(color: context.theme.textColor, fontSize: 16),
      ),
    );
  }
}
