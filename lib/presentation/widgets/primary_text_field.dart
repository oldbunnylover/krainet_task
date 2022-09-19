import 'package:flutter/material.dart';
import 'package:krainet_task/presentation/utils/context_extensions.dart';

class PrimaryTextFieldWidget extends StatefulWidget {
  final String? hint;
  final String? value;
  final TextFieldType type;
  final Function(String)? onChanged;
  final VoidCallback? onDatePickerClicked;
  final TextEditingController? controller;

  const PrimaryTextFieldWidget({
    this.hint,
    required this.type,
    this.value,
    this.onChanged,
    this.onDatePickerClicked,
    this.controller,
    Key? key,
  }) : super(key: key);

  @override
  State<PrimaryTextFieldWidget> createState() => _PrimaryTextFieldWidgetState();
}

class _PrimaryTextFieldWidgetState extends State<PrimaryTextFieldWidget> {
  late bool _isTextVisible;
  late TextEditingController _controller;

  @override
  void initState() {
    _isTextVisible = widget.type != TextFieldType.password;
    _controller = widget.controller ?? TextEditingController(text: widget.value);
    super.initState();
  }

  Widget? _buildSuffixIcon() {
    switch (widget.type) {
      case TextFieldType.date:
        return IconButton(
          icon: const Icon(Icons.date_range),
          color: context.theme.actionColor,
          splashColor: Colors.transparent,
          onPressed: widget.onDatePickerClicked,
        );
      case TextFieldType.password:
        return IconButton(
          icon: Icon(_isTextVisible ? Icons.visibility : Icons.visibility_off),
          color: context.theme.actionColor,
          splashColor: Colors.transparent,
          onPressed: () => setState(() => _isTextVisible = !_isTextVisible),
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        cursorColor: context.theme.textColor,
        obscureText: !_isTextVisible,
        enabled: widget.type == TextFieldType.simpleText || widget.type == TextFieldType.date
            ? false
            : true,
        style: TextStyle(color: context.theme.textColor),
        keyboardType:
            widget.type == TextFieldType.email ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: context.theme.secondaryBackgroundColor,
          hintText: widget.hint,
          suffixIcon: _buildSuffixIcon(),
          hintStyle: TextStyle(color: context.theme.textColor.withOpacity(0.8)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide.none,
            gapPadding: 0,
          ),
        ),
      ),
    );
  }
}

enum TextFieldType { email, password, name, date, simpleText }
