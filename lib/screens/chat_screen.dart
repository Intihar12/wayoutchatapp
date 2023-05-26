import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayoutchatapp/screens/view_profile_screen.dart';
import '../api/apis.dart';
import '../main.dart';
import '../modals/chat_user_modal.dart';
import '../modals/messages_modal.dart';
import '../widgets/message_card.dart';
import 'date_formated.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key, required this.user}) : super(key: key);
  final ChatUserModal user;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<MessagesModal> _list = [];
  final textController = TextEditingController();
  bool _isEmoji = false, isUploadingImage = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isEmoji) {
            setState(() {
              _isEmoji = !_isEmoji;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: SafeArea(
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
                                reverse: true,
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
              if (isUploadingImage)
                Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: CircularProgressIndicator(),
                    )),
              _chatInput(),
              if (_isEmoji)
                SizedBox(
                  height: mq.height * .35,
                  child: EmojiPicker(
                    textEditingController: textController,
                    // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                    config: Config(
                      columns: 7,
                      emojiSizeMax: 32 *
                          (Platform.isAndroid ? 1.0 : 1.35), // Issue: https://github.com/flutter/flutter/issues/28894
                    ),
                  ),
                ),
            ],
          ),
        )),
      ),
    );
  }

  Widget _appBar() {
    return StreamBuilder(
        stream: Apis.getUserInfo(widget.user),
        builder: (context, snapshot) {
          final data = snapshot.data?.docs;

          final list = data?.map((e) => ChatUserModal.fromJson(e.data())).toList() ?? [];

          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ViewProfileScreen(user: widget.user)));
            },
            child: Row(
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
                    imageUrl: list.isNotEmpty ? list[0].image.toString() : widget.user.image!,
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
                      list.isNotEmpty ? list[0].name.toString() : widget.user.name.toString(),
                      style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      list.isNotEmpty
                          ? list[0].isOnline!
                              ? "Online"
                              : MyDateUtils.getLastActiveTimeDate(context: context, lastActive: list[0].lastActive)
                          : MyDateUtils.getLastActiveTimeDate(context: context, lastActive: widget.user.lastActive),
                      style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                    )
                  ],
                )
              ],
            ),
          );
        });
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
                      onPressed: () {
                        // FocusScope.of(context).unfocus();
                        setState(() => _isEmoji = !_isEmoji);
                      },
                      icon: Icon(
                        Icons.emoji_emotions,
                        color: Colors.blueAccent,
                      )),
                  Expanded(
                      child: TextFormField(
                    controller: textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {
                      if (_isEmoji) {
                        setState(() => _isEmoji = !_isEmoji);
                      }
                    },
                    decoration: InputDecoration(
                        hintText: "Type someThing ...",
                        hintStyle: TextStyle(
                          color: Colors.blueAccent,
                        ),
                        border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
// Pick an image.
                        final List<XFile> images = await picker.pickMultiImage(imageQuality: 07);
                        if (images.isNotEmpty) {
                          for (var i in images) {
                            setState(() {
                              isUploadingImage = true;
                            });

                            Apis.setChateImage(widget.user, File(i.path));
                            setState(() {
                              isUploadingImage = false;
                            });
                          }
                        }
                      },
                      icon: Icon(
                        Icons.image,
                        color: Colors.blueAccent,
                      )),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
// Pick an image.
                        final XFile? image = await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          setState(() {
                            isUploadingImage = true;
                          });

                          Apis.setChateImage(widget.user, File(image.path));
                          setState(() {
                            isUploadingImage = false;
                          });
                        }
                      },
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
                isUploadingImage = true;
                Apis.sendMessage(widget.user, textController.text, Type.text);
                isUploadingImage = false;
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
