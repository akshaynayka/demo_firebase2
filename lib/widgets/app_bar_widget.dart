import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    this.elevation,
    this.title,
    this.automaticallyImplyLeading = true,
    super.key,
  });
  final double? elevation;
  final String? title;
  final bool automaticallyImplyLeading;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title == null ? null : Text(title!),
      elevation: elevation,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
