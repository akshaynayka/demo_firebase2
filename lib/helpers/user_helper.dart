import '../models/user.dart' as user;
import '../values/collections.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsersHelper {
  Stream<List<user.User>> getAllUsersStream({required String currentUserId}) {
    return FirebaseFirestore.instance
        .collection(collectionUsers)
        .where('id', isNotEqualTo: currentUserId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => user.User.fromJson(
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Future<user.User?> getUserDetails({required String? userId}) async {
    if (userId != null) {
      final userDetails =
          FirebaseFirestore.instance.collection(collectionUsers).doc(userId);
      final snapshot = await userDetails.get();
      if (snapshot.exists) {
        return user.User.fromJson(snapshot.data()!);
      }
    }
    return null;
  }

  // Future<user.User?> getCurrentUserData() async {
  //   final currentAuthId = FirebaseAuth.instance.currentUser!.uid;
  //   final currentUserData = await FirebaseFirestore.instance
  //       .collection(collectionUsers)
  //       .where('authId', isEqualTo: currentAuthId)
  //       .get()
  //       .then((value) => user.User.fromJson(value.docs.first.data()));

  //   return currentUserData;
  // }

  Future<user.User?> getCurrentUserData() async {
    final currentAuthId = FirebaseAuth.instance.currentUser!.uid;
    final currentUser = getUserDetails(userId: currentAuthId);
    return currentUser;
  }

  Future<void> createUser({required user.User userData}) async {
    final userInstance =
        FirebaseFirestore.instance.collection(collectionUsers).doc(userData.id);
    await userInstance.set(userData.toJson());
  }
}
