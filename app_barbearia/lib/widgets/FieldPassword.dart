import 'package:flutter/material.dart';

class FieldPassword extends StatefulWidget {
  String label;
  String hint;
  TextEditingController? controller;
  FormFieldValidator<String>? validator;
  TextInputType? keyboardType;
  TextInputAction? textInputAction;
  Function? onChanged;
  FocusNode? focusNode;
  FocusNode? nextFocus;
  Icon? prefixIcon;
  bool enable;
  bool border;
  int? minLines;
  int? maxLines;
  EdgeInsets? scrollPadding;
  Function? onSubmited;
  TextCapitalization? textCapitalization;

  FieldPassword({
    required this.label,
    this.hint = "",
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.focusNode,
    this.nextFocus,
    this.prefixIcon,
    this.enable = true,
    this.border = true,
    this.minLines = 1,
    this.maxLines = 1,
    this.scrollPadding,
    this.onSubmited,
    this.textCapitalization = TextCapitalization.characters,
  });

  @override
  State<FieldPassword> createState() => _FieldPasswordState();
}

class _FieldPasswordState extends State<FieldPassword> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      focusNode: widget.focusNode,
      scrollPadding: widget.scrollPadding ?? const EdgeInsets.only(bottom: 20),
      textCapitalization: widget.textCapitalization!,
      onFieldSubmitted: (String value) {
        if (widget.onSubmited != null) {
          widget.onSubmited!();
        }

        if (widget.nextFocus != null) {
          FocusScope.of(context).requestFocus(widget.nextFocus);
        }
      },
      onChanged: widget.onChanged != null
          ? (value) {
              widget.onChanged!(value);
            }
          : null,
      enabled: widget.enable,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: widget.enable,
        border: widget.border
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              )
            : null,
        labelText: widget.label,
        hintText: widget.hint,
        labelStyle: TextStyle(
          fontSize: 16,
          color:
              widget.enable ? Theme.of(context).primaryColor : Colors.grey[500],
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: GestureDetector(
          child: _obscure ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
          onTap: () {
            setState(() {
              _obscure = !_obscure;
            });
          },
        ),
        alignLabelWithHint: true,
      ),
      minLines: widget.minLines,
      maxLines: widget.maxLines,
    );
  }
}