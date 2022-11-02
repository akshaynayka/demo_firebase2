import '../helpers/chat_helper.dart';
import '../helpers/user_helper.dart';
import '../models/group.dart';
import '../models/message.dart';
import '../models/user.dart' as user;
import '../values/collections.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/chat_bubble_widget.dart';
import '../widgets/loader_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isInit = true;
  bool _isLoading = true;
  Group? _groupData;
  user.User? _currentUserData;
  TextEditingController newMessageController = TextEditingController();
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _groupData = ModalRoute.of(context)!.settings.arguments as Group;
     _currentUserData = await UsersHelper().getCurrentUserData();

      setState(() {
        _isLoading = false;
        _isInit = true;
      });
    }

    super.didChangeDependencies();
  }

  Future<void> _sendMessage() async {
    final messageInstance =
        FirebaseFirestore.instance.collection(collectionChats).doc();

    final newMessage = Message(
      id: messageInstance.id,
      message: newMessageController.text.trim(),
      senderId: _currentUserData!.id,
      receiverId: null,
      groupId: _groupData!.id,
      createdAt: DateTime.now().toIso8601String(),
    );

    await messageInstance.set(newMessage.toJson()).then((value) {
      newMessageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: _groupData!.name!,
      ),
      body: _isLoading
          ? const LoaderWidget()
          : Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: ChatHelper()
                        .getGroupChatStream(groupId: _groupData!.id!),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LoaderWidget();
                      }

                      final chatList = snapshot.data;
                      return ListView.builder(
                          reverse: true,
                          itemCount: chatList!.length,
                          itemBuilder: (ctx, index) => ChatBubbleWidget(
                              currentUserId: _currentUserData!.id!,
                              message: chatList[index]));
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                          controller: newMessageController,
                          textCapitalization: TextCapitalization.sentences,
                          autocorrect: true,
                          enableSuggestions: true,
                          decoration: const InputDecoration(
                              labelText: 'Send a message...'),
                        ),
                      ),
                      IconButton(
                        color: Theme.of(context).primaryColor,
                        icon: const Icon(
                          Icons.send,
                        ),
                        onPressed: () async {
                          if (newMessageController.text.trim().isNotEmpty) {
                            await _sendMessage();
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
