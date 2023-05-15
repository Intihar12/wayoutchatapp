import 'package:flutter/material.dart';
import 'package:wayoutchatapp/api/apis.dart';
import 'package:wayoutchatapp/modals/messages_modal.dart';

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
    return Apis.user.uid == widget.message.fromId ? _greenMessage() : _blueMessage();
  }

  Widget _blueMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 221, 245, 255),
                border: Border.all(color: Colors.lightBlue),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomRight: Radius.circular(30))),
            child: Text(
              widget.message.msg.toString(),
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ),
        Row(
          children: [
            Text(
              MyDateUtils.getFormatTime(context, widget.message.sent.toString()),
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
            if (widget.message.read!.isNotEmpty)
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
              MyDateUtils.getFormatTime(context, widget.message.sent.toString()),
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 218, 255, 176),
                border: Border.all(color: Colors.lightGreen),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomRight: Radius.circular(30))),
            child: Text(
              widget.message.msg.toString(),
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ),
      ],
    );
    ;
  }
}
