import 'package:wayoutchatapp/barrel.dart';

welcomeSheet(BuildContext context, {String? groupId}) {
  return showModalBottomSheet(
      context: context,
      builder: (BuildContext contexts) {
        return WelcomeSheet(
          groupId: groupId,
        );
      });
}

class WelcomeSheet extends StatefulWidget {
  final String? groupId;

  const WelcomeSheet({
    Key? key,
    this.groupId,
  }) : super(key: key);

  @override
  State<WelcomeSheet> createState() => _WelcomeSheetState();
}

class _WelcomeSheetState extends State<WelcomeSheet> {
  @override
  Widget build(BuildContext context) {
    var spaceBetween = const SizedBox(
      height: 10,
    );
    var spaceAround = const SizedBox(
      width: 10,
    );
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chats').doc(widget.groupId).snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              Apis.usersId.clear();
              final data = snapshot.data;
              print("this is data");
              print(data);
              Apis.usersId = data?["users"] ?? "";
              print("Apis.usersId");
              print(Apis.usersId);
              List chatMessages = [];
              chatMessages.add(widget.groupId);
              return FutureBuilder(
                  future: Apis.getAllGroupUsers(chatMessages),
                  builder: (contexts, snapshot) {
                    //    print("intuu snapshot: ${Apis.usersIds}");
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data;
                        List list =
                            data?.map((e) => UserModal.fromJson(e.data() as Map<String, dynamic>?)).toList() ?? [];
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: list.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                height: 200,
                                color: Colors.white,
                                padding: const EdgeInsets.only(left: 20, right: 20, top: 2, bottom: 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Center(
                                    //   child: Text(
                                    //     "welcome",
                                    //   ),
                                    // ),
                                    // const Spacer(),
                                    Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.teal,
                                        ),
                                        height: 5,
                                        width: 30,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),

                                    Text(
                                      "${Apis.usersId.contains(Apis.user.uid) ? "Already exist in this group" : "you want to join this group"}",
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(mq.height * .3),
                                            child: CachedNetworkImage(
                                              width: mq.width * .13,
                                              height: mq.width * .13,
                                              fit: BoxFit.fill,
                                              imageUrl: list[index].image ?? "",
                                              placeholder: (context, url) => CircularProgressIndicator(),
                                              errorWidget: (context, url, error) => Container(
                                                  width: mq.width * .13,
                                                  height: mq.width * .13,
                                                  color: Colors.grey,
                                                  child: Icon(Icons.person_add)),
                                            ),
                                          ),
                                          spaceAround,
                                          spaceAround,
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  list[index].name ?? "Name",
                                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                            Apis.usersId.contains(Apis.user.uid)
                                                ? Navigator.pop(context)
                                                : Apis.groupJoinByLink(context, widget.groupId.toString(), list[index])
                                                    .whenComplete(() => Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) => ChatScreen(user: list[index]))));
                                          },
                                          child: Container(
                                            width: 80,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.teal,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "${Apis.usersId.contains(Apis.user.uid) ? "Cancel" : "Join"}",
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    spaceBetween,
                                  ],
                                ),
                              );
                            });
                    }
                  });
          }
        });
  }
}
