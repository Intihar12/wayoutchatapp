import 'package:wayoutchatapp/barrel.dart';

class InviteLink extends StatefulWidget {
  const InviteLink({Key? key}) : super(key: key);

  @override
  State<InviteLink> createState() => _InviteLinkState();
}

class _InviteLinkState extends State<InviteLink> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Invite link"),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Text("People who follow this link can join this group without admin approval"),
                SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.teal),
                      child: Icon(
                        Icons.link,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(Apis.urls.toString())
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Divider(
            color: Colors.grey,
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Row(
              children: [
                Icon(
                  Icons.forward_5,
                  color: Colors.black45,
                ),
                SizedBox(
                  width: 20,
                ),
                Text("Send link via whatsApp")
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: InkWell(
              onTap: () {
                // FlutterClipboard.copy(Apis.urls.toString() ?? '').then((_) {
                //   BotToast.showText(
                //     text: "linkCopiedMessage",
                //   );
                // });

                FlutterClipboard.copy(Apis.urls.toString()).whenComplete(() => BotToast.showText(
                      text: "linkCopiedMessage",
                    ));
                setState(() {});
              },
              child: Row(
                children: [
                  Icon(
                    Icons.copy,
                    color: Colors.black45,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Copy link")
                ],
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Row(
              children: [
                Icon(
                  Icons.share,
                  color: Colors.black45,
                ),
                SizedBox(
                  width: 20,
                ),
                Text("Share link")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
