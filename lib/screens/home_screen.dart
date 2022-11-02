import '../helpers/groups_helper.dart';
import '../values/app_routes.dart';
import '../values/collections.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/curved_header_container_widget.dart';
import '../widgets/group_tile_widget.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/loader_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final grouppStream =
        FirebaseFirestore.instance.collection(collectionGroups).snapshots();
    return Scaffold(
        drawer: const DrawerWidget(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(appRouteAddUpdateGroupScreen);
          },
          child: const Icon(Icons.group_add_outlined),
        ),
        appBar: const AppBarWidget(
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder(
                  stream: grouppStream,
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LoaderWidget();
                    }
                    final listLength = snapshot.data?.docs.length;
                    return CurvedHeaderConyainerWidget(
                      title: 'Chats',
                      subTitle: '$listLength Chats',
                    );
                  },
                ),
                const SizedBox(height: 20),
                StreamBuilder(
                  stream: GroupsHelper().getAllGroupsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LoaderWidget();
                    }
                    final groupList = snapshot.data;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: groupList!.length,
                      itemBuilder: (context, index) =>
                          GroupTileWidget(groupData: groupList[index]),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
