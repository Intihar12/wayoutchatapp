// //import 'package:audioplayers/audioplayers.dart';
// import 'dart:async';
// import 'dart:io';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:path_provider/path_provider.dart';
//
// //import 'package:just_audio/just_audio.dart';
// import 'package:wayoutchatapp/api/apis.dart';
// import 'package:wayoutchatapp/modals/messages_modal.dart';
// //import 'package:just_audio/just_audio.dart';
//
// import '../diologs/diologs_screen.dart';
// import '../main.dart';
// import '../modals/chat_user_modal.dart';
// import '../screens/date_formated.dart';
//
// class MessageCard extends StatefulWidget {
//   MessageCard({Key? key, required this.message, required this.image, required this.user}) : super(key: key);
//   final MessagesModal message;
//   String? image;
//   ChatUserModal user;
//
//   @override
//   State<MessageCard> createState() => _MessageCardState();
// }
//
// class _MessageCardState extends State<MessageCard> {
//   //AudioPlayer audioPlayer = AudioPlayer();
//
//   // todo for play
//
//   late Directory directory;
//   String? path;
//   bool isSlider = false;
//
//   // todo for play
//   final _audioPlayer = AudioPlayer();
//   bool playStop = false;
//   late Future<Duration?> futureDuration;
//
//   late StreamSubscription<PlayerState> _playerStateChangedSubscription;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     playStop = !playStop;
//     _playerStateChangedSubscription = _audioPlayer.playerStateStream.listen(playerStateListener);
//     futureDuration = _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(widget.message.msg.toString())));
//
//     // _initialiseControllers();
//   }
//
//   void playerStateListener(PlayerState state) async {
//     if (state.processingState == ProcessingState.completed) {
//       await reset();
//     }
//   }
//
//   @override
//   void dispose() {
//     _playerStateChangedSubscription.cancel();
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     bool isMe = Apis.user.uid == widget.message.fromId;
//     return InkWell(
//       onLongPress: () {
//         showBottomSheet(isMe);
//       },
//       child: isMe ? _greenMessage() : _blueMessage(),
//     );
//     // return Apis.user.uid == widget.message.fromId ? _greenMessage() : _blueMessage();
//   }
//
//   Widget _blueMessage() {
//     if (widget.message.read == null) {
//       Apis.updateMessageReadStatus(widget.message);
//     }
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Flexible(
//           child: Container(
//             padding: _buildPadding(widget.message.type),
//             //  padding: EdgeInsets.all(widget.message.type == Type.image ? mq.width * .03 : mq.width * .03),
//             margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: mq.height * .03),
//             decoration: BoxDecoration(
//                 color: Color.fromARGB(255, 221, 245, 255),
//                 border: Border.all(color: Colors.lightBlue),
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(15), topRight: Radius.circular(15), bottomRight: Radius.circular(15))),
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 _buildBlueMessage(widget.message.type),
//                 Positioned(
//                     right: widget.message.type == Type.audio ? 70 : 5,
//                     bottom: -10,
//                     child: Container(
//                       child: Row(
//                         children: [
//                           Text(
//                             //  widget.message.sent.toString(),
//                             MyDateUtils.getFormatTime(context, widget.message.sent),
//
//                             style: TextStyle(fontSize: 11, color: Colors.black54),
//                           ),
//                         ],
//                       ),
//                     )),
//                 widget.message.type == Type.audio
//                     ? Positioned(
//                         top: 30,
//                         right: 40,
//                         child: Container(
//                           child: Icon(
//                             Icons.mic,
//                             color: Colors.blue,
//                           ),
//                         ))
//                     : SizedBox()
//               ],
//             ),
//           ),
//         ),
//         SizedBox(
//           width: mq.width * .14,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildBlueMessage(Type? type) {
//     bool isMe = Apis.user.uid == widget.message.fromId;
//     print("type");
//     print(type);
//     switch (type) {
//       case Type.image:
//         return ClipRRect(
//           borderRadius: BorderRadius.circular(mq.height * .02),
//           child: CachedNetworkImage(
//             imageUrl: widget.message.msg!,
//             placeholder: (context, url) => CircularProgressIndicator(),
//             errorWidget: (context, url, error) => Icon(
//               Icons.error,
//               size: 70,
//             ),
//           ),
//         );
//       case Type.audio:
//         return FutureBuilder<Duration?>(
//           future: futureDuration,
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return Row(
//                 children: <Widget>[
//                   SizedBox(
//                     width: mq.width * .02,
//                   ),
//                   isMe
//                       ? ClipRRect(
//                           borderRadius: BorderRadius.circular(mq.height * .3),
//                           child: CachedNetworkImage(
//                             width: mq.width * .15,
//                             // height: mq.height * .05,
//                             fit: BoxFit.fill,
//                             imageUrl: widget.user.image!,
//                             placeholder: (context, url) => CircularProgressIndicator(),
//                             errorWidget: (context, url, error) => Icon(Icons.error),
//                           ),
//                         )
//                       : SizedBox(),
//                   _controlButtons(),
//                   _slider(snapshot.data),
//                   isMe
//                       ? SizedBox()
//                       : ClipRRect(
//                           borderRadius: BorderRadius.circular(mq.height * .3),
//                           child: CachedNetworkImage(
//                             width: mq.width * .15,
//                             //   height: mq.height * .05,
//                             fit: BoxFit.fill,
//                             imageUrl: widget.image.toString(),
//                             placeholder: (context, url) => CircularProgressIndicator(),
//                             errorWidget: (context, url, error) => Icon(Icons.error),
//                           ),
//                         ),
//                 ],
//               );
//             }
//             return Container(
//                 width: 200,
//                 margin: EdgeInsets.symmetric(horizontal: 90),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: const CircularProgressIndicator(
//                     strokeWidth: 3,
//                   ),
//                 ));
//           },
//         );
//
//       // InkWell(
//       //   onTap: () async {
//       //     print("playsound");
//       //     print(playStop);
//       //     playStop = !playStop;
//       //     playStop ? await audioPlayer.play(UrlSource(widget.message.msg.toString())) : await audioPlayer.pause();
//       //     print("soundd");
//       //     print(playStop);
//       //     setState(() {});
//       //     // await playVoiceMessage(widget.message.msg.toString());
//       //   },
//       //   child: Text("click me"));
//
//       case Type.text:
//         return Container(
//           child: Text(
//             "${widget.message.msg.toString()}" + "               ",
//             style: TextStyle(fontSize: 15, color: Colors.black87),
//           ),
//         );
//
//       default:
//         return SizedBox();
//         break;
//     }
//   }
//
//   // todo
//   _buildPadding(Type? type) {
//     print("type");
//     print(type);
//     switch (type) {
//       case Type.image:
//         return EdgeInsets.all(mq.width * .03);
//       case Type.audio:
//         return EdgeInsets.only(bottom: mq.width * .034, right: mq.width * .01, top: mq.width * .02);
//
//       case Type.text:
//         return EdgeInsets.only(
//             left: mq.width * .03, right: mq.width * .01, top: mq.height * .01, bottom: mq.height * .02);
//
//       default:
//         return SizedBox();
//         break;
//     }
//   }
//
//   Widget _greenMessage() {
//     return Row(
//       //crossAxisAlignment: CrossAxisAlignment,
//       //mainAxisAlignment: MainAxisAlignment.end,
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         SizedBox(
//           width: mq.width * .15,
//         ),
//         // Row(
//         //   children: [
//         //     SizedBox(
//         //       width: mq.width * .01,
//         //     ),
//         //     if (widget.message.read != null)
//         //       IconButton(
//         //           onPressed: () {},
//         //           icon: Icon(
//         //             Icons.done_all_rounded,
//         //             color: Colors.blue,
//         //             size: mq.width * .06,
//         //           )),
//         //     SizedBox(
//         //       width: mq.width * .001,
//         //     ),
//         //     Text(
//         //       //  widget.message.sent.toString(),
//         //       MyDateUtils.getFormatTime(context, widget.message.sent),
//         //       style: TextStyle(fontSize: 11, color: Colors.black54),
//         //     ),
//         //   ],
//         // ),
//         Flexible(
//           child: Container(
//             // width: widget.message.type == Type.text ? mq.width * .3 : null,
//             padding: _buildPadding(widget.message.type),
//             // padding: EdgeInsets.all(widget.message.type == Type.image ? mq.width * .043 : mq.width * .03),
//             margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: mq.height * .02),
//             decoration: BoxDecoration(
//                 color: Color.fromARGB(255, 218, 255, 176),
//                 border: Border.all(color: Colors.lightGreen),
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(15), topRight: Radius.circular(15), bottomLeft: Radius.circular(15))),
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 _buildBlueMessage(widget.message.type),
//                 Positioned(
//                     right: 2,
//                     bottom: -12,
//                     child: Container(
//                       child: Row(
//                         children: [
//                           Text(
//                             //  widget.message.sent.toString(),
//                             MyDateUtils.getFormatTime(context, widget.message.sent),
//                             style: TextStyle(fontSize: 11, color: Colors.black54),
//                           ),
//                           if (widget.message.read != null)
//                             Icon(
//                               Icons.done_all_rounded,
//                               color: Colors.blue,
//                               size: mq.width * .04,
//                             ),
//                         ],
//                       ),
//                     )),
//                 widget.message.type == Type.audio
//                     ? Positioned(
//                         top: 30,
//                         left: 40,
//                         child: Container(
//                           child: Icon(
//                             Icons.mic,
//                             color: Colors.blue,
//                           ),
//                         ))
//                     : SizedBox()
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//     ;
//   }
//
//   void showMessageUpdateDialog() {
//     String updateMessage = widget.message.msg.toString();
//     showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//               title: Row(
//                 children: [
//                   Icon(
//                     Icons.message,
//                     color: Colors.blue,
//                     size: 28,
//                   ),
//                   Text("Update Message"),
//                 ],
//               ),
//               content: TextFormField(
//                 initialValue: updateMessage,
//                 maxLines: null,
//                 onChanged: (value) => updateMessage = value,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
//                 ),
//               ),
//               actions: [
//                 MaterialButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text(
//                     "cancel",
//                     style: TextStyle(color: Colors.blue, fontSize: 16),
//                   ),
//                 ),
//                 MaterialButton(
//                   onPressed: () {
//                     Apis.updateMessage(widget.message, updateMessage);
//                     Navigator.pop(context);
//                   },
//                   child: Text(
//                     "Update",
//                     style: TextStyle(color: Colors.blue, fontSize: 16),
//                   ),
//                 )
//               ],
//             ));
//   }
//
//   void showBottomSheet(bool isMe) {
//     showModalBottomSheet(
//         context: context,
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//         builder: (_) {
//           return ListView(
//             shrinkWrap: true,
//             padding: EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05, left: mq.width * .05),
//             children: [
//               Container(
//                 height: 4,
//                 margin: EdgeInsets.symmetric(vertical: mq.height * .015, horizontal: mq.width * .4),
//                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey),
//               ),
//               widget.message.type == Type.text
//                   ? _Options(
//                       icon: Icon(
//                         Icons.copy_all_outlined,
//                         color: Colors.blue,
//                       ),
//                       name: "copy Text",
//                       ontap: () {
//                         Clipboard.setData(ClipboardData(text: widget.message.msg.toString()))
//                             .then((value) => {Navigator.pop(context), Dialogs.showSnackBar(context, "Text Copied!")});
//                       },
//                     )
//                   : _Options(
//                       icon: Icon(
//                         Icons.download,
//                         color: Colors.blue,
//                       ),
//                       name: "Image",
//                       ontap: () async {
//                         print("image :: " + widget.message.msg.toString());
//                         await GallerySaver.saveImage(widget.message.msg.toString(), albumName: "chat app")
//                             .then((success) {
//                           Navigator.pop(context);
//                           if (success != null && success) {
//                             Dialogs.showSnackBar(context, "Successfully image saved");
//                           }
//                         });
//                       },
//                     ),
//               Divider(
//                 color: Colors.black54,
//                 endIndent: mq.width * .04,
//                 indent: mq.width * .04,
//               ),
//               if (widget.message.type == Type.text && isMe)
//                 _Options(
//                   icon: Icon(
//                     Icons.edit,
//                     color: Colors.blue,
//                   ),
//                   name: "Edit Message",
//                   ontap: () {},
//                 ),
//               if (isMe)
//                 _Options(
//                   icon: Icon(
//                     Icons.delete,
//                     color: Colors.red,
//                     size: 26,
//                   ),
//                   name: "Delete Message",
//                   ontap: () {
//                     Apis.deleteMessage(widget.message).then((value) {
//                       Navigator.pop(context);
//                     });
//                   },
//                 ),
//               if (isMe)
//                 Divider(
//                   color: Colors.black54,
//                   endIndent: mq.width * .04,
//                   indent: mq.width * .04,
//                 ),
//               _Options(
//                 icon: Icon(
//                   Icons.remove_red_eye,
//                   color: Colors.blue,
//                 ),
//                 name: "Sent At:  ${MyDateUtils.getMessageTime(context: context, lastTime: widget.message.sent)}",
//                 ontap: () {},
//               ),
//               _Options(
//                 icon: Icon(
//                   Icons.remove_red_eye,
//                   color: Colors.green,
//                 ),
//                 name: widget.message.read == null
//                     ? "REad At Not yet"
//                     : "Read At:  ${MyDateUtils.getMessageTime(context: context, lastTime: widget.message.read)}",
//                 ontap: () {},
//               )
//             ],
//           );
//         });
//   }
//
// //todo playmessage
//
//   Widget _controlButtons() {
//     return Container(
//       // color: Colors.red,
//       child: StreamBuilder<bool>(
//         stream: _audioPlayer.playingStream,
//         builder: (context, _) {
//           final color = _audioPlayer.playerState.playing ? Colors.red : Colors.grey;
//           final icon = _audioPlayer.playerState.playing ? Icons.pause : Icons.play_arrow;
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 0.0, right: 0),
//             child: GestureDetector(
//               onTap: () {
//                 Apis.updateAudioMessageReadStatus(widget.message);
//                 if (_audioPlayer.playerState.playing) {
//                   pause();
//                 } else {
//                   play();
//                 }
//               },
//               child: Center(
//                 child: Container(
//                   alignment: Alignment.center,
//                   //  color: Colors.pink,
//                   width: 40,
//                   height: 40,
//                   child: Center(child: Icon(icon, color: color, size: 40)),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
// //
//   Widget _slider(Duration? duration) {
//     bool isMe = Apis.user.uid == widget.message.fromId;
//     return StreamBuilder<Duration>(
//       stream: _audioPlayer.positionStream,
//       builder: (context, snapshot) {
//         if (snapshot.hasData && duration != null) {
//           return Container(
//             margin: EdgeInsets.only(top: 3),
//             height: 10,
//             // color: Colors.yellow,
//             width: isMe ? mq.width * .45 : mq.width * .45,
//             child: SliderTheme(
//               data: SliderThemeData(
//                 overlayShape: SliderComponentShape.noOverlay,
//                 thumbShape: RoundSliderThumbShape(
//                   enabledThumbRadius: 8,
//                 ),
//               ),
//               child: Slider(
//                 inactiveColor: Colors.grey,
//                 thumbColor: widget.message.readAudio == true ? Colors.blue : Colors.green,
//                 value: snapshot.data!.inMicroseconds / duration.inMicroseconds,
//                 onChanged: (val) {
//                   _audioPlayer.seek(duration * val);
//                 },
//               ),
//             ),
//           );
//         } else {
//           return const SizedBox.shrink();
//         }
//       },
//     );
//   }
//
//   Future<void> play() {
//     return _audioPlayer.play();
//   }
//
//   Future<void> pause() {
//     return _audioPlayer.pause();
//   }
//
//   Future<void> reset() async {
//     await _audioPlayer.stop();
//     return _audioPlayer.seek(const Duration(milliseconds: 0));
//   }
// }
//
// class _Options extends StatelessWidget {
//   final String name;
//   final Icon icon;
//   final VoidCallback ontap;
//
//   const _Options({required this.name, required this.icon, required this.ontap});
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//         onTap: ontap,
//         child: Padding(
//           padding: EdgeInsets.only(top: mq.height * .015, left: mq.width * .05, bottom: mq.height * .02),
//           child: Row(
//             children: [
//               icon,
//               Text(
//                 "    ${name}",
//                 style: TextStyle(fontSize: 15, color: Colors.black54, letterSpacing: 0.5),
//               ),
//             ],
//           ),
//         ));
//   }
// }

//import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

//import 'package:just_audio/just_audio.dart';
import 'package:wayoutchatapp/api/apis.dart';
import 'package:wayoutchatapp/modals/messages_modal.dart';
//import 'package:just_audio/just_audio.dart';

import '../diologs/diologs_screen.dart';
import '../main.dart';
import '../modals/chat_user_modal.dart';
import '../screens/date_formated.dart';

class GroupMessageCard extends StatefulWidget {
  GroupMessageCard({
    Key? key,
    required this.message,
    required this.image,
    required this.user,
  }) : super(key: key);
  final MessagesModal message;
  String? image;

  // bool? isOnline;
  ChatUserModal user;

  @override
  State<GroupMessageCard> createState() => _GroupMessageCardState();
}

class _GroupMessageCardState extends State<GroupMessageCard> {
  //AudioPlayer audioPlayer = AudioPlayer();

  // todo for play

  late Directory directory;
  String? path;
  bool isSlider = false;
  List<MessagesModal> intuuList = [];

  // todo for play
  final _audioPlayer = AudioPlayer();
  bool playStop = false;
  late Future<Duration?> futureDuration;

  late StreamSubscription<PlayerState> _playerStateChangedSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    playStop = !playStop;
    _playerStateChangedSubscription = _audioPlayer.playerStateStream.listen(playerStateListener);
    futureDuration = _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(widget.message.msg.toString())));

    // _initialiseControllers();
  }

  void playerStateListener(PlayerState state) async {
    if (state.processingState == ProcessingState.completed) {
      await reset();
    }
  }

  @override
  void dispose() {
    _playerStateChangedSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMe = Apis.user.uid == widget.message.fromId;
    return InkWell(
        onLongPress: () {
          showBottomSheet(isMe);
          // print("widget.isOnline");
          //print(widget.isOnline);
        },
        child: isMe ? _greenMessage() : _blueMessage());
    // return Apis.user.uid == widget.message.fromId ? _greenMessage() : _blueMessage();
  }

  Widget _blueMessage() {
    if (widget.message.read == null) {
      // widget.isOnline == true ? Apis.updateMessageReadStatus(widget.message) : SizedBox();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: _buildPadding(widget.message.type),
            //  padding: EdgeInsets.all(widget.message.type == Type.image ? mq.width * .03 : mq.width * .03),
            margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: mq.height * .03),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 221, 245, 255),
                border: Border.all(color: Colors.lightBlue),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15), topRight: Radius.circular(15), bottomRight: Radius.circular(15))),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _buildBlueMessage(widget.message.type),
                Positioned(
                    right: widget.message.type == Type.audio ? 70 : 5,
                    //bottom: -10,
                    bottom: widget.message.type == Type.image ? 1 : -12,
                    child: Container(
                      child: Row(
                        children: [
                          Text(
                            //  widget.message.sent.toString(),
                            MyDateUtils.getFormatTime(context, widget.message.sent),

                            style: TextStyle(fontSize: 11, color: Colors.black54),
                          ),
                        ],
                      ),
                    )),
                widget.message.type == Type.audio
                    ? Positioned(
                        top: 39,
                        right: 40,
                        child: Container(
                          child: Icon(
                            Icons.mic,
                            color: Colors.blue,
                          ),
                        ))
                    : SizedBox()
              ],
            ),
          ),
        ),
        SizedBox(
          width: mq.width * .14,
        ),
      ],
    );
  }

  Widget _buildBlueMessage(Type? type) {
    print("widget.message.fromId");
    print(widget.message.fromId);
    // bool isMeUser = Apis.user.uid == widget.message.fromId;
    // print("ismjkjk");
    // print(isMeUser);
    bool isMe = widget.user.id == widget.message.fromId;
    // print(isMeGroup);
    // bool isMe = Apis.isgroup == true ? isMeGroup : isMeUser;
    // print(isMe);

    print("type");
    print(type);
    switch (type) {
      case Type.image:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
                stream: Apis.getUserGroupInfo(widget.message.fromId.toString()),
                builder: (context, snapshot) {
                  print("testing k");
                  final data = snapshot.data?.docs;

                  //final list = data?.map((e) => ChatUserModal.fromJson(e.data())).toList() ?? [];
                  final list = data?.map((e) => ChatUserModal.fromJson(e.data())).toList() ?? [];
                  //Apis.isgroup = list[0].isGroup;
                  print("group info in message card");
                  print(Apis.isgroup);
                  return Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: [
                        Text("~"),
                        Text(
                          list.isNotEmpty ? list[0].name.toString() : "~",
                          style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                }),
            ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .02),
              child: CachedNetworkImage(
                imageUrl: widget.message.msg!,
                // height: mq.height * .3,
                // width: mq.width * .7,
                placeholder: (context, url) => CircularProgressIndicator(),
                fit: BoxFit.fill,
                errorWidget: (context, url, error) => Icon(
                  Icons.error,
                  size: 70,
                ),
              ),
            ),
          ],
        );
      case Type.audio:
        return FutureBuilder<Duration?>(
          future: futureDuration,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder(
                      stream: Apis.getUserGroupInfo(widget.message.fromId.toString()),
                      builder: (context, snapshot) {
                        print("testing k");
                        final data = snapshot.data?.docs;

                        //final list = data?.map((e) => ChatUserModal.fromJson(e.data())).toList() ?? [];
                        final list = data?.map((e) => ChatUserModal.fromJson(e.data())).toList() ?? [];
                        //Apis.isgroup = list[0].isGroup;
                        print("group info in message card");
                        print(Apis.isgroup);
                        return Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Row(
                            children: [
                              Text("~"),
                              Text(
                                list.isNotEmpty ? list[0].name.toString() : "~",
                                style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        );
                      }),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: mq.width * .02,
                      ),
                      isMe
                          ? StreamBuilder(
                              stream: Apis.getUserGroupInfo(widget.message.fromId.toString()),
                              builder: (context, snapshot) {
                                print("testing k");
                                final data = snapshot.data?.docs;

                                //final list = data?.map((e) => ChatUserModal.fromJson(e.data())).toList() ?? [];
                                final list = data?.map((e) => ChatUserModal.fromJson(e.data())).toList() ?? [];
                                //Apis.isgroup = list[0].isGroup;
                                print("group info in message card");
                                print(Apis.isgroup);
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(mq.height * .3),
                                  child: CachedNetworkImage(
                                    width: mq.width * .13,
                                    //  height: mq.height * .05,
                                    fit: BoxFit.fill,
                                    imageUrl: list.isNotEmpty ? list[0].image.toString() : "",
                                    placeholder: (context, url) => CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Container(
                                        width: mq.width * .13,
                                        height: mq.width * .13,
                                        color: Colors.grey,
                                        child: Icon(Icons.map)),
                                  ),
                                );
                              })
                          : SizedBox(),
                      _controlButtons(),
                      _slider(snapshot.data),
                      isMe
                          ? SizedBox()
                          : StreamBuilder(
                              stream: Apis.getUserGroupInfo(widget.message.fromId.toString()),
                              builder: (context, snapshot) {
                                print("testing k");
                                final data = snapshot.data?.docs;

                                //final list = data?.map((e) => ChatUserModal.fromJson(e.data())).toList() ?? [];
                                final list = data?.map((e) => ChatUserModal.fromJson(e.data())).toList() ?? [];
                                //Apis.isgroup = list[0].isGroup;
                                print("group info in message card");
                                print(Apis.isgroup);
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(mq.height * .3),
                                  child: CachedNetworkImage(
                                    width: mq.width * .13,
                                    //  height: mq.height * .05,
                                    fit: BoxFit.fill,
                                    imageUrl: list.isNotEmpty ? list[0].image.toString() : "",
                                    placeholder: (context, url) => CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Container(
                                        width: mq.width * .13,
                                        height: mq.width * .13,
                                        color: Colors.grey,
                                        child: Icon(Icons.map)),
                                  ),
                                );
                              })
                    ],
                  ),
                ],
              );
            }
            return Container(
                // color: Colors.red,
                width: 50,
                margin: EdgeInsets.symmetric(horizontal: 95),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ));
          },
        );

      // InkWell(
      //   onTap: () async {
      //     print("playsound");
      //     print(playStop);
      //     playStop = !playStop;
      //     playStop ? await audioPlayer.play(UrlSource(widget.message.msg.toString())) : await audioPlayer.pause();
      //     print("soundd");
      //     print(playStop);
      //     setState(() {});
      //     // await playVoiceMessage(widget.message.msg.toString());
      //   },
      //   child: Text("click me"));

      case Type.text:
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                  stream: Apis.getUserGroupInfo(widget.message.fromId.toString()),
                  builder: (context, snapshot) {
                    print("testing k");
                    final data = snapshot.data?.docs;

                    //final list = data?.map((e) => ChatUserModal.fromJson(e.data())).toList() ?? [];
                    final list = data?.map((e) => ChatUserModal.fromJson(e.data())).toList() ?? [];
                    //Apis.isgroup = list[0].isGroup;
                    print("group info in message card");
                    print(Apis.isgroup);
                    return Container(
                      width: 120,
                      //     color: Colors.yellow,
                      child: Row(
                        children: [
                          Text("~"),
                          Container(
                            width: 100,
                            child: Text(
                              list.isNotEmpty ? list[0].name.toString() : "~",
                              style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              SizedBox(
                height: 3,
              ),
              Text(
                "${widget.message.msg.toString()}" + "               ",
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ],
          ),
        );

      default:
        return SizedBox();
        break;
    }
  }

  Widget groupUserInfo() {
    print("this is group info");
    //print(message.fromId);
    return StreamBuilder(
        stream: Apis.getUserInfo(widget.user),
        builder: (context, snapshot) {
          print("testing k");
          final data = snapshot.data?.docs;

          //final list = data?.map((e) => ChatUserModal.fromJson(e.data())).toList() ?? [];
          final list = data?.map((e) => ChatUserModal.fromJson(e.data())).toList() ?? [];
          //Apis.isgroup = list[0].isGroup;
          print("group info in message card");
          print(Apis.isgroup);
          return InkWell(
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_) => ViewProfileScreen(user: widget.user)));
            },
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);

                      print("listtttt");
                      print(list[0].isOnline!);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black54,
                    )),
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .3),
                  child: CachedNetworkImage(
                    width: mq.width * .13,
                    //  height: mq.height * .05,
                    fit: BoxFit.fill,
                    imageUrl: list.isNotEmpty ? list[0].image.toString() : widget.user.image!,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Container(
                        width: mq.width * .13, height: mq.width * .13, color: Colors.grey, child: Icon(Icons.error)),
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
                    // Apis.isgroup == true
                    //     ? SizedBox()
                    //     : Text(
                    //   list.isNotEmpty
                    //       ? list[0].isOnline
                    //       ? "Online"
                    //       : MyDateUtils.getLastActiveTimeDate(
                    //       context: context, lastActive: list[0].lastActive)
                    //       : MyDateUtils.getLastActiveTimeDate(
                    //       context: context, lastActive: widget.user.lastActive),
                    //   style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                    // ),
                    // Text(
                    //   checkUserOnlineOrOffline(),
                    //   style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                    // )
                  ],
                ),
              ],
            ),
          );
        });
    // return StreamBuilder(
    //     stream: Apis.getUserGroupInfo(message),
    //     builder: (context, snapshot) {
    //       print("intuu snapshot: ${snapshot}");
    //       switch (snapshot.connectionState) {
    //         case ConnectionState.waiting:
    //         case ConnectionState.none:
    //           return Center(
    //             child: CircularProgressIndicator(),
    //           );
    //         case ConnectionState.active:
    //         case ConnectionState.done:
    //           final data = snapshot.data?.docs;
    //           print(data);
    //           // final list = data?.map((e) => ChatUserModal.fromJson(e.data())).toList() ?? [];
    //           print("user data length");
    //           return Column();
    //         //print(list.length);
    //         // if (list.isNotEmpty) {
    //         //   return ListView.builder(
    //         //       itemCount: list.length,
    //         //       padding: EdgeInsets.only(top: mq.height * .01),
    //         //       physics: BouncingScrollPhysics(),
    //         //       itemBuilder: (context, index) {
    //         //         print("user data");
    //         //         print(list[index].name.toString());
    //         //         return Column(
    //         //           children: [Text(list[index].name.toString())],
    //         //         );
    //         //       });
    //         // } else {
    //         //   return Center(child: Text("No connection is found"));
    //         // }
    //       }
    //     });
  }

  // todo
  _buildPadding(Type? type) {
    print("type");
    print(type);
    switch (type) {
      case Type.image:
        return EdgeInsets.all(mq.width * .01);
      case Type.audio:
        return EdgeInsets.only(bottom: mq.width * .034, right: mq.width * .01, top: mq.width * .02);

      case Type.text:
        return EdgeInsets.only(
            left: mq.width * .03, right: mq.width * .01, top: mq.height * .01, bottom: mq.height * .02);

      default:
        return SizedBox();
        break;
    }
  }

  Widget _greenMessage() {
    return Row(
      //crossAxisAlignment: CrossAxisAlignment,
      //mainAxisAlignment: MainAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: mq.width * .15,
        ),
        // Row(
        //   children: [
        //     SizedBox(
        //       width: mq.width * .01,
        //     ),
        //     if (widget.message.read != null)
        //       IconButton(
        //           onPressed: () {},
        //           icon: Icon(
        //             Icons.done_all_rounded,
        //             color: Colors.blue,
        //             size: mq.width * .06,
        //           )),
        //     SizedBox(
        //       width: mq.width * .001,
        //     ),
        //     Text(
        //       //  widget.message.sent.toString(),
        //       MyDateUtils.getFormatTime(context, widget.message.sent),
        //       style: TextStyle(fontSize: 11, color: Colors.black54),
        //     ),
        //   ],
        // ),
        Flexible(
          child: Container(
            // width: widget.message.type == Type.text ? mq.width * .3 : null,
            padding: _buildPadding(widget.message.type),
            // padding: EdgeInsets.all(widget.message.type == Type.image ? mq.width * .043 : mq.width * .03),
            margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: mq.height * .02),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 218, 255, 176),
                border: Border.all(color: Colors.lightGreen),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15), topRight: Radius.circular(15), bottomLeft: Radius.circular(15))),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _buildBlueMessage(widget.message.type),
                Positioned(
                    right: 2,
                    bottom: widget.message.type == Type.image ? 1 : -12,
                    child: Container(
                      child: Row(
                        children: [
                          Text(
                            //  widget.message.sent.toString(),
                            MyDateUtils.getFormatTime(context, widget.message.sent),
                            style: TextStyle(
                                fontSize: widget.message.type == Type.image ? 14 : 12,
                                color: widget.message.type == Type.image ? Colors.white : Colors.black54),
                          ),
                          //  messageReadDonFunction(),
                          if (widget.message.read != null)
                            Icon(
                              Icons.done_all_rounded,
                              color: Colors.blue,
                              size: mq.width * .04,
                            ),
                          // widget.isOnline == true && widget.message.read == null
                          //     ? Icon(
                          //         Icons.done_all_rounded,
                          //         color: Colors.black54,
                          //         size: mq.width * .04,
                          //       )
                          //     : SizedBox(),
                          if (widget.message.read == null)
                            Icon(
                              Icons.done,
                              color: Colors.black54,
                              size: mq.width * .04,
                            )
                        ],
                      ),
                    )),
                widget.message.type == Type.audio
                    ? Positioned(
                        top: 39,
                        left: 35,
                        child: Container(
                          child: Icon(
                            Icons.mic,
                            color: Colors.blue,
                          ),
                        ))
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ],
    );
    ;
  }

  messageReadDonFunction() {
    if (widget.message.read != null) {
      return Icon(
        Icons.done_all_rounded,
        color: Colors.blue,
        size: mq.width * .04,
      );
    } else if (Apis.connectivityResult != ConnectivityResult.none) {
      return Icon(
        Icons.done_all_rounded,
        color: Colors.black54,
        size: mq.width * .04,
      );
    } else {
      Icon(
        Icons.done,
        color: Colors.black54,
        size: mq.width * .04,
      );
    }
  }

  void showMessageUpdateDialog() {
    String updateMessage = widget.message.msg.toString();
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Icon(
                    Icons.message,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text("Update Message"),
                ],
              ),
              content: TextFormField(
                initialValue: updateMessage,
                maxLines: null,
                onChanged: (value) => updateMessage = value,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "cancel",
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    Apis.updateMessage(widget.message, updateMessage);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Update",
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                )
              ],
            ));
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

//todo playmessage

  Widget _controlButtons() {
    return Container(
      // color: Colors.red,
      child: StreamBuilder<bool>(
        stream: _audioPlayer.playingStream,
        builder: (context, _) {
          final color = _audioPlayer.playerState.playing ? Colors.red : Colors.grey;
          final icon = _audioPlayer.playerState.playing ? Icons.pause : Icons.play_arrow;
          return Padding(
            padding: const EdgeInsets.only(bottom: 0.0, right: 0),
            child: GestureDetector(
              onTap: () {
                Apis.updateAudioMessageReadStatus(widget.message);
                if (_audioPlayer.playerState.playing) {
                  pause();
                } else {
                  play();
                }
              },
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  //  color: Colors.pink,
                  width: 40,
                  height: 40,
                  child: Center(child: Icon(icon, color: color, size: 40)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

//
  Widget _slider(Duration? duration) {
    bool isMe = Apis.user.uid == widget.message.fromId;
    return StreamBuilder<Duration>(
      stream: _audioPlayer.positionStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && duration != null) {
          return Container(
            margin: EdgeInsets.only(top: 3),
            height: 10,
            // color: Colors.yellow,
            width: isMe ? mq.width * .45 : mq.width * .45,
            child: SliderTheme(
              data: SliderThemeData(
                overlayShape: SliderComponentShape.noOverlay,
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: 8,
                ),
              ),
              child: Slider(
                inactiveColor: Colors.grey,
                thumbColor: widget.message.readAudio == true ? Colors.blue : Colors.green,
                value: snapshot.data!.inMicroseconds / duration.inMicroseconds,
                onChanged: (val) {
                  _audioPlayer.seek(duration * val);
                },
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Future<void> play() {
    return _audioPlayer.play();
  }

  Future<void> pause() {
    return _audioPlayer.pause();
  }

  Future<void> reset() async {
    await _audioPlayer.stop();
    return _audioPlayer.seek(const Duration(milliseconds: 0));
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
