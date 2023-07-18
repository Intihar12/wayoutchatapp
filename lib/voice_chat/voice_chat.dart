import 'dart:io';

import 'dart:ui' as ui;
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../api/apis.dart';
import '../main.dart';
import '../modals/chat_user_modal.dart';
import '../modals/messages_modal.dart';
import '../screens/date_formated.dart';

class AudioWave extends StatefulWidget {
  AudioWave({Key? key, required this.message}) : super(key: key);

//  final ChatUserModal user;
  final MessagesModal message;

  @override
  State<AudioWave> createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  // todo for play
  late final PlayerController playerController;

  void _initialiseControllers() {
    playerController = PlayerController();
  }

  // late Future<Duration?> futureDuration;

  // todo for play
  late final RecorderController recorderController;

  bool isMicTrue = false;
  bool isMicPuse = false;

  void _initialiseController() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;
  }

  late Directory directory;

  @override
  void initState() {
    super.initState();
    _initialiseControllers();
    _initialiseController();
    intrdridity();
  }

  void _playandPause() async {
    playerController.playerState == PlayerState.playing
        ? await playerController.pausePlayer()
        : await playerController.startPlayer(finishMode: FinishMode.loop);
  }

  void intrdridity() async {
    directory = await getApplicationDocumentsDirectory();
    String? path = "${directory.path}" + "/" + "${widget.message.msg.toString()}";

    print("paaaaaa");
    print(path);
    print("pathhhh");
    playerController.preparePlayer(path: path);
    ;
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
    print("path");

    print(path);
    print("path");
    //  print(path.toString());
    //Apis.uploadAudioFile(widget.user, File(path.toString()));
    setState(() {});

    // update state here to, for eample, change the button's state
  }

  @override
  Widget build(BuildContext context) {
    bool isMe = Apis.user.uid == widget.message.fromId;
    return InkWell(
      onLongPress: () {
        //showBottomSheet(isMe);
      },
      child: isMe ? _greenMessage() : _blueMessage(),
    );

    Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 50.0, left: 20, right: 20),
      child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
        // Row(
        //   children: [
        //     isMicTrue == true
        //         ? Container(
        //             width: 180,
        //             color: Colors.black,
        //             child: AudioWaveforms(
        //               size: Size(MediaQuery.of(context).size.width, 50.0),
        //               recorderController: recorderController,
        //               enableGesture: true,
        //               backgroundColor: Colors.black54,
        //               waveStyle: WaveStyle(
        //                 // showDurationLabel: true,
        //                 spacing: 8.0,
        //                 showBottom: false,
        //                 extendWaveform: true,
        //                 showMiddleLine: false,
        //                 gradient: ui.Gradient.linear(
        //                   const Offset(0, 0),
        //                   Offset(MediaQuery.of(context).size.width / 4, 5),
        //                   [Colors.blue, Colors.green],
        //                 ),
        //               ),
        //             ),
        //           )
        //         : SizedBox(),
        //     isMicTrue == true
        //         ? IconButton(
        //             icon: Icon(
        //               Icons.send,
        //               color: Colors.green,
        //             ),
        //             tooltip: 'Start recording',
        //             onPressed: () {
        //               isMicTrue = !isMicTrue;
        //               isMicPuse = false;
        //               _stopRecording();
        //               setState(() {});
        //             },
        //           )
        //         : IconButton(
        //             icon: Icon(Icons.mic),
        //             tooltip: 'Start recording',
        //             onPressed: () {
        //               isMicTrue = !isMicTrue;
        //
        //               _startRecording();
        //               setState(() {});
        //               // isMicTrue = false;
        //               print(isMicTrue);
        //             },
        //           ),
        //     isMicTrue == true
        //         ? Container(
        //             child: isMicPuse == false
        //                 ? IconButton(
        //                     icon: Icon(Icons.pause),
        //                     tooltip: 'Start recording',
        //                     onPressed: () {
        //                       isMicPuse = !isMicPuse;
        //
        //                       _pause();
        //                       setState(() {});
        //                       // isMicTrue = false;
        //                       print(isMicPuse);
        //                     },
        //                   )
        //                 : IconButton(
        //                     icon: Icon(
        //                       Icons.stop,
        //                       color: Colors.red,
        //                     ),
        //                     tooltip: 'Start recording',
        //                     onPressed: () {
        //                       isMicPuse = !isMicPuse;
        //                       _startRecording();
        //                       setState(() {});
        //                     },
        //                   ),
        //           )
        //         : SizedBox(),
        //     isMicTrue == true
        //         ? IconButton(
        //             icon: Icon(Icons.delete),
        //             tooltip: 'Start recording',
        //             onPressed: () async {
        //               isMicTrue = !isMicTrue;
        //               isMicPuse = false;
        //               await recorderController.stop();
        //               setState(() {});
        //             },
        //           )
        //         : SizedBox(),
        //   ],
        // ),

        IconButton(
            onPressed: () {
              _playandPause();
              setState(() {});
            },
            icon: Icon(
              Icons.play_arrow,
              color: Colors.blue,
            )),
        SizedBox(
          height: 20,
        ),
        Container(
          color: Colors.pink,
          child: AudioFileWaveforms(
            enableSeekGesture: true,
            backgroundColor: Colors.teal,
            size: Size(MediaQuery.of(context).size.width, 50.0),
            playerController: playerController,
          ),
        ),
        SizedBox(
          height: 20,
        ),

        Container(
          color: Colors.blue,
          child: AudioFileWaveforms(
            backgroundColor: Colors.red,
            enableSeekGesture: true,
            size: Size(MediaQuery.of(context).size.width / 2, 70),
            playerController: playerController,
            //density: 1.5,
            playerWaveStyle: const PlayerWaveStyle(
              scaleFactor: 0.8,
              fixedWaveColor: Colors.white30,
              liveWaveColor: Colors.black54,
              waveCap: StrokeCap.butt,
            ),
          ),
        )
      ]),
    ));
  }

  // todo

  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: mq.width * .01,
            ),
            if (widget.message.read != null)
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.done_all_rounded,
                    color: Colors.blue,
                    size: mq.width * .06,
                  )),
            SizedBox(
              width: mq.width * .001,
            ),
            Text(
              //  widget.message.sent.toString(),
              MyDateUtils.getFormatTime(context, widget.message.sent),
              style: TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ],
        ),
        Flexible(
          child: Container(
              padding: _buildPadding(widget.message.type),
              // padding: EdgeInsets.all(widget.message.type == Type.image ? mq.width * .043 : mq.width * .03),
              margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: mq.height * .01),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 218, 255, 176),
                  border: Border.all(color: Colors.lightGreen),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20))),
              child: _buildMessage(widget.message.type)),
        ),
      ],
    );
    ;
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
              padding: _buildPadding(widget.message.type),
              //  padding: EdgeInsets.all(widget.message.type == Type.image ? mq.width * .03 : mq.width * .03),
              margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: mq.height * .03),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 221, 245, 255),
                  border: Border.all(color: Colors.lightBlue),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20))),
              child: _buildMessage(widget.message.type)
              // widget.message.type == Type.image
              //     ? widget.message.type == Type.audio
              //         ? ClipRRect(
              //             borderRadius: BorderRadius.circular(mq.height * .03),
              //             child: CachedNetworkImage(
              //               imageUrl: widget.message.msg!,
              //               placeholder: (context, url) => CircularProgressIndicator(),
              //               errorWidget: (context, url, error) => Icon(
              //                 Icons.error,
              //                 size: 70,
              //               ),
              //             ),
              //           )
              //         : VoiceMessage(
              //             audioSrc: (widget.message.msg),
              //             played: false,
              //             // To show played badge or not.
              //             me: false,
              //             // Set message side.
              //             onPlay: () {},
              //             // Do something when voice played.
              //             meBgColor: Colors.purple,
              //             contactBgColor: Colors.red,
              //             contactFgColor: Colors.green,
              //             contactPlayIconColor: Colors.white,
              //           )
              //     : Text(
              //         widget.message.msg.toString(),
              //         style: TextStyle(fontSize: 15, color: Colors.black87),
              //       )
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

  Widget _buildMessage(Type? type) {
    print("type");
    print(type);
    switch (type) {
      case Type.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(mq.height * .03),
          child: CachedNetworkImage(
            imageUrl: widget.message.msg!,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(
              Icons.error,
              size: 70,
            ),
          ),
        );
      case Type.audio:
        return Row(
          children: [
            IconButton(
                onPressed: () {
                  _playandPause();
                },
                icon: Icon(Icons.play_arrow)),
            Container(
              width: 130,
              child: AudioFileWaveforms(
                size: Size(MediaQuery.of(context).size.width, 10.0),
                playerController: playerController,
              ),
            )
          ],
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
        return Text(
          widget.message.msg.toString(),
          style: TextStyle(fontSize: 15, color: Colors.black87),
        );

      default:
        return SizedBox();
        break;
    }
  }

  // todo
  _buildPadding(Type? type) {
    print("type");
    print(type);
    switch (type) {
      case Type.image:
        return EdgeInsets.all(mq.width * .03);
      case Type.audio:
        return EdgeInsets.all(mq.width * .02);

      case Type.text:
        return EdgeInsets.all(mq.width * .04);

      default:
        return SizedBox();
        break;
    }
  }

  Future<void> play() {
    return playerController.startPlayer();
  }

  Future<void> pause() {
    return playerController.pausePlayer();
  }

  Future<void> reset() async {
    await playerController.stopPlayer();
    return playerController.seekTo(5000);
  }
}
