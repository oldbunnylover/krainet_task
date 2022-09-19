import 'package:flutter/material.dart';
import 'package:krainet_task/presentation/utils/context_extensions.dart';

class PrimaryAppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const PrimaryAppbarWidget({required this.title, this.actions, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(color: context.theme.textColor),
      ),
      backgroundColor: context.theme.secondaryBackgroundColor,
      elevation: 0,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
