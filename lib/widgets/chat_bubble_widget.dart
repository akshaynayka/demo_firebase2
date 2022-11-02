import '../helpers/user_helper.dart';
import '../models/message.dart';
import '../models/user.dart';
import '../widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubbleWidget extends StatefulWidget {
  const ChatBubbleWidget(
      {required this.currentUserId,
      // required this.receiverUser,
      required this.message,
      super.key});
  final Message message;
  final String currentUserId;
  // final User? receiverUser;

  @override
  State<ChatBubbleWidget> createState() => _ChatBubbleWidgetState();
}

class _ChatBubbleWidgetState extends State<ChatBubbleWidget> {
  User? _userData = User();
  var _isLoading = true;
  @override
  void initState() {
    _getData();
    super.initState();
  }

  Future<void> _getData() async {
    _userData =
        await UsersHelper().getUserDetails(userId: widget.message.senderId);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = widget.currentUserId == widget.message.senderId;
    return _isLoading
        ? const LoaderWidget()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!currentUser)
                Padding(
                  padding: const EdgeInsets.only(left: 70.0),
                  child: Text(_userData!.name!),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: currentUser
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  if (!currentUser)
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.yellow,
                      backgroundImage: _userData?.imageUrl == null
                          ? null
                          : NetworkImage(
                              _userData!.imageUrl!,
                            ),
                      child: _userData?.imageUrl != null
                          ? null
                          : const FlutterLogo(),
                    ),
                  UnconstrainedBox(
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      children: [
                        Container(
                          width: 200,
                          margin: EdgeInsets.only(
                            left: currentUser ? 0 : 10,
                            right: currentUser ? 10 : 0,
                            top: 5,
                            bottom: 5,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20.0),
                          decoration: BoxDecoration(
                            color: currentUser
                                ? Colors.blue[100]
                                : Colors.grey[300],
                            borderRadius: BorderRadius.only(
                              topLeft: currentUser
                                  ? const Radius.circular(7)
                                  : const Radius.circular(0),
                              topRight: currentUser
                                  ? const Radius.circular(0)
                                  : const Radius.circular(7),
                              bottomRight: currentUser
                                  ? const Radius.circular(27)
                                  : const Radius.circular(7),
                              bottomLeft: !currentUser
                                  ? const Radius.circular(27)
                                  : const Radius.circular(7),
                            ),
                          ),
                          child: Text(widget.message.message!),
                        ),
                        Positioned(
                          right: currentUser ? null : 7,
                          left: !currentUser ? null : 7,
                          bottom: 7,
                          child: Text(
                            DateFormat("h:mm a")
                                .format(
                                    DateTime.parse(widget.message.createdAt!))
                                .toString(),
                            style: TextStyle(
                                fontSize: 12.0, color: Colors.grey[600]),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
  }
}
