// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:wayoutchatapp/api/apis.dart';
// import 'package:wayoutchatapp/modals/messages_modal.dart';
//
// import '../main.dart';
// import '../modals/user_modal.dart';
// import '../screens/chat_screen.dart';
// import '../screens/date_formated.dart';
// import '../widgets/dialods/profile_dialog.dart';
//
// class CartGroupScreen extends StatefulWidget {
//   CartGroupScreen({Key? key, required this.user}) : super(key: key);
//   ChatUserModal user;
//
//   @override
//   State<CartGroupScreen> createState() => _CartGroupScreenState();
// }
//
// class _CartGroupScreenState extends State<CartGroupScreen> {
//   MessagesModal? messagesModal;
//
// // static List gropuList = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         InkWell(
//           onTap: () {
//             // Navigator.push(
//             //     context,
//             //     MaterialPageRoute(
//             //         builder: (_) => ChatScreen(
//             //               user: widget.user,
//             //             )));
//             //  Apis.updateMessageReadStatus(widget.message);
//
//             ChatUserModal? entry = widget.user;
//             ChatUserModal entryuser = widget.user;
//             print("gropuList");
//             print(Apis.gropuList);
//             print(entry);
//             if (Apis.gropuList.contains(entry)) {
//               Apis.gropuList.remove(entry);
//               print("removee");
//               setState(() {});
//             } else {
//               Apis.gropuList.add(entry);
//               print('addedd');
//               setState(() {});
//             }
//
//             setState(() {});
//           },
//           child: StreamBuilder(
//               stream: Apis.getLastMessages(widget.user),
//               builder: (context, snapShot) {
//                 final data = snapShot.data?.docs;
//                 final list = data?.map((e) => MessagesModal.fromJson(e.data())).toList() ?? [];
//
//                 if (list.isNotEmpty) {
//                   messagesModal = list[0];
//                 }
//                 return Padding(
//                   padding: const EdgeInsets.only(top: 8.0, bottom: 8),
//                   child: ListTile(
//                     leading: InkWell(
//                       onTap: () {
//                         showDialog(
//                             context: context,
//                             builder: (_) => ProfileDialog(
//                                   user: widget.user,
//                                 ));
//                       },
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(mq.height * .3),
//                         child: CachedNetworkImage(
//                           width: mq.width * .15,
//                           // height: mq.height * .055,
//                           fit: BoxFit.fill,
//                           imageUrl: widget.user.image!,
//                           placeholder: (context, url) => CircularProgressIndicator(),
//                           errorWidget: (context, url, error) => Icon(Icons.error),
//                         ),
//                       ),
//                     ),
//                     title: Text(widget.user.name.toString()),
//                     subtitle: Text(widget.user.about.toString()),
//                     // Text(messagesModal != null
//                     //     ? checkMessageType(messagesModal!.msg.toString())
//                     // // messagesModal!.type == Type.image || messagesModal!.type == Type.audio
//                     // //         ? "Image"
//                     // //         : messagesModal!.msg.toString()
//                     //     : widget.user.about.toString()),
//
//                     // trailing: Text(
//                     //   "12:00 pm",
//                     //   style: TextStyle(color: Colors.black54),
//                     // ),
//                   ),
//                 );
//               }),
//         ),
//       ],
//     );
//   }
//
//   Widget checkMessageType(Type? type) {
//     switch (type) {
//       case Type.image:
//         return Text("image");
//       case Type.audio:
//         return Text("audio");
//
//       case Type.text:
//         return Container(
//             width: 20,
//             //color: Colors.yellow,
//             child: Text(
//               messagesModal!.msg.toString(),
//               overflow: TextOverflow.ellipsis,
//             ));
//       default:
//         return SizedBox();
//     }
//   }
// }
