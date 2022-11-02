import '../models/group.dart';
import '../values/app_routes.dart';
import 'package:flutter/material.dart';

class GroupTileWidget extends StatelessWidget {
  const GroupTileWidget({required this.groupData, super.key});
  final Group? groupData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 0),
        leading: CircleAvatar(
          radius: 50,
          backgroundColor: Colors.yellow,
          backgroundImage: groupData?.imageUrl == null
              ? null
              : NetworkImage(groupData!.imageUrl!),
          child: groupData?.imageUrl != null ? null : const FlutterLogo(),
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: PopupMenuButton(
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'update',
                child: Text('Update info'),
              ),
            ],
            onSelected: (value) {
              if (value == 'update') {
                Navigator.of(context).pushNamed(appRouteAddUpdateGroupScreen,
                    arguments: groupData);
              }
            },
          ),
        ),
        title: Text(groupData!.name!),
        onTap: () {
          Navigator.of(context)
              .pushNamed(appRouteChatScreen, arguments: groupData);
        },
      ),
    );
  }
}
