import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget(
      {this.lableText,
      this.icon,
      this.keyboardType,
      this.textInputAction,
      this.obscureText = false,
      this.initialValue,
      this.validator,
      this.onSaved,
      this.readOnly = false,
      Key? key})
      : super(key: key);

  final String? lableText;

  final IconData? icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final String? initialValue;
  final bool readOnly;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: lableText,
        labelStyle: const TextStyle(
          color: Colors.grey,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Icon(
            icon,
            size: 20,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(25.0),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      onSaved: onSaved,
      obscureText: obscureText,
      initialValue: initialValue,
      validator: validator,
      cursorColor: Colors.grey,
      readOnly: readOnly,
    );
  }
}
