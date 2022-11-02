import 'package:flutter/material.dart';

class RoundButtonWidget extends StatelessWidget {
  const RoundButtonWidget(
      {required this.label, required this.onPressed, this.padding, super.key});
  final EdgeInsetsGeometry? padding;
  final void Function()? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0))),
        child: Text(
          label,
        ),
      ),
    );
  }
}
