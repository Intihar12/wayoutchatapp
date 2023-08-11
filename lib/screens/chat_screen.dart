// import 'dart:io';
// import 'package:flutter/material.dart';
//
// import 'dart:async';
//
// import 'dart:ui' as ui;
//
// import 'package:audio_waveforms/audio_waveforms.dart';
// import 'package:flutter/material.dart';
//
// import 'package:audioplayers/audioplayers.dart';
// import 'package:record/record.dart';
// import 'package:flutter/foundation.dart';
//
// import '../api/apis.dart';
// import '../modals/user_modal.dart';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
//
// import 'package:image_picker/image_picker.dart';
//
// import 'package:wayoutchatapp/screens/view_profile_screen.dart';
//
// import '../main.dart';
//
// import '../modals/messages_modal.dart';
//
// import '../voice_chat/voice_chat.dart';
// import '../widgets/message_card.dart';
// import 'date_formated.dart';
//
// class ChatScreen extends StatefulWidget {
//   ChatScreen({Key? key, required this.user}) : super(key: key);
//   final ChatUserModal user;
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
// //   // todo voice
// //   int _recordDuration = 0;
// //   bool isMicActive = false;
// //   Timer? _timer;
// //   final _audioRecorder = Record();
// //   StreamSubscription<RecordState>? _recordSub;
// //   RecordState _recordState = RecordState.stop;
// //   StreamSubscription<Amplitude>? _amplitudeSub;
// //   Amplitude? _amplitude;
// //
// //   Future<void> _start() async {
// //     try {
// //       if (await _audioRecorder.hasPermission()) {
// //         // We don't do anything with this but printing
// //         final isSupported = await _audioRecorder.isEncoderSupported(
// //           AudioEncoder.aacLc,
// //         );
// //         if (kDebugMode) {
// //           print("aaclc");
// //           print('${AudioEncoder.aacLc.name} supported: $isSupported');
// //         }
// //
// //         // final devs = await _audioRecorder.listInputDevices();
// //         // final isRecording = await _audioRecorder.isRecording();
// //
// //         await _audioRecorder.start();
// //         _recordDuration = 0;
// //
// //         _startTimer();
// //         setState(() {});
// //       }
// //     } catch (e) {
// //       if (kDebugMode) {
// //         print(e);
// //       }
// //     }
// //   }
// //
// //   Future<void> _stop() async {
// //     _timer?.cancel();
// //     _recordDuration = 0;
// //
// //     final path = await _audioRecorder.stop();
// //     print("this is path");
// //     print(path);
// //     if (path != null) {
// //       Apis.uploadAudioFile(widget.user, File(path));
// //       //widget.onStop(path);
// //     }
// //     setState(() {});
// //   }
// //
// //   Future<void> _pause() async {
// //     _timer?.cancel();
// //     await _audioRecorder.pause();
// //     setState(() {});
// //   }
// //
// //   Future<void> _resume() async {
// //     _startTimer();
// //     await _audioRecorder.resume();
// //     setState(() {});
// //   }
// //
// //   Future<void> _delete() async {
// //     _timer?.cancel();
// //     await _audioRecorder.dispose();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _timer?.cancel();
// //     _recordSub?.cancel();
// //     _amplitudeSub?.cancel();
// //     _audioRecorder.dispose();
// //     super.dispose();
// //   }
// //
// //   Widget _buildRecordStopControl() {
// //     late Icon icon;
// //     late Color color;
// //
// //     if (_recordState != RecordState.stop) {
// //       icon = const Icon(Icons.send, color: Colors.green, size: 20);
// //       color = Colors.red.withOpacity(0.1);
// //     } else {
// //       print("this is mic bool");
// //
// //       final theme = Theme.of(context);
// //       icon = Icon(Icons.mic, color: theme.primaryColor, size: 26);
// //       color = theme.primaryColor.withOpacity(0.1);
// //     }
// //
// //     return ClipOval(
// //       child: Material(
// //         color: color,
// //         child: InkWell(
// //           child: SizedBox(width: 40, height: 40, child: icon),
// //           onTap: () {
// //             print(" beforev isMicActive");
// //             print(isMicActive);
// //             isMicActive = !isMicActive;
// //             print("intuuu allll");
// //             (_recordState != RecordState.stop) ? _stop() : _start();
// //             setState(() {});
// //             print(" after isMicActive");
// //             print(isMicActive);
// //           },
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildPauseResumeControl() {
// //     if (_recordState == RecordState.stop) {
// //       return const SizedBox.shrink();
// //     }
// //
// //     late Icon icon;
// //     late Color color;
// //
// //     if (_recordState == RecordState.record) {
// //       icon = const Icon(Icons.pause, color: Colors.green, size: 30);
// //       color = Colors.red.withOpacity(0.1);
// //     } else {
// //       final theme = Theme.of(context);
// //       icon = const Icon(Icons.mic, color: Colors.red, size: 30);
// //       color = theme.primaryColor.withOpacity(0.1);
// //     }
// //
// //     return Padding(
// //       padding: const EdgeInsets.only(left: 20.0, right: 20),
// //       child: Container(
// //         color: Colors.black,
// //         width: 20,
// //         child: ClipOval(
// //           child: Material(
// //             color: color,
// //             child: InkWell(
// //               child: SizedBox(width: 56, height: 56, child: icon),
// //               onTap: () {
// //                 (_recordState == RecordState.pause) ? _resume() : _pause();
// //                 setState(() {});
// //               },
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildRecordDeleteControl() {
// //     if (_recordState == RecordState.stop) {
// //       return const SizedBox.shrink();
// //     }
// //
// //     late Icon icon;
// //     late Color color;
// //
// //     if (_recordState == RecordState.record) {
// //       icon = const Icon(Icons.delete, color: Colors.green, size: 30);
// //       color = Colors.red.withOpacity(0.1);
// //     } else {
// //       final theme = Theme.of(context);
// //       icon = const Icon(Icons.delete, color: Colors.red, size: 30);
// //       color = theme.primaryColor.withOpacity(0.1);
// //     }
// //
// //     return ClipOval(
// //       child: Material(
// //         color: color,
// //         child: InkWell(
// //           child: SizedBox(width: 56, height: 56, child: icon),
// //           onTap: () {
// //             // (_recordState == RecordState.pause) ? _delete() : _delete();
// //           },
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildRecordAmplitudeControl() {
// //     if (_recordState == RecordState.stop) {
// //       return const SizedBox.shrink();
// //     }
// //
// //     late Icon icon;
// //     late Color color;
// //
// //     if (_recordState == RecordState.record) {
// //       if (_amplitude != null)
// //         [
// //           const SizedBox(height: 40),
// //           Text('Current: ${_amplitude?.current ?? 0.0}'),
// //           Text('Max: ${_amplitude?.max ?? 0.0}'),
// //         ];
// //     } else {
// //       if (_amplitude != null)
// //         [
// //           const SizedBox(height: 40),
// //           Text('Current: ${_amplitude?.current ?? 0.0}'),
// //           Text('Max: ${_amplitude?.max ?? 0.0}'),
// //         ];
// //     }
// //
// //     return ClipOval(
// //       child: Material(
// //         child: InkWell(
// //           onTap: () {
// //             // (_recordState == RecordState.pause) ? _delete() : _delete();
// //           },
// //         ),
// //       ),
// //     );
// //   }
// //
// // // todo delete
// //
// //   Widget _buildText() {
// //     if (_recordState != RecordState.stop) {
// //       return _buildTimer();
// //     }
// //
// //     return const Text("Waiting to record");
// //   }
// //
// //   Widget _buildTimer() {
// //     final String minutes = _formatNumber(_recordDuration ~/ 60);
// //     final String seconds = _formatNumber(_recordDuration % 60);
// //
// //     return Text(
// //       '$minutes : $seconds',
// //       style: const TextStyle(color: Colors.red),
// //     );
// //   }
// //
// //   String _formatNumber(int number) {
// //     String numberStr = number.toString();
// //     if (number < 10) {
// //       numberStr = '0' + numberStr;
// //     }
// //
// //     return numberStr;
// //   }
// //
// //   void _startTimer() {
// //     _timer?.cancel();
// //
// //     _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
// //       setState(() => _recordDuration++);
// //     });
// //   }
//
//   // todo voice
//
//   List<MessagesModal> _list = [];
//   List list = [];
//   final record = Record();
//   bool showPlayer = false;
//   bool isVoiceRecord = false;
//   String? audioPath;
//   bool isMicTrue = false;
//   AudioPlayer audioPlayer = AudioPlayer();
//   bool isMic = false;
//   final textController = TextEditingController();
//   bool _isEmoji = false, isUploadingImage = false;
//   DateTime start = DateTime.now();
//
//   Future<void> recordMessage() async {
//     if (await record.hasPermission()) {
//       // Start recording
//       print("kkkk");
//       await record.start(
//         path: 'aFullPath/myFile.m4a',
//         encoder: AudioEncoder.aacLc, // by default
//         bitRate: 128000, // by default
//         samplingRate: 44100, // by default
//       );
//       print("llllll");
//       print(AudioEncoder.aacLc);
//     }
//
// // Get the state of the recorder
//     bool isRecording = await record.isRecording();
//     print("isRecord");
//     print(isRecording);
// // Stop recording
//     // await record.stop();
//   }
//
//   late final RecorderController recorderController;
//
//   bool isMicPuse = false;
//
//   void _initialiseController() {
//     recorderController = RecorderController()
//       ..androidEncoder = AndroidEncoder.aac
//       ..androidOutputFormat = AndroidOutputFormat.mpeg4
//       ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
//       ..sampleRate = 16000;
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _initialiseController();
//     // _recordSub = _audioRecorder.onStateChanged().listen((recordState) {
//     //   _recordState = recordState;
//     // });
//     //
//     // _amplitudeSub =
//     //     _audioRecorder.onAmplitudeChanged(const Duration(milliseconds: 300)).listen((amp) => _amplitude = amp);
//   }
//
//   void _startRecording() async {
//     await recorderController.record(
//       androidEncoder: AndroidEncoder.aac,
//       androidOutputFormat: AndroidOutputFormat.mpeg4,
//       sampleRate: 16000,
//     );
//     setState(() {});
//   }
//
//   void appDocDirectory() async {
//     //Directory appDocDirectory = await getApplicationDocumentsDirectory();
//   }
//
//   void _pause() async {
//     await recorderController.pause();
//     setState(() {});
//   }
//
//   Future<void> _stopRecording() async {
//     final path = await recorderController.stop();
//     print("path");
//
//     print(path);
//     print("path");
//     //  print(path.toString());
//     Apis.uploadAudioFile(widget.user, File(path.toString()));
//     setState(() {});
//
//     // update state here to, for eample, change the button's state
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: WillPopScope(
//         onWillPop: () {
//           if (_isEmoji) {
//             setState(() {
//               _isEmoji = !_isEmoji;
//             });
//             return Future.value(false);
//           } else {
//             return Future.value(true);
//           }
//         },
//         child: SafeArea(
//             child: Scaffold(
//           appBar: AppBar(
//             automaticallyImplyLeading: false,
//             flexibleSpace: _appBar(),
//           ),
//           body: Column(
//             children: [
//               Expanded(
//                 child: StreamBuilder(
//                     stream: Apis.getAllMessages(widget.user),
//                     builder: (contexts, snapshot) {
//                       // print("intuu snapshot: ${snapshot}");
//                       switch (snapshot.connectionState) {
//                         case ConnectionState.waiting:
//                         case ConnectionState.none:
//                         // return Center(
//                         //   child: CircularProgressIndicator(),
//                         // );
//                         case ConnectionState.active:
//                         case ConnectionState.done:
//                           final data = snapshot.data?.docs;
//
//                           _list = data?.map((e) => MessagesModal.fromJson(e.data())).toList() ?? [];
//
//                           // final _list = [];
//                           if (_list.isNotEmpty) {
//                             return ListView.builder(
//                                 reverse: true,
//                                 itemCount: _list.length,
//                                 padding: EdgeInsets.only(top: mq.height * .01),
//                                 physics: BouncingScrollPhysics(),
//                                 itemBuilder: (context, index) {
//                                   return MessageCard(
//                                     message: _list[index],
//                                     image: list.isNotEmpty ? list[0].image.toString() : widget.user.image!,
//                                     user: Apis.me,
//                                   );
//                                   // Text("message ${_list[index]}");
//                                 });
//                           } else {
//                             return Center(child: Text("Say hi 👏"));
//                           }
//                       }
//                     }),
//               ),
//               if (isUploadingImage)
//                 Align(
//                     alignment: Alignment.bottomRight,
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                       child: CircularProgressIndicator(),
//                     )),
//               _chatInput(),
//               if (_isEmoji)
//                 SizedBox(
//                   height: mq.height * .35,
//                   child: EmojiPicker(
//                     textEditingController: textController,
//                     // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
//                     // config: Config(
//                     //   columns: 7,
//                     //   emojiSizeMax: 32 *
//                     //       (Platform.isAndroid ? 1.0 : 1.35), // Issue: https://github.com/flutter/flutter/issues/28894
//                     // ),
//                   ),
//                 ),
//             ],
//           ),
//         )),
//       ),
//     );
//   }
//
//   Widget _appBar() {
//     return StreamBuilder(
//         stream: Apis.getUserInfo(widget.user),
//         builder: (context, snapshot) {
//           final data = snapshot.data?.docs;
//
//           //final list = data?.map((e) => ChatUserModal.fromJson(e.data())).toList() ?? [];
//           list = data?.map((e) => ChatUserModal.fromJson(e.data())).toList() ?? [];
//
//           return InkWell(
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (_) => ViewProfileScreen(user: widget.user)));
//             },
//             child: Row(
//               children: [
//                 IconButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     icon: Icon(
//                       Icons.arrow_back,
//                       color: Colors.black54,
//                     )),
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(mq.height * .3),
//                   child: CachedNetworkImage(
//                     width: mq.width * .13,
//                     //  height: mq.height * .05,
//                     fit: BoxFit.fill,
//                     imageUrl: list.isNotEmpty ? list[0].image.toString() : widget.user.image!,
//                     placeholder: (context, url) => CircularProgressIndicator(),
//                     errorWidget: (context, url, error) => Icon(Icons.error),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       list.isNotEmpty ? list[0].name.toString() : widget.user.name.toString(),
//                       style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
//                     ),
//                     SizedBox(
//                       height: 2,
//                     ),
//                     Text(
//                       list.isNotEmpty
//                           ? list[0].isOnline!
//                               ? "Online"
//                               : MyDateUtils.getLastActiveTimeDate(context: context, lastActive: list[0].lastActive)
//                           : MyDateUtils.getLastActiveTimeDate(context: context, lastActive: widget.user.lastActive),
//                       style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           );
//         });
//   }
//
//   Widget _chatInput() {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: mq.height * 0.01, horizontal: mq.width * .025),
//       child: Row(
//         children: [
//           isMicTrue == true
//               ? SizedBox()
//               : Expanded(
//                   child: Card(
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                     child: Row(
//                       children: [
//                         IconButton(
//                             onPressed: () {
//                               // FocusScope.of(context).unfocus();
//                               setState(() => _isEmoji = !_isEmoji);
//                             },
//                             icon: Icon(
//                               Icons.emoji_emotions,
//                               color: Colors.blueAccent,
//                             )),
//                         Expanded(
//                             child: TextFormField(
//                           controller: textController,
//                           keyboardType: TextInputType.multiline,
//                           maxLines: null,
//                           onTap: () {
//                             if (_isEmoji) {
//                               setState(() => _isEmoji = !_isEmoji);
//                             }
//                           },
//                           onChanged: (value) {
//                             if (value.isNotEmpty && textController.text.isNotEmpty) {
//                               isMic = true;
//                               setState(() {});
//                             } else {
//                               isMic = false;
//                               setState(() {});
//                             }
//                           },
//                           decoration: InputDecoration(
//                               hintText: "Type someThing ...",
//                               hintStyle: TextStyle(
//                                 color: Colors.blueAccent,
//                               ),
//                               border: InputBorder.none),
//                         )),
//                         IconButton(
//                             onPressed: () async {
//                               final ImagePicker picker = ImagePicker();
// // Pick an image.
//                               final List<XFile> images = await picker.pickMultiImage(imageQuality: 07);
//                               if (images.isNotEmpty) {
//                                 for (var i in images) {
//                                   setState(() {
//                                     isUploadingImage = true;
//                                   });
//
//                                   Apis.setChateImage(widget.user, File(i.path));
//                                   setState(() {
//                                     isUploadingImage = false;
//                                   });
//                                 }
//                               }
//                             },
//                             icon: Icon(
//                               Icons.image,
//                               color: Colors.blueAccent,
//                             )),
//                         IconButton(
//                             onPressed: () async {
//                               final ImagePicker picker = ImagePicker();
// // Pick an image.
//                               final XFile? image = await picker.pickImage(source: ImageSource.camera);
//                               if (image != null) {
//                                 setState(() {
//                                   isUploadingImage = true;
//                                 });
//
//                                 Apis.setChateImage(widget.user, File(image.path));
//                                 setState(() {
//                                   isUploadingImage = false;
//                                 });
//                               }
//                             },
//                             icon: Icon(
//                               Icons.camera_alt,
//                               color: Colors.blueAccent,
//                             )),
//                         SizedBox(
//                           width: mq.width * .02,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//           isMic == true
//               ? MaterialButton(
//                   padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
//                   minWidth: 0,
//                   onPressed: () {
//                     if (textController.text.isNotEmpty) {
//                       if (_list.isEmpty) {
//                         Apis.sendFirstMessage(widget.user, textController.text, Type.text);
//                       } else {
//                         isUploadingImage = true;
//                         Apis.sendMessage(widget.user, textController.text, Type.text);
//                         isUploadingImage = false;
//                         textController.clear();
//                       }
//                     }
//                   },
//                   child: Icon(
//                     Icons.send,
//                     color: Colors.white,
//                   ),
//                   shape: CircleBorder(),
//                   color: Colors.green,
//                 )
//               : Padding(
//                   padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         // AudioWaveforms(
//                         //   //backgroundColor: Colors.yellow,
//                         //   size: Size(MediaQuery.of(context).size.width, 100.0),
//                         //   recorderController: recorderController,
//                         // ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             isMicTrue == true
//                                 ? Container(
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       color: Colors.black54,
//                                     ),
//                                     width: mq.width * .50,
//                                     child: AudioWaveforms(
//                                       size: Size(MediaQuery.of(context).size.width, 50.0),
//                                       recorderController: recorderController,
//                                       enableGesture: true,
//                                       //  backgroundColor: Colors.black54,
//                                       waveStyle: WaveStyle(
//                                         waveThickness: 4.0,
//
//                                         // showDurationLabel: true,
//                                         spacing: 8.0,
//                                         showBottom: true,
//                                         extendWaveform: true,
//                                         showMiddleLine: false,
//                                         gradient: ui.Gradient.linear(
//                                           Offset(0, 0),
//                                           Offset(MediaQuery.of(context).size.width / 3, 5),
//                                           [Colors.blue, Colors.green],
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 : SizedBox(),
//                             isMicTrue == true
//                                 ? IconButton(
//                                     icon: Icon(
//                                       Icons.delete,
//                                       color: Colors.black54,
//                                       size: 30,
//                                     ),
//                                     tooltip: 'Start recording',
//                                     onPressed: () async {
//                                       isMicTrue = !isMicTrue;
//                                       isMicPuse = false;
//                                       await recorderController.stop();
//                                       setState(() {});
//                                     },
//                                   )
//                                 : SizedBox(),
//                             isMicTrue == true
//                                 ? Container(
//                                     child: isMicPuse == false
//                                         ? IconButton(
//                                             icon: Icon(
//                                               Icons.pause,
//                                               color: Colors.red,
//                                               size: 30,
//                                             ),
//                                             tooltip: 'Start recording',
//                                             onPressed: () {
//                                               isMicPuse = !isMicPuse;
//
//                                               _pause();
//                                               setState(() {});
//                                               // isMicTrue = false;
//                                               print(isMicPuse);
//                                             },
//                                           )
//                                         : IconButton(
//                                             icon: Icon(
//                                               Icons.mic,
//                                               color: Colors.blue,
//                                               size: 30,
//                                             ),
//                                             tooltip: 'Start recording',
//                                             onPressed: () {
//                                               isMicPuse = !isMicPuse;
//                                               _startRecording();
//                                               setState(() {});
//                                             },
//                                           ),
//                                   )
//                                 : SizedBox(),
//                             isMicTrue == true
//                                 ? ClipOval(
//                                     child: Material(
//                                       color: Colors.teal,
//                                       child: InkWell(
//                                         onTap: () {
//                                           isMicTrue = !isMicTrue;
//                                           isMicPuse = false;
//                                           _stopRecording();
//                                           setState(() {});
//                                         },
//                                         child: SizedBox(
//                                           height: 40,
//                                           width: 40,
//                                           child: Icon(
//                                             Icons.send,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 : ClipOval(
//                                     child: Material(
//                                       color: Colors.teal,
//                                       child: InkWell(
//                                         onTap: () {
//                                           isMicTrue = !isMicTrue;
//
//                                           _startRecording();
//                                           setState(() {});
//                                           // isMicTrue = false;
//                                           print(isMicTrue);
//                                         },
//                                         child: SizedBox(
//                                           height: 40,
//                                           width: 40,
//                                           child: Icon(
//                                             Icons.mic,
//                                             color: Colors.white,
//                                             size: 30,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                           ],
//                         ),
//                       ]),
//                 )
//         ],
//       ),
//     );
//   }
// }
//
// // class AudioRecorder extends StatefulWidget {
// //   final void Function(String path) onStop;
// //   bool isVoiceMessage;
// //
// //   AudioRecorder({Key? key, required this.onStop, required this.isVoiceMessage}) : super(key: key);
// //
// //   @override
// //   _AudioRecorderState createState() => _AudioRecorderState();
// // }
// //
// // class _AudioRecorderState extends State<AudioRecorder> {
// //   // ChatUserModal? user;
// //   int _recordDuration = 0;
// //   Timer? _timer;
// //   final _audioRecorder = Record();
// //   StreamSubscription<RecordState>? _recordSub;
// //   RecordState _recordState = RecordState.stop;
// //   StreamSubscription<Amplitude>? _amplitudeSub;
// //   Amplitude? _amplitude;
// //
// //   @override
// //   void initState() {
// //     print("pre is isVoiceMessage");
// //     print(widget.isVoiceMessage);
// //     widget.isVoiceMessage = !widget.isVoiceMessage;
// //     print("this is isVoiceMessage");
// //     print(widget.isVoiceMessage);
// //     _recordSub = _audioRecorder.onStateChanged().listen((recordState) {
// //       setState(() => _recordState = recordState);
// //     });
// //
// //     _amplitudeSub = _audioRecorder
// //         .onAmplitudeChanged(const Duration(milliseconds: 300))
// //         .listen((amp) => setState(() => _amplitude = amp));
// //
// //     super.initState();
// //   }
// //
// //   Future<void> _start() async {
// //     try {
// //       if (await _audioRecorder.hasPermission()) {
// //         // We don't do anything with this but printing
// //         final isSupported = await _audioRecorder.isEncoderSupported(
// //           AudioEncoder.aacLc,
// //         );
// //         if (kDebugMode) {
// //           print("aaclc");
// //           print('${AudioEncoder.aacLc.name} supported: $isSupported');
// //         }
// //
// //         // final devs = await _audioRecorder.listInputDevices();
// //         // final isRecording = await _audioRecorder.isRecording();
// //
// //         await _audioRecorder.start();
// //         _recordDuration = 0;
// //
// //         _startTimer();
// //       }
// //     } catch (e) {
// //       if (kDebugMode) {
// //         print(e);
// //       }
// //     }
// //   }
// //
// //   Future<void> _stop() async {
// //     _timer?.cancel();
// //     _recordDuration = 0;
// //
// //     final path = await _audioRecorder.stop();
// //     print("this is path");
// //     print(path);
// //     if (path != null) {
// //       widget.onStop(path);
// //     }
// //   }
// //
// //   Future<void> _pause() async {
// //     _timer?.cancel();
// //     await _audioRecorder.pause();
// //   }
// //
// //   Future<void> _resume() async {
// //     _startTimer();
// //     await _audioRecorder.resume();
// //   }
// //
// //   Future<void> _delete() async {
// //     _timer?.cancel();
// //     await _audioRecorder.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: <Widget>[
// //               _buildRecordStopControl(),
// //               const SizedBox(width: 0),
// //               _buildPauseResumeControl(),
// //               const SizedBox(width: 0),
// //               _buildRecordDeleteControl()
// //
// //               //_buildText(),
// //             ],
// //           ),
// //           // if (_amplitude != null) ...[
// //           //   const SizedBox(height: 40),
// //           //   Text('Current: ${_amplitude?.current ?? 0.0}'),
// //           //   Text('Max: ${_amplitude?.max ?? 0.0}'),
// //           // ],
// //         ],
// //       ),
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _timer?.cancel();
// //     _recordSub?.cancel();
// //     _amplitudeSub?.cancel();
// //     _audioRecorder.dispose();
// //     super.dispose();
// //   }
// //
// //   Widget _buildRecordStopControl() {
// //     late Icon icon;
// //     late Color color;
// //
// //     if (_recordState != RecordState.stop) {
// //       print("this is mic bool stop");
// //       print(widget.isVoiceMessage);
// //       icon = const Icon(Icons.send, color: Colors.green, size: 20);
// //       color = Colors.red.withOpacity(0.1);
// //     } else {
// //       widget.isVoiceMessage = true;
// //       print("this is mic bool");
// //       print(widget.isVoiceMessage);
// //       final theme = Theme.of(context);
// //       icon = Icon(Icons.mic, color: theme.primaryColor, size: 26);
// //       color = theme.primaryColor.withOpacity(0.1);
// //     }
// //
// //     return ClipOval(
// //       child: Material(
// //         color: color,
// //         child: InkWell(
// //           child: SizedBox(width: 40, height: 40, child: icon),
// //           onTap: () {
// //             print("intuuu allll");
// //             (_recordState != RecordState.stop) ? _stop() : _start();
// //           },
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildPauseResumeControl() {
// //     if (_recordState == RecordState.stop) {
// //       return const SizedBox.shrink();
// //     }
// //
// //     late Icon icon;
// //     late Color color;
// //
// //     if (_recordState == RecordState.record) {
// //       icon = const Icon(Icons.pause, color: Colors.green, size: 30);
// //       color = Colors.red.withOpacity(0.1);
// //     } else {
// //       final theme = Theme.of(context);
// //       icon = const Icon(Icons.mic, color: Colors.red, size: 30);
// //       color = theme.primaryColor.withOpacity(0.1);
// //     }
// //
// //     return ClipOval(
// //       child: Material(
// //         color: color,
// //         child: InkWell(
// //           child: SizedBox(width: 56, height: 56, child: icon),
// //           onTap: () {
// //             (_recordState == RecordState.pause) ? _resume() : _pause();
// //           },
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildRecordDeleteControl() {
// //     if (_recordState == RecordState.stop) {
// //       return const SizedBox.shrink();
// //     }
// //
// //     late Icon icon;
// //     late Color color;
// //
// //     if (_recordState == RecordState.record) {
// //       icon = const Icon(Icons.delete, color: Colors.green, size: 30);
// //       color = Colors.red.withOpacity(0.1);
// //     } else {
// //       final theme = Theme.of(context);
// //       icon = const Icon(Icons.delete, color: Colors.red, size: 30);
// //       color = theme.primaryColor.withOpacity(0.1);
// //     }
// //
// //     return ClipOval(
// //       child: Material(
// //         color: color,
// //         child: InkWell(
// //           child: SizedBox(width: 56, height: 56, child: icon),
// //           onTap: () {
// //             (_recordState == RecordState.pause) ? _delete() : _delete();
// //           },
// //         ),
// //       ),
// //     );
// //   }
// //
// // // todo delete
// //
// //   Widget _buildText() {
// //     if (_recordState != RecordState.stop) {
// //       return _buildTimer();
// //     }
// //
// //     return const Text("Waiting to record");
// //   }
// //
// //   Widget _buildTimer() {
// //     final String minutes = _formatNumber(_recordDuration ~/ 60);
// //     final String seconds = _formatNumber(_recordDuration % 60);
// //
// //     return Text(
// //       '$minutes : $seconds',
// //       style: const TextStyle(color: Colors.red),
// //     );
// //   }
// //
// //   String _formatNumber(int number) {
// //     String numberStr = number.toString();
// //     if (number < 10) {
// //       numberStr = '0' + numberStr;
// //     }
// //
// //     return numberStr;
// //   }
// //
// //   void _startTimer() {
// //     _timer?.cancel();
// //
// //     _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
// //       setState(() => _recordDuration++);
// //     });
// //   }
// // }

import 'package:wayoutchatapp/barrel.dart';
import 'dart:ui' as ui;
import 'package:audioplayers/audioplayers.dart';
import 'package:wayoutchatapp/modals/chat_user_modal.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key, this.user, this.groupChat}) : super(key: key);
  final UserModal? user;
  final ChatUserModal? groupChat;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<MessagesModal> _list = [];

  List list = [];
  final record = Record();
  bool showPlayer = false;
  bool isVoiceRecord = false;
  String? audioPath;
  bool isMicTrue = false;
  AudioPlayer audioPlayer = AudioPlayer();
  bool isMic = false;
  final textController = TextEditingController();
  bool _isEmoji = false, isUploadingImage = false;
  DateTime start = DateTime.now();
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> recordMessage() async {
    if (await record.hasPermission()) {
      await record.start(
        path: 'aFullPath/myFile.m4a',
        encoder: AudioEncoder.aacLc, // by default
        bitRate: 128000, // by default
        samplingRate: 44100, // by default
      );
    }

// Get the state of the recorder
    bool isRecording = await record.isRecording();

// Stop recording
    // await record.stop();
  }

  late final RecorderController recorderController;

  bool isMicPuse = false;
  late String? dateformet;

  void _initialiseController() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialiseController();

    Apis.isgroup = widget.user?.isGroup;
    Apis.id = widget.user?.id;
    Apis.groupId = widget.user?.id;
    Apis.groupName = widget.user?.name;
    Apis.groupImage = widget.user?.image;
    widget.user?.isGroup == true ? Apis.creatGroupDynamicLink() : null;

    // _recordSub = _audioRecorder.onStateChanged().listen((recordState) {
    //   _recordState = recordState;
    // });
    //
    // _amplitudeSub =
    //     _audioRecorder.onAmplitudeChanged(const Duration(milliseconds: 300)).listen((amp) => _amplitude = amp);
  }

  void dispose() {
    Apis.connectivityResult;
    super.dispose();
  }

  void _startRecording() async {
    await recorderController.record(
      androidEncoder: AndroidEncoder.aac,
      androidOutputFormat: AndroidOutputFormat.mpeg4,
      sampleRate: 16000,
    );
    setState(() {});
  }

  void appDocDirectory() async {
    //Directory appDocDirectory = await getApplicationDocumentsDirectory();
  }

  void _pause() async {
    await recorderController.pause();
    setState(() {});
  }

  Future<void> _stopRecording() async {
    final path = await recorderController.stop();

    // Apis.isgroup != true
    //     ?
    Apis.uploadAudioFile(widget.user!, File(path.toString()));
    //: Apis.uploadAudioFileInGroup(widget.user!, File(path.toString()));
    setState(() {});

    // update state here to, for eample, change the button's state
  }

  checkGropuDate(DateTime checkDate) {
    var date = DateTime.now();
    final yesterday = DateTime(date.year, date.month, date.day - 1);
    String yesDay = formatDate(yesterday, [dd, " ", M, " ", yyyy]);
    String newDate = formatDate(date, [dd, " ", M, " ", yyyy]);
    if (formatDate(checkDate, [dd, " ", M, " ", yyyy]) == newDate) {
      return "Today";
    } else if (formatDate(checkDate, [dd, " ", M, " ", yyyy]) == yesDay) {
      return "YesterDay";
    } else {
      return formatDate(checkDate, [dd, " ", M, " ", yyyy]);
    }
  }

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
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: _appBar(),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: Apis.getAllMessages(widget.user!),
                    builder: (contexts, snapshot) {
                      var date = DateTime.now();
                      final yesterday = DateTime(date.year, date.month, date.day - 1);

                      String newDate = formatDate(date, [dd, " ", M, " ", yyyy]);
                      // print("intuu snapshot: ${snapshot}");
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

// todo timezone start
                          return _list.isNotEmpty
                              ? SizedBox(
                                  height: 300,
                                  child: GroupedListView<MessagesModal, DateTime>(
                                    //  controller: controller.reminderController,

                                    elements: _list,
                                    groupBy: (MessagesModal element) => DateTime(
                                      element.sent!.year,
                                      element.sent!.month,
                                      element.sent!.day,
                                    ),
                                    sort: false,

                                    groupComparator: (DateTime value1, DateTime value2) => value2.compareTo(value1),
                                    itemComparator: (MessagesModal item1, MessagesModal item2) =>
                                        item1.sent!.compareTo(item2.sent!),
                                    //  order: GroupedListOrder.DESC,
                                    reverse: true,
                                    useStickyGroupSeparators: false,
                                    groupSeparatorBuilder: (DateTime date) => Container(
                                      alignment: Alignment.center,
                                      width: 50,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey,
                                      ),
                                      margin: EdgeInsets.symmetric(horizontal: 105),
                                      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                                      child: Text(
                                        checkGropuDate(date),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    shrinkWrap: true,
                                    itemBuilder: (c, element) {
                                      var date = DateTime.now();
                                      String newDate = formatDate(date, [dd, yyyy, D]);

                                      return Apis.isgroup == true
                                          ? GroupMessageCard(
                                              message: element,
                                              image: list.isNotEmpty ? list[0].image.toString() : widget.user?.image!,
                                              user: Apis.me!,
                                            )
                                          : MessageCard(
                                              // isOnline: list[0].isOnline,
                                              isOnline: widget.user?.isOnline,
                                              message: element,
                                              image: list.isNotEmpty ? list[0].image.toString() : widget.user?.image!,
                                              user: Apis.me!,
                                            );
                                    },
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    // Apis.isgroup
                                    //     ? Apis.sendGroupMessage(widget.user!, "Hi", Type.text)
                                    //     :
                                    Apis.sendMessage(widget.user!, "Hi", Type.text);
                                    print("say hi");
                                  },
                                  child: Center(child: Text("Say hi 👏")));

                        // todo time zone end
                        // final _list = [];
                      }
                      return CircularProgressIndicator();
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
                    // config: Config(
                    //   columns: 7,
                    //   emojiSizeMax: 32 *
                    //       (Platform.isAndroid ? 1.0 : 1.35), // Issue: https://github.com/flutter/flutter/issues/28894
                    // ),
                  ),
                ),
            ],
          ),
        )),
      ),
    );
  }

  checkUserOnlineOrOffline() {
    if (Apis.connectivityResult == ConnectivityResult.none) {
      return MyDateUtils.getLastActiveTimeDate(context: context, lastActive: widget.user?.lastActive);
    } else {
      return "Online";
    }
  }

  Widget _appBar() {
    return StreamBuilder(
        stream: Apis.getUserInfo(widget.user!),
        builder: (context, snapshot) {
          final data = snapshot.data?.docs;

          //final list = data?.map((e) => ChatUserModal.fromJson(e.data())).toList() ?? [];
          list = data?.map((e) => UserModal.fromJson(e.data())).toList() ?? [];
          //Apis.isgroup = list[0].isGroup;
          print("ali kkk");
          print(Apis.isgroup);
          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ViewProfileScreen(user: widget.user!)));
            },
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                      // Navigator.pop(context);

                      print("listtttt");
                      // print(list[0].isOnline!);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black54,
                    )),
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .3),
                  child: CachedNetworkImage(
                    width: mq.width * .13,
                    height: mq.width * .13,
                    fit: BoxFit.fill,
                    imageUrl: list.isNotEmpty ? list[0].image.toString() : widget.user!.image!,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Container(
                        width: mq.width * .13,
                        height: mq.width * .13,
                        color: Colors.grey,
                        child: Icon(Icons.camera_alt)),
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
                      list.isNotEmpty ? list[0].name.toString() : widget.user!.name.toString(),
                      style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Apis.isgroup == true
                        ? SizedBox()
                        : Text(
                            list.isNotEmpty
                                ? list[0].isOnline
                                    ? "Online"
                                    : MyDateUtils.getLastActiveTimeDate(
                                        context: context, lastActive: list[0].lastActive)
                                : MyDateUtils.getLastActiveTimeDate(
                                    context: context, lastActive: widget.user?.lastActive),
                            style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                          ),
                    // Text(
                    //   checkUserOnlineOrOffline(),
                    //   style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                    // )
                  ],
                ),
                // Spacer(),
                // Apis.isgroup == true
                //     ? PopupMenuButton<int>(
                //         icon: Icon(
                //           Icons.more_vert,
                //           color: Colors.black,
                //         ),
                //         itemBuilder: (context) => [
                //           // PopupMenuItem 1
                //
                //           PopupMenuItem(
                //             value: 1,
                //             // row with 2 children
                //             child: Row(
                //               children: [
                //                 //Icon(Icons.settings),
                //                 SizedBox(
                //                   width: 10,
                //                 ),
                //                 Text(
                //                   "Group info",
                //                   style: TextStyle(color: Colors.white),
                //                 )
                //               ],
                //             ),
                //           ),
                //           // PopupMenuItem 2
                //           PopupMenuItem(
                //             value: 2,
                //             // row with two children
                //             child: Row(
                //               children: [
                //                 //Icon(Icons.update),
                //                 SizedBox(
                //                   width: 10,
                //                 ),
                //                 Text(
                //                   "",
                //                   style: TextStyle(color: Colors.white),
                //                 )
                //               ],
                //             ),
                //           ),
                //         ],
                //         offset: Offset(0, 40),
                //         color: Colors.teal,
                //         elevation: 2,
                //         // on selected we show the dialog box
                //         onSelected: (value) {
                //           // if value 1 show dialog
                //           if (value == 1) {
                //             //addGroupUser();
                //             Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (_) => GroupInfoScreen(
                //                           groupData: widget.user!,
                //                         )));
                //             setState(() {});
                //           } else if (value == 2) {
                //             //  controller.buttonLoading.value = true;
                //             //  Navigator.push(context, MaterialPageRoute(builder: (_) => GroupScreen()));
                //             //UpdateSupplierBottomSheet(context);
                //             // _showDialog(context);
                //           }
                //         },
                //       )
                //     : SizedBox()
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
          isMicTrue == true
              ? SizedBox()
              : Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              // FocusScope.of(context).unfocus();
                              setState(() => _isEmoji = !_isEmoji);
                              setState(() {});
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
                          onChanged: (value) {
                            if (value.isNotEmpty && textController.text.isNotEmpty) {
                              isMic = true;
                              setState(() {});
                            } else {
                              isMic = false;
                              setState(() {});
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

                                  //   Apis.setChateImage(widget.user, File(i.path));
                                  Apis.setChateImage(widget.user!, File(i.path));
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

                                Apis.setChateImage(widget.user!, File(image.path));
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
          isMic == true
              ? MaterialButton(
                  padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
                  minWidth: 0,
                  onPressed: () {
                    if (textController.text.isNotEmpty) {
                      print("ismike true 44");
                      if (_list.isEmpty) {
                        Apis.sendFirstMessage(widget.user!, textController.text, Type.text);
                        print("ismike true 34");
                      } else {
                        isUploadingImage = true;
                        Apis.sendMessage(widget.user!, textController.text, Type.text);
                        isUploadingImage = false;
                        textController.clear();
                        isMic = false;
                        print("ismike true 11");
                      }
                      textController.clear();
                      isMic = false;
                      print("ismike true");
                    }
                    setState(() {});
                  },
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  shape: CircleBorder(),
                  color: Colors.green,
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // AudioWaveforms(
                        //   //backgroundColor: Colors.yellow,
                        //   size: Size(MediaQuery.of(context).size.width, 100.0),
                        //   recorderController: recorderController,
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            isMicTrue == true
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black54,
                                    ),
                                    width: mq.width * .50,
                                    child: AudioWaveforms(
                                      size: Size(MediaQuery.of(context).size.width, 50.0),
                                      recorderController: recorderController,
                                      enableGesture: true,
                                      //  backgroundColor: Colors.black54,
                                      waveStyle: WaveStyle(
                                        waveThickness: 4.0,

                                        // showDurationLabel: true,
                                        spacing: 8.0,
                                        showBottom: true,
                                        extendWaveform: true,
                                        showMiddleLine: false,
                                        gradient: ui.Gradient.linear(
                                          Offset(0, 0),
                                          Offset(MediaQuery.of(context).size.width / 3, 5),
                                          [Colors.blue, Colors.green],
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            isMicTrue == true
                                ? IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.black54,
                                      size: 30,
                                    ),
                                    tooltip: 'Start recording',
                                    onPressed: () async {
                                      isMicTrue = !isMicTrue;
                                      isMicPuse = false;
                                      await recorderController.stop();
                                      setState(() {});
                                    },
                                  )
                                : SizedBox(),
                            isMicTrue == true
                                ? Container(
                                    child: isMicPuse == false
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.pause,
                                              color: Colors.red,
                                              size: 30,
                                            ),
                                            tooltip: 'Start recording',
                                            onPressed: () {
                                              isMicPuse = !isMicPuse;

                                              _pause();
                                              setState(() {});
                                              // isMicTrue = false;
                                              print(isMicPuse);
                                            },
                                          )
                                        : IconButton(
                                            icon: Icon(
                                              Icons.mic,
                                              color: Colors.blue,
                                              size: 30,
                                            ),
                                            tooltip: 'Start recording',
                                            onPressed: () {
                                              isMicPuse = !isMicPuse;
                                              _startRecording();
                                              setState(() {});
                                            },
                                          ),
                                  )
                                : SizedBox(),
                            isMicTrue == true
                                ? ClipOval(
                                    child: Material(
                                      color: Colors.teal,
                                      child: InkWell(
                                        onTap: () {
                                          isMicTrue = !isMicTrue;
                                          isMicPuse = false;
                                          _stopRecording();
                                          setState(() {});
                                        },
                                        child: SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: Icon(
                                            Icons.send,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : ClipOval(
                                    child: Material(
                                      color: Colors.teal,
                                      child: InkWell(
                                        onTap: () {
                                          isMicTrue = !isMicTrue;

                                          _startRecording();
                                          setState(() {});
                                          // isMicTrue = false;
                                          print(isMicTrue);
                                        },
                                        child: SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: Icon(
                                            Icons.mic,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ]),
                )
        ],
      ),
    );
  }
}

// todo group chat screen

class GroupChatScreen extends StatefulWidget {
  GroupChatScreen({Key? key, this.groupChat}) : super(key: key);

  // final UserModal? user;
  final ChatUserModal? groupChat;

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  List<MessagesModal> _list = [];

  List list = [];
  final record = Record();
  bool showPlayer = false;
  bool isVoiceRecord = false;
  String? audioPath;
  bool isMicTrue = false;
  AudioPlayer audioPlayer = AudioPlayer();
  bool isMic = false;
  final textController = TextEditingController();
  bool _isEmoji = false, isUploadingImage = false;
  DateTime start = DateTime.now();
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> recordMessage() async {
    if (await record.hasPermission()) {
      await record.start(
        path: 'aFullPath/myFile.m4a',
        encoder: AudioEncoder.aacLc, // by default
        bitRate: 128000, // by default
        samplingRate: 44100, // by default
      );
    }

// Get the state of the recorder
    bool isRecording = await record.isRecording();

// Stop recording
    // await record.stop();
  }

  late final RecorderController recorderController;

  bool isMicPuse = false;
  late String? dateformet;

  void _initialiseController() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialiseController();

    // Apis.isgroup = widget.groupChat?.isGroup;
    Apis.id = widget.groupChat?.groupId;
    Apis.groupId = widget.groupChat?.groupId;
    Apis.groupName = widget.groupChat?.groupName;
    Apis.groupImage = widget.groupChat?.image;
    widget.groupChat?.isPrivate == false ? Apis.creatGroupDynamicLink() : null;

    // _recordSub = _audioRecorder.onStateChanged().listen((recordState) {
    //   _recordState = recordState;
    // });
    //
    // _amplitudeSub =
    //     _audioRecorder.onAmplitudeChanged(const Duration(milliseconds: 300)).listen((amp) => _amplitude = amp);
  }

  void dispose() {
    Apis.connectivityResult;
    super.dispose();
  }

  void _startRecording() async {
    await recorderController.record(
      androidEncoder: AndroidEncoder.aac,
      androidOutputFormat: AndroidOutputFormat.mpeg4,
      sampleRate: 16000,
    );
    setState(() {});
  }

  void appDocDirectory() async {
    //Directory appDocDirectory = await getApplicationDocumentsDirectory();
  }

  void _pause() async {
    await recorderController.pause();
    setState(() {});
  }

  Future<void> _stopRecording() async {
    final path = await recorderController.stop();

    // Apis.isgroup != true
    //     ? Apis.uploadAudioFile(widget.user!, File(path.toString()))
    //   :
    Apis.uploadAudioFileInGroup(widget.groupChat!, File(path.toString()));
    setState(() {});

    // update state here to, for eample, change the button's state
  }

  checkGropuDate(DateTime checkDate) {
    var date = DateTime.now();
    final yesterday = DateTime(date.year, date.month, date.day - 1);
    String yesDay = formatDate(yesterday, [dd, " ", M, " ", yyyy]);
    String newDate = formatDate(date, [dd, " ", M, " ", yyyy]);
    if (formatDate(checkDate, [dd, " ", M, " ", yyyy]) == newDate) {
      return "Today";
    } else if (formatDate(checkDate, [dd, " ", M, " ", yyyy]) == yesDay) {
      return "YesterDay";
    } else {
      return formatDate(checkDate, [dd, " ", M, " ", yyyy]);
    }
  }

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
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: _appBar(),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: Apis.getAllGroupMessages(widget.groupChat!),
                    builder: (contexts, snapshot) {
                      var date = DateTime.now();
                      final yesterday = DateTime(date.year, date.month, date.day - 1);

                      String newDate = formatDate(date, [dd, " ", M, " ", yyyy]);
                      // print("intuu snapshot: ${snapshot}");
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

// todo timezone start
                          return _list.isNotEmpty
                              ? SizedBox(
                                  height: 300,
                                  child: GroupedListView<MessagesModal, DateTime>(
                                    //  controller: controller.reminderController,

                                    elements: _list,
                                    groupBy: (MessagesModal element) => DateTime(
                                      element.sent!.year,
                                      element.sent!.month,
                                      element.sent!.day,
                                    ),
                                    sort: false,

                                    groupComparator: (DateTime value1, DateTime value2) => value2.compareTo(value1),
                                    itemComparator: (MessagesModal item1, MessagesModal item2) =>
                                        item1.sent!.compareTo(item2.sent!),
                                    //  order: GroupedListOrder.DESC,
                                    reverse: true,
                                    useStickyGroupSeparators: false,
                                    groupSeparatorBuilder: (DateTime date) => Container(
                                      alignment: Alignment.center,
                                      width: 50,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey,
                                      ),
                                      margin: EdgeInsets.symmetric(horizontal: 105),
                                      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                                      child: Text(
                                        checkGropuDate(date),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    shrinkWrap: true,
                                    itemBuilder: (c, element) {
                                      var date = DateTime.now();
                                      String newDate = formatDate(date, [dd, yyyy, D]);

                                      return GroupMessageCard(
                                        message: element,
                                        image: list.isNotEmpty ? list[0].image.toString() : widget.groupChat?.image!,
                                        user: Apis.me!,
                                      );
                                    },
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    Apis.sendGroupMessage(widget.groupChat!, "Hi", Type.text);
                                    print("say hi");
                                  },
                                  child: Center(child: Text("Say hi 👏")));

                        // todo time zone end
                        // final _list = [];
                      }
                      return CircularProgressIndicator();
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
                    // config: Config(
                    //   columns: 7,
                    //   emojiSizeMax: 32 *
                    //       (Platform.isAndroid ? 1.0 : 1.35), // Issue: https://github.com/flutter/flutter/issues/28894
                    // ),
                  ),
                ),
            ],
          ),
        )),
      ),
    );
  }

  checkUserOnlineOrOffline() {
    if (Apis.connectivityResult == ConnectivityResult.none) {
      return MyDateUtils.getLastActiveTimeDate(context: context, lastActive: widget.groupChat?.latestActive);
    } else {
      return "Online";
    }
  }

  Widget _appBar() {
    return StreamBuilder(
        stream: Apis.getUserGroupInfo(widget.groupChat!),
        builder: (context, snapshot) {
          final data = snapshot.data?.docs;

          //final list = data?.map((e) => ChatUserModal.fromJson(e.data())).toList() ?? [];
          list = data?.map((e) => ChatUserModal.fromJson(e.data())).toList() ?? [];
          //Apis.isgroup = list[0].isGroup;
          print("ali kkk");
          print(Apis.isgroup);
          return InkWell(
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_) => ViewProfileScreen(user: widget.user!)));
            },
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                      // Navigator.pop(context);

                      print("listtttt");
                      // print(list[0].isOnline!);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black54,
                    )),
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .3),
                  child: CachedNetworkImage(
                    width: mq.width * .13,
                    height: mq.width * .13,
                    fit: BoxFit.fill,
                    imageUrl: list.isNotEmpty ? list[0].image.toString() : widget.groupChat!.image!,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Container(
                        width: mq.width * .13,
                        height: mq.width * .13,
                        color: Colors.grey,
                        child: Icon(Icons.camera_alt)),
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
                      list.isNotEmpty ? list[0].groupName.toString() : widget.groupChat!.groupName.toString(),
                      style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    // Apis.isgroup == true
                    //     ? SizedBox()
                    //     : Text(
                    //         list.isNotEmpty
                    //             ? list[0].isOnline
                    //                 ? "Online"
                    //                 : MyDateUtils.getLastActiveTimeDate(
                    //                     context: context, lastActive: list[0].lastActive)
                    //             : MyDateUtils.getLastActiveTimeDate(
                    //                 context: context, lastActive: widget.groupChat?.latestActive),
                    //         style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                    //       ),
                    // Text(
                    //   checkUserOnlineOrOffline(),
                    //   style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                    // )
                  ],
                ),
                Spacer(),
                PopupMenuButton<int>(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  ),
                  itemBuilder: (context) => [
                    // PopupMenuItem 1

                    PopupMenuItem(
                      value: 1,
                      // row with 2 children
                      child: Row(
                        children: [
                          //Icon(Icons.settings),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Group info",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    // PopupMenuItem 2
                    PopupMenuItem(
                      value: 2,
                      // row with two children
                      child: Row(
                        children: [
                          //Icon(Icons.update),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ],
                  offset: Offset(0, 40),
                  color: Colors.teal,
                  elevation: 2,
                  // on selected we show the dialog box
                  onSelected: (value) {
                    // if value 1 show dialog
                    if (value == 1) {
                      //addGroupUser();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => GroupInfoScreen(
                                    groupData: widget.groupChat!,
                                  )));
                      setState(() {});
                    } else if (value == 2) {
                      //  controller.buttonLoading.value = true;
                      //  Navigator.push(context, MaterialPageRoute(builder: (_) => GroupScreen()));
                      //UpdateSupplierBottomSheet(context);
                      // _showDialog(context);
                    }
                  },
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
          isMicTrue == true
              ? SizedBox()
              : Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              // FocusScope.of(context).unfocus();
                              setState(() => _isEmoji = !_isEmoji);
                              setState(() {});
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
                          onChanged: (value) {
                            if (value.isNotEmpty && textController.text.isNotEmpty) {
                              isMic = true;
                              setState(() {});
                            } else {
                              isMic = false;
                              setState(() {});
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

                                  //   Apis.setChateImage(widget.user, File(i.path));
                                  Apis.setChateImageInGroup(widget.groupChat!, File(i.path));
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

                                Apis.setChateImageInGroup(widget.groupChat!, File(image.path));
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
          isMic == true
              ? MaterialButton(
                  padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
                  minWidth: 0,
                  onPressed: () {
                    if (textController.text.isNotEmpty) {
                      print("ismike true 44");
                      if (_list.isEmpty) {
                        Apis.sendGroupMessage(widget.groupChat!, textController.text, Type.text);
                        print("ismike true 34");
                      } else {
                        isUploadingImage = true;
                        Apis.sendGroupMessage(widget.groupChat!, textController.text, Type.text);
                        isUploadingImage = false;
                        textController.clear();
                        isMic = false;
                        print("ismike true 11");
                      }
                      textController.clear();
                      isMic = false;
                      print("ismike true");
                    }
                    setState(() {});
                  },
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  shape: CircleBorder(),
                  color: Colors.green,
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // AudioWaveforms(
                        //   //backgroundColor: Colors.yellow,
                        //   size: Size(MediaQuery.of(context).size.width, 100.0),
                        //   recorderController: recorderController,
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            isMicTrue == true
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black54,
                                    ),
                                    width: mq.width * .50,
                                    child: AudioWaveforms(
                                      size: Size(MediaQuery.of(context).size.width, 50.0),
                                      recorderController: recorderController,
                                      enableGesture: true,
                                      //  backgroundColor: Colors.black54,
                                      waveStyle: WaveStyle(
                                        waveThickness: 4.0,

                                        // showDurationLabel: true,
                                        spacing: 8.0,
                                        showBottom: true,
                                        extendWaveform: true,
                                        showMiddleLine: false,
                                        gradient: ui.Gradient.linear(
                                          Offset(0, 0),
                                          Offset(MediaQuery.of(context).size.width / 3, 5),
                                          [Colors.blue, Colors.green],
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            isMicTrue == true
                                ? IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.black54,
                                      size: 30,
                                    ),
                                    tooltip: 'Start recording',
                                    onPressed: () async {
                                      isMicTrue = !isMicTrue;
                                      isMicPuse = false;
                                      await recorderController.stop();
                                      setState(() {});
                                    },
                                  )
                                : SizedBox(),
                            isMicTrue == true
                                ? Container(
                                    child: isMicPuse == false
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.pause,
                                              color: Colors.red,
                                              size: 30,
                                            ),
                                            tooltip: 'Start recording',
                                            onPressed: () {
                                              isMicPuse = !isMicPuse;

                                              _pause();
                                              setState(() {});
                                              // isMicTrue = false;
                                              print(isMicPuse);
                                            },
                                          )
                                        : IconButton(
                                            icon: Icon(
                                              Icons.mic,
                                              color: Colors.blue,
                                              size: 30,
                                            ),
                                            tooltip: 'Start recording',
                                            onPressed: () {
                                              isMicPuse = !isMicPuse;
                                              _startRecording();
                                              setState(() {});
                                            },
                                          ),
                                  )
                                : SizedBox(),
                            isMicTrue == true
                                ? ClipOval(
                                    child: Material(
                                      color: Colors.teal,
                                      child: InkWell(
                                        onTap: () {
                                          isMicTrue = !isMicTrue;
                                          isMicPuse = false;
                                          _stopRecording();
                                          setState(() {});
                                        },
                                        child: SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: Icon(
                                            Icons.send,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : ClipOval(
                                    child: Material(
                                      color: Colors.teal,
                                      child: InkWell(
                                        onTap: () {
                                          isMicTrue = !isMicTrue;

                                          _startRecording();
                                          setState(() {});
                                          // isMicTrue = false;
                                          print(isMicTrue);
                                        },
                                        child: SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: Icon(
                                            Icons.mic,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ]),
                )
        ],
      ),
    );
  }
}
