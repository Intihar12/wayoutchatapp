import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wayoutchatapp/api/apis.dart';
import 'package:wayoutchatapp/modals/messages_modal.dart';

import '../main.dart';
import '../modals/chat_user_modal.dart';
import '../screens/chat_screen.dart';
import '../screens/date_formated.dart';
import 'dialods/profile_dialog.dart';

class CartChatUser extends StatefulWidget {
  CartChatUser({Key? key, required this.user}) : super(key: key);
  ChatUserModal user;

  @override
  State<CartChatUser> createState() => _CartChatUserState();
}

class _CartChatUserState extends State<CartChatUser> {
  MessagesModal? messagesModal;

  @override
  Widget build(BuildContext context) {
    print("intuuuu");
    print(widget.user.image);
    print("intuuuu");

    return Card(
      elevation: 0.5,
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChatScreen(
                        user: widget.user,
                      )));
        },
        child: StreamBuilder(
            stream: Apis.getLastMessages(widget.user),
            builder: (context, snapShot) {
              final data = snapShot.data?.docs;
              final list = data?.map((e) => MessagesModal.fromJson(e.data())).toList() ?? [];

              if (list.isNotEmpty) {
                messagesModal = list[0];
              }
              return ListTile(
                leading: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => ProfileDialog(
                              user: widget.user,
                            ));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .3),
                    child: CachedNetworkImage(
                      width: mq.width * .055,
                      height: mq.height * .055,
                      fit: BoxFit.fill,
                      imageUrl: widget.user.image!,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
                title: Text(widget.user.name.toString()),
                subtitle: Text(messagesModal != null
                    ? messagesModal!.type == Type.image
                        ? "Image"
                        : messagesModal!.msg.toString()
                    : widget.user.about.toString()),
                trailing: messagesModal == null
                    ? null
                    : messagesModal!.read == null && Apis.user.uid != messagesModal!.fromId
                        ? Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green),
                          )
                        : Text(MyDateUtils.getLastMessageTime(context: context, lastTime: messagesModal!.sent)),
                // trailing: Text(
                //   "12:00 pm",
                //   style: TextStyle(color: Colors.black54),
                // ),
              );
            }),
      ),
    );
  }
}
