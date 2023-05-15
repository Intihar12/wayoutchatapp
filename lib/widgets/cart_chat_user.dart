import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../modals/chat_user_modal.dart';
import '../screens/chat_screen.dart';

class CartChatUser extends StatefulWidget {
  CartChatUser({Key? key, required this.user}) : super(key: key);
  ChatUserModal user;
  @override
  State<CartChatUser> createState() => _CartChatUserState();
}

class _CartChatUserState extends State<CartChatUser> {
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
        child: ListTile(
          leading: ClipRRect(
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
          title: Text(widget.user.name.toString()),
          subtitle: Text(widget.user.about.toString()),
          trailing: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green),
          ),
          // trailing: Text(
          //   "12:00 pm",
          //   style: TextStyle(color: Colors.black54),
          // ),
        ),
      ),
    );
  }
}
