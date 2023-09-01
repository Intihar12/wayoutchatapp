import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wayoutchatapp/api/apis.dart';

import '../modals/call.dart';
import '../modals/user_modal.dart';
import '../widgets/user_photo.dart';

const appID = "a8af647b9ed84f909db5e95c252d4878";
const tokenBaseUrl = "https://wayoutchatapp.herokuapp.com";

class VideoPage extends StatefulWidget {
  final UserModal user;
  final CallModel call;

  const VideoPage({super.key, required this.user, required this.call});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  RtcEngine? rtcEngine;
  String? token;
  int uid = 0;
  bool localUserJoined = false;
  String? callID;
  int? remoteUid;

  @override
  void initState() {
    setState(() {
      callID = widget.call.id;

      rtcEngine = createAgoraRtcEngine();
    });
    super.initState();
    initializeCall();
    // Future.delayed(const Duration(milliseconds: 1000)).then(
    //   (_) {
    //     getToken();
    //   },
    // );
  }

  @override
  void dispose() {
    rtcEngine!.release();
    rtcEngine!.leaveChannel();
    super.dispose();
  }

  Future<void> getToken() async {
    // final response = await http
    //     .get(Uri.parse('$tokenBaseUrl/rtc/${widget.call.channel}/publisher/uid/${widget.user.id}?expiry=3600'));
    final response = await http.get(Uri.parse('$tokenBaseUrl/rtc/token?uid=$uid'));
    print("this is response");
    print(response);
    print(response.statusCode);
    if (response.statusCode == 404) {
      setState(() {
        // token = jsonDecode(response.body)['rtcToken'];
        token =
            "elh4SpuNRGa_tWmBLlnZQT:APA91bHC4nWmkI97EBtjutEmZgHVjhWmOCxHXAXUZInpy5jyqWcu2yQ6n3kumeB376ipYtcUK95Gsoxn-eHGCaKL6-hPagcYjuVqdca3GmbdwN0pBB7Z1xGw668Q_BEE4asY6NxTx09D";
        print(token);
        print("this is token");
      });
      initializeCall();
    }
  }

  Future<void> initializeCall() async {
    await [Permission.microphone, Permission.camera].request();

    await rtcEngine?.initialize(const RtcEngineContext(appId: appID));

    await rtcEngine?.enableVideo();
    print("thi ssi enableVideo");
    rtcEngine?.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          print("this is onJoinChannelSuccess");
          setState(() {
            localUserJoined = true;
          });
          if (widget.call.id == null) {
            //MAKE A CALL
            makeCall();
          }
        },
        onUserJoined: (connection, _remoteUid, elapsed) {
          setState(() {
            remoteUid = _remoteUid;
          });
        },
        // onLeaveChannel: (connection, stats) {
        //   callsCollection.doc(widget.call.id).update(
        //     {
        //       'active': false,
        //     },
        //   );
        //   Navigator.pop(context);
        // },
        onUserOffline: (connection, _remoteUid, reason) {
          setState(() {
            remoteUid = null;
          });
          rtcEngine?.leaveChannel();
          rtcEngine?.release();
          Navigator.pop(context);
          // callsCollection.doc(widget.call.id).update(
          //   {
          //     'active': false,
          //   },
          // );
        },
      ),
    );

    await joinVideoChannel();
  }

  makeCall() async {
    //var callDocRef = Apis.fireStore.collection("Users");
    DocumentReference callDocRef = Apis.callsCollection.doc();

    //FirebaseFirestore callDocRef = FirebaseFirestore.instance.collection("Users");
    setState(() {
      callID = callDocRef.id;
    });
    await callDocRef.set(
      {
        'id': callDocRef.id,
        'channel': widget.call.channel,
        'caller': widget.call.caller,
        'called': widget.call.called,
        'active': true,
        'accepted': false,
        'rejected': false,
        'connected': false,
      },
    );
  }

  Future joinVideoChannel() async {
    await rtcEngine?.startPreview();

    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await rtcEngine?.joinChannel(
        token:
            "007eJxTYHDoO1h0VmbqpRXeK77IbH7fefXnmsfblv04eGDVa1NP3Q1vFBgSLRLTzEzMkyxTUyxM0iwNLFOSTFMtTZONTI1STCzMLXSefkxpCGRkWClqycrIAIEgvgxDRmGEq7uxZVZgeWpQqWV+mreZsbGZe0pkcWSiEQMDAJjfK5M=",
        channelId: widget.call.channel,
        uid: uid,
        options: options);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            "${widget.user.name}",
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: localUserJoined == false || callID == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : StreamBuilder<DocumentSnapshot>(
                stream: Apis.callsCollection.doc(callID!).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    CallModel call = CallModel(
                      id: snapshot.data!['id'],
                      channel: snapshot.data!['channel'],
                      caller: snapshot.data!['caller'],
                      called: snapshot.data!['called'],
                      active: snapshot.data!['active'],
                      accepted: snapshot.data!['accepted'],
                      rejected: snapshot.data!['rejected'],
                      connected: snapshot.data!['connected'],
                    );

                    return call.rejected == true
                        ? const Text("Call Declined")
                        : Stack(
                            children: [
                              //OTHER USER'S VIDEO WIDGET
                              Center(
                                child: remoteVideo(call: call),
                              ),
                              //LOCAL USER VIDEO WIDGET
                              if (rtcEngine != null)
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: SizedBox(
                                      width: 100,
                                      height: 150,
                                      child: AgoraVideoView(
                                        controller: VideoViewController(
                                          rtcEngine: rtcEngine!,
                                          canvas: VideoCanvas(uid: uid),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 40),
                                    child: FloatingActionButton(
                                      backgroundColor: Colors.red,
                                      onPressed: () {
                                        rtcEngine?.leaveChannel();
                                      },
                                      child: const Icon(
                                        Icons.call_end_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                  }
                  return const SizedBox.shrink();
                },
              ),
      ),
    );
  }

  Widget remoteVideo({required CallModel call}) {
    return Stack(
      children: [
        if (remoteUid != null)
          AgoraVideoView(
            controller: VideoViewController.remote(
              rtcEngine: rtcEngine!,
              canvas: VideoCanvas(uid: remoteUid),
              connection: RtcConnection(channelId: call.channel),
            ),
          ),
        if (remoteUid == null)
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  userPhoto(radius: 50, url: widget.user.image!),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(call.connected == false ? "Connecting to ${widget.user.name}" : "Waiting Response"),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// import 'dart:async';
//
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:wayoutchatapp/api/apis.dart';
//
// const appId = "a8af647b9ed84f909db5e95c252d4878";
// const token = "b82e4a107f4c45109e2c7d37f18e18f0";
// const channel = "high_importance_channel";
//
// //void main() => runApp(const MaterialApp(home: MyApp()));
//
// class VoiceCallScreen extends StatefulWidget {
//   const VoiceCallScreen({Key? key}) : super(key: key);
//
//   @override
//   State<VoiceCallScreen> createState() => _VoiceCallScreenState();
// }
//
// class _VoiceCallScreenState extends State<VoiceCallScreen> {
//   int? _remoteUid;
//   bool _localUserJoined = false;
//   late RtcEngine _engine;
//
//   @override
//   void initState() {
//     setState(() {
//       // callID = widget.call.id;
//       _engine = createAgoraRtcEngine();
//     });
//     super.initState();
//     initAgora();
//   }
//
//   Future<void> initAgora() async {
//     // retrieve permissions
//     await [Permission.microphone, Permission.camera].request();
//
//     //create the engine
//
//     print("this is app id");
//     print(_engine);
//     print(appId);
//     await _engine.initialize(const RtcEngineContext(
//       appId: appId,
//       //channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//     ));
//     await _engine.enableVideo();
//     print("this is app id after");
//     print(appId);
//     _engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (connection, elapsed) {
//           debugPrint("local user ${connection.localUid} joined");
//           print("this is location connection.localUid");
//           print(connection.localUid);
//           setState(() {
//             _localUserJoined = true;
//             print("this is setstate");
//           });
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           // debugPrint("remote user $remoteUid joined");
//           print("this is remote remoteUid");
//           print(remoteUid);
//           setState(() {
//             _remoteUid = remoteUid;
//           });
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
//           //  debugPrint("remote user $remoteUid left channel");
//           print("user onUserOffline");
//           print(remoteUid);
//           setState(() {
//             _remoteUid = null;
//           });
//         },
//         onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
//           //   debugPrint('[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
//           print("this is token");
//           print(token);
//         },
//       ),
//     );
//
//     await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
//     await _engine.enableVideo();
//     await _engine.startPreview();
//
//     await _engine.joinChannel(
//       token: token,
//       channelId: channel,
//       uid: 0,
//       options: const ChannelMediaOptions(),
//     );
//   }
//
//   // Create UI with local view and remote view
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Agora Video Call'),
//       ),
//       body: Stack(
//         children: [
//           Center(
//             child: _remoteVideo(),
//           ),
//           Align(
//             alignment: Alignment.topLeft,
//             child: SizedBox(
//               width: 100,
//               height: 150,
//               child: Center(
//                 child: _localUserJoined
//                     ? AgoraVideoView(
//                         controller: VideoViewController(
//                           rtcEngine: _engine,
//                           canvas: const VideoCanvas(uid: 0),
//                         ),
//                       )
//                     : const CircularProgressIndicator(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Display remote user's video
//   Widget _remoteVideo() {
//     if (_remoteUid != null) {
//       return AgoraVideoView(
//         controller: VideoViewController.remote(
//           rtcEngine: _engine,
//           canvas: VideoCanvas(uid: _remoteUid),
//           connection: const RtcConnection(channelId: channel),
//         ),
//       );
//     } else {
//       return const Text(
//         'Please wait for remote user to join',
//         textAlign: TextAlign.center,
//       );
//     }
//   }
// }
