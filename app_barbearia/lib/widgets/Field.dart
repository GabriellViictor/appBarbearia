import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Field extends StatelessWidget {
  String label;
  String hint;
  bool password;
  TextEditingController? controller;
  FormFieldValidator<String>? validator;
  TextInputType? keyboardType;
  TextInputAction? textInputAction;
  Function? onChanged;
  FocusNode? focusNode;
  FocusNode? nextFocus;
  Icon? prefixIcon;
  Icon? sufixIcon;
  bool enable;
  bool border;
  int? minLines;
  int? maxLines;
  int? decimal;
  EdgeInsets? scrollPadding;
  Function? onSubmited;
  TextCapitalization? textCapitalization;

  Field({
    required this.label,
    this.hint = "",
    this.password = false,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.focusNode,
    this.nextFocus,
    this.prefixIcon,
    this.sufixIcon,
    this.enable = true,
    this.border = true,
    this.minLines = 1,
    this.maxLines = 1,
    this.decimal = 0,
    this.scrollPadding,
    this.onSubmited,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: password,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      focusNode: focusNode,
      scrollPadding: scrollPadding ?? const EdgeInsets.only(bottom: 20),
      textCapitalization: textCapitalization!,
      onFieldSubmitted: (String value) {
        if (onSubmited != null) {
          onSubmited!();
        }

        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        }
      },
      onChanged: onChanged != null
          ? (value) {
              onChanged!(value);
            }
          : null,
      enabled: enable,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: enable,
        border: border
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              )
            : null,
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(
          fontSize: 16,
          color: enable ? Theme.of(context).primaryColor : Colors.grey[500],
        ),
        prefixIcon: prefixIcon,
        suffixIcon: sufixIcon,
        alignLabelWithHint: true,
      ),
      minLines: minLines,
      maxLines: maxLines,
    );
  }
}