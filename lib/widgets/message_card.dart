import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:wayoutchatapp/api/apis.dart';
import 'package:wayoutchatapp/modals/messages_modal.dart';

import '../diologs/diologs_screen.dart';
import '../main.dart';
import '../screens/date_formated.dart';

class MessageCard extends StatefulWidget {
  MessageCard({Key? key, required this.message}) : super(key: key);
  final MessagesModal message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = Apis.user.uid == widget.message.fromId;
    return InkWell(
      onLongPress: () {
        showBottomSheet(isMe);
      },
      child: isMe ? _greenMessage() : _blueMessage(),
    );
    // return Apis.user.uid == widget.message.fromId ? _greenMessage() : _blueMessage();
  }

  Widget _blueMessage() {
    if (widget.message.read == null) {
      Apis.updateMessageReadStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image ? mq.width * .03 : mq.width * .04),
            margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: mq.height * .03),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 221, 245, 255),
                border: Border.all(color: Colors.lightBlue),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomRight: Radius.circular(30))),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg.toString(),
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .03),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg!,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(
                        Icons.error,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
        Row(
          children: [
            Text(
              //  widget.message.sent.toString(),
              MyDateUtils.getFormatTime(context, widget.message.sent),

              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            // SizedBox(
            //   width: 2,
            // ),
            // IconButton(
            //     onPressed: () {},
            //     icon: Icon(
            //       Icons.done_all_rounded,
            //       color: Colors.blue,
            //       size: 20,
            //     )),
            SizedBox(
              width: mq.width * .04,
            ),
          ],
        ),
      ],
    );
  }

  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: mq.width * .04,
            ),
            if (widget.message.read != null)
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.done_all_rounded,
                    color: Colors.blue,
                    size: 20,
                  )),
            SizedBox(
              width: 2,
            ),
            Text(
              //  widget.message.sent.toString(),
              MyDateUtils.getFormatTime(context, widget.message.sent),
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image ? mq.width * .03 : mq.width * .04),
            margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 218, 255, 176),
                border: Border.all(color: Colors.lightGreen),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomRight: Radius.circular(30))),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg.toString(),
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .03),
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: widget.message.msg!,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
          ),
        ),
      ],
    );
    ;
  }

  void showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05, left: mq.width * .05),
            children: [
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(vertical: mq.height * .015, horizontal: mq.width * .4),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey),
              ),
              widget.message.type == Type.text
                  ? _Options(
                      icon: Icon(
                        Icons.copy_all_outlined,
                        color: Colors.blue,
                      ),
                      name: "copy Text",
                      ontap: () {
                        Clipboard.setData(ClipboardData(text: widget.message.msg.toString()))
                            .then((value) => {Navigator.pop(context), Dialogs.showSnackBar(context, "Text Copied!")});
                      },
                    )
                  : _Options(
                      icon: Icon(
                        Icons.download,
                        color: Colors.blue,
                      ),
                      name: "Image",
                      ontap: () async {
                        print("image :: " + widget.message.msg.toString());
                        await GallerySaver.saveImage(widget.message.msg.toString(), albumName: "chat app")
                            .then((success) {
                          Navigator.pop(context);
                          if (success != null && success) {
                            Dialogs.showSnackBar(context, "Successfully image saved");
                          }
                        });
                      },
                    ),
              Divider(
                color: Colors.black54,
                endIndent: mq.width * .04,
                indent: mq.width * .04,
              ),
              if (widget.message.type == Type.text && isMe)
                _Options(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  name: "Edit Message",
                  ontap: () {},
                ),
              if (isMe)
                _Options(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 26,
                  ),
                  name: "Delete Message",
                  ontap: () {
                    Apis.deleteMessage(widget.message).then((value) {
                      Navigator.pop(context);
                    });
                  },
                ),
              if (isMe)
                Divider(
                  color: Colors.black54,
                  endIndent: mq.width * .04,
                  indent: mq.width * .04,
                ),
              _Options(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Colors.blue,
                ),
                name: "Sent At:  ${MyDateUtils.getMessageTime(context: context, lastTime: widget.message.sent)}",
                ontap: () {},
              ),
              _Options(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Colors.green,
                ),
                name: widget.message.read == null
                    ? "REad At Not yet"
                    : "Read At:  ${MyDateUtils.getMessageTime(context: context, lastTime: widget.message.read)}",
                ontap: () {},
              )
            ],
          );
        });
  }
}

class _Options extends StatelessWidget {
  final String name;
  final Icon icon;
  final VoidCallback ontap;

  const _Options({required this.name, required this.icon, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: ontap,
        child: Padding(
          padding: EdgeInsets.only(top: mq.height * .015, left: mq.width * .05, bottom: mq.height * .02),
          child: Row(
            children: [
              icon,
              Text(
                "    ${name}",
                style: TextStyle(fontSize: 15, color: Colors.black54, letterSpacing: 0.5),
              ),
            ],
          ),
        ));
  }
}
