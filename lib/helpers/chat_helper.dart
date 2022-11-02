import '../models/message.dart';
import '../values/collections.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatHelper {
  // Stream<List<Message>> getSingleUserChatStream(
  //     {required String senderId, required String receiverId}) {
  //   return FirebaseFirestore.instance
  //       .collection(collectionChats)
  //       .where('receiverId', whereIn: [receiverId, senderId])
  //       .orderBy('createdAt', descending: true)
  //       .snapshots()
  //       .map(
  //         (snapshot) => snapshot.docs
  //             .map(
  //               (doc) => Message.fromJson(
  //                 doc.data(),
  //               ),
  //             )
  //             .toList(),
  //       );
  // }

  Stream<List<Message>> getGroupChatStream({required String groupId}) {
    return FirebaseFirestore.instance
        .collection(collectionChats)
        .where('groupId', isEqualTo: groupId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Message.fromJson(
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  // Future<String> getChatRoomId({required List<String> users}) async {
  //   final chatRoomInstance = await FirebaseFirestore.instance
  //       .collection(collectionChatRooms)
  //       .where('users', arrayContains: '')
  //       .where('users', arrayContains: '00')
  //       .get()
  //       .then((value) => value.docs);
  //   if (chatRoomInstance.isEmpty) {
  //   }

  //   return 'chatRoomInstance';
  // }
}
