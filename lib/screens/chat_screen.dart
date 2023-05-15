import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';
import '../main.dart';
import '../modals/chat_user_modal.dart';
import '../modals/messages_modal.dart';
import '../widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key, required this.user}) : super(key: key);
  final ChatUserModal user;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<MessagesModal> _list = [];
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: _appBar(),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: Apis.getAllMessages(widget.user),
                builder: (context, snapshot) {
                  print("intuu snapshot: ${snapshot}");
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                    // return Center(
                    //   child: CircularProgressIndicator(),
                    // );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;

                      _list = data?.map((e) => MessagesModal.fromJson(e.data())).toList() ?? [];

                      // final _list = [];
                      if (_list.isNotEmpty) {
                        return ListView.builder(
                            itemCount: _list.length,
                            padding: EdgeInsets.only(top: mq.height * .01),
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return MessageCard(
                                message: _list[index],
                              );
                              // Text("message ${_list[index]}");
                            });
                      } else {
                        return Center(child: Text("Say hi 👏"));
                      }
                  }
                }),
          ),
          _chatInput()
        ],
      ),
    ));
  }

  Widget _appBar() {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black54,
            )),
        ClipRRect(
          borderRadius: BorderRadius.circular(mq.height * .3),
          child: CachedNetworkImage(
            width: mq.width * .05,
            height: mq.height * .05,
            fit: BoxFit.fill,
            imageUrl: widget.user.image!,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.user.name.toString(),
              style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              widget.user.email.toString(),
              style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
            )
          ],
        )
      ],
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: mq.height * 0.01, horizontal: mq.width * .025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.emoji_emotions,
                        color: Colors.blueAccent,
                      )),
                  Expanded(
                      child: TextFormField(
                    controller: textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: "Type someThing ...",
                        hintStyle: TextStyle(
                          color: Colors.blueAccent,
                        ),
                        border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.image,
                        color: Colors.blueAccent,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.blueAccent,
                      )),
                  SizedBox(
                    width: mq.width * .02,
                  )
                ],
              ),
            ),
          ),
          MaterialButton(
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            minWidth: 0,
            onPressed: () {
              if (textController.text.isNotEmpty) {
                Apis.sendMessage(widget.user, textController.text);
                textController.clear();
              }
            },
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
            shape: CircleBorder(),
            color: Colors.green,
          )
        ],
      ),
    );
  }
}
