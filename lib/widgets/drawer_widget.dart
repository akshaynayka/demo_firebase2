import '../common_methods/common_methods.dart';
import '../values/app_routes.dart';
import '../widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});
  Widget _rowTileContainer(
      {required IconData icon, required String title, Function()? onTap}) {
    return Container(
      padding: const EdgeInsets.only(left: 16, top: 8),
      height: 40,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              icon,
            ),
            const SizedBox(width: 32),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const AppBarWidget(
            automaticallyImplyLeading: false,
            title: 'Chat App',
          ),
          _rowTileContainer(
              icon: Icons.person,
              title: 'Profile',
              onTap: () async {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(appRouteProfileScreen);
              }),
          _rowTileContainer(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () async {
              await showExitDialogBox(context);
            },
          ),
        ],
      ),
    );
  }
}
