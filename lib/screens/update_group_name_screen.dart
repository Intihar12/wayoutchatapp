import 'package:wayoutchatapp/barrel.dart';

class UpdateGroupName extends StatefulWidget {
  UpdateGroupName({
    Key? key,
  }) : super(key: key);

  @override
  State<UpdateGroupName> createState() => _UpdateGroupNameState();
}

class _UpdateGroupNameState extends State<UpdateGroupName> {
  TextEditingController textController = TextEditingController();
  bool _isEmoji = false;

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
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.teal,
            title: Text(
              "Enter new subject",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                        width: 220,
                        child: TextFormField(
                          controller: textController,
                          onTap: () {
                            if (_isEmoji) {
                              setState(() => _isEmoji = !_isEmoji);
                            }
                          },
                          decoration: InputDecoration(hintText: Apis.groupName ?? "update group name 👏"),
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    IconButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          setState(() => _isEmoji = !_isEmoji);
                          // setState(() {});
                        },
                        icon: Icon(
                          Icons.emoji_emotions,
                          color: Colors.grey,
                        )),
                  ],
                ),
              ),
              Spacer(),
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
              Divider(
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50.0, right: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.teal),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 2,
                      color: Colors.grey,
                    ),
                    InkWell(
                        onTap: () {
                          Apis.updateGroupName(context, textController.text);
                        },
                        child: Text("Ok"))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
