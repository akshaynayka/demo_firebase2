import '../models/group.dart';
import '../values/collections.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupsHelper {
  Stream<List<Group>> getAllGroupsStream() {
    return FirebaseFirestore.instance
        .collection(collectionGroups)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Group.fromJson(
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Future<String> createUpdateGroup({required Group groupData}) async {
    var status = 'Group created';
    final groupInstance = FirebaseFirestore.instance
        .collection(collectionGroups)
        .doc(groupData.id);

    if (groupData.id != null) {
      groupInstance.update(groupData.toJson());
     status = 'Group details updated';

    } else {
      groupData.id = groupInstance.id;
      groupData.createdAt = DateTime.now().toIso8601String();
      await groupInstance.set(groupData.toJson());
    }
    return status;
  }
}
