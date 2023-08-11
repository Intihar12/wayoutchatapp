import 'package:wayoutchatapp/barrel.dart';

class AddParticipantAfterGroupScreen extends StatefulWidget {
  const AddParticipantAfterGroupScreen({Key? key}) : super(key: key);

  @override
  State<AddParticipantAfterGroupScreen> createState() => _AddParticipantAfterGroupScreenState();
}

class _AddParticipantAfterGroupScreenState extends State<AddParticipantAfterGroupScreen> {
  List<UserModal> list = [];
  final List<UserModal> searchList = [];
  bool isSearch = false;
  List<UserModal> gropuLists = [];
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> addGroupUserList(List ids) async {
    Apis.gropuList.clear();
    QuerySnapshot data = await fireStore.collection('Users').where("id", whereIn: ids.isEmpty ? [''] : ids).get();

    for (var drvList in data.docs) {
      Map<String, dynamic>? map = drvList.data() as Map<String, dynamic>?;

      UserModal modal = UserModal.fromJson(map);

      Apis.gropuList.add(modal);

      setState(() {});

      //driverList = seracgDriverList;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Apis.gropuList.clear();
    Apis.gropuListIds.clear();
    Apis.usersId.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Apis.gropuList.isEmpty
          ? SizedBox()
          : Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: FloatingActionButton(
                onPressed: () async {
                  Apis.addOtherParticipants(context, Apis.id.toString());
                  setState(() {});
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => GroupScreenData()));
                },
                backgroundColor: Colors.teal,
                child: Icon(Icons.done),
              ),
            ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "New group",
                  style: TextStyle(fontSize: 25),
                ),
                Text(
                  "Add participants",
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
            Spacer(),
            Icon(
              Icons.search,
              color: Colors.black,
            )
          ],
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('chats').doc(Apis.id).snapshots(),
          builder: (context, snapshot) {
            Apis.usersId.clear();
            final data = snapshot.data;
            Apis.usersId = data?["users"];
            // print("this is user ids of");
            // print(Apis.usersId);
            // // List<String> usersId = [];
            // final data = snapshot.data ?? "";
            // QuerySnapshot<Map<String, dynamic>> querySnapshot;
            // snapshot.data?.docs.forEach((doc) {
            //   // Assuming the "users" field is an array of strings.
            //   List<String> users = List.from(doc.data()['users']);
            //
            //   Apis.usersId.addAll(users);
            //   print(Apis.usersId);
            //   // if (usersId.contains(Apis.user.uid)) {
            //   //   usersId.remove(Apis.user.uid);
            //   // }
            // });

            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .where("users", arrayContains: Apis.user.uid)
                    .where("isPrivate", isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  List<String> myUsersId = [];
                  final data = snapshot.data?.docs;

                  data?.forEach((element) {
                    List tempList = element["users"];
                    tempList.forEach((entry) {
                      if (!myUsersId.contains(entry)) {
                        myUsersId.add(entry);
                      } else {}
                    });
                  });

                  // final data = snapshot.data ?? "";
                  // QuerySnapshot<Map<String, dynamic>> querySnapshot;
                  // snapshot.data?.docs.forEach((doc) {
                  //   // Assuming the "users" field is an array of strings.
                  //   List<String> users = List.from(doc.data()['users']);
                  //
                  //   myUsersId.addAll(users);
                  if (myUsersId.contains(Apis.user.uid)) {
                    myUsersId.remove(Apis.user.uid);
                  }
                  print("myuser id");
                  print(myUsersId);
                  // });

                  return FutureBuilder(
                      future: Apis.getAllUsersForAddParticipants(myUsersId ?? []),
                      builder: (contexts, snapshot) {
                        // print("intuu snapshot: ${snapshot}");
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data;

                            list =
                                data?.map((e) => UserModal.fromJson(e.data() as Map<String, dynamic>)).toList() ?? [];

                            if (list.isNotEmpty) {
                              return Column(
                                children: [
                                  Apis.gropuList.isEmpty
                                      ? SizedBox()
                                      : Container(
                                          padding: EdgeInsets.only(left: 15),
                                          height: 100,
                                          child: ListView.builder(
                                              itemCount: Apis.gropuList.length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (BuildContext context, int index) {
                                                print("list length");
                                                print(Apis.gropuList.length);
                                                return Padding(
                                                  padding: const EdgeInsets.only(right: 15.0, top: 15),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(mq.height * .3),
                                                        child: CachedNetworkImage(
                                                          width: mq.width * .13,
                                                          height: mq.width * .13,
                                                          fit: BoxFit.fill,
                                                          imageUrl: Apis.gropuList[index].image.toString(),
                                                          placeholder: (context, url) => CircularProgressIndicator(),
                                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                                        ),
                                                      ),
                                                      Text("${Apis.gropuList[index].name}"),
                                                      // Text(gropuList[index]['image']),
                                                    ],
                                                  ),
                                                );
                                              }),
                                        ),
                                  Apis.gropuList.isEmpty
                                      ? SizedBox()
                                      : SizedBox(
                                          child: Divider(
                                          height: 2,
                                          color: Colors.black,
                                        )),
                                  Expanded(
                                    // height: 200,
                                    child: ListView.builder(
                                        itemCount: isSearch ? searchList.length : list.length,
                                        padding: EdgeInsets.only(top: mq.height * .01),
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          print("gropuList");
                                          print(Apis.gropuList);
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                                            child: InkWell(
                                              onTap: Apis.usersId.contains(list[index].id)
                                                  ? () {}
                                                  : () async {
                                                      // Map<String, dynamic> users = {
                                                      //   "name": list[index].name,
                                                      //   "id": list[index].id,
                                                      //   "image": list[index].image
                                                      // };

                                                      print("api isdd");
                                                      print(Apis.gropuListIds);
                                                      //  if (Apis.gropuList.isNotEmpty) {
                                                      if (Apis.gropuListIds.contains(list[index].id)) {
                                                        await Apis.gropuListIds.remove(list[index].id);

                                                        addGroupUserList(Apis.gropuListIds);
                                                        //   Apis.gropuList.remove(users);
                                                        // setState(() {});
                                                      } else {
                                                        Apis.gropuListIds.add(list[index].id);
                                                        print("group iddddd");
                                                        print(Apis.gropuListIds);
                                                        addGroupUserList(Apis.gropuListIds);
                                                      }

                                                      setState(() {});
                                                    },
                                              child: ListTile(
                                                leading: InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (_) => ProfileDialog(
                                                              user: list[index],
                                                            ));
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(mq.height * .3),
                                                    child: CachedNetworkImage(
                                                      width: mq.width * .15,
                                                      height: mq.width * .15,
                                                      fit: BoxFit.fill,
                                                      imageUrl: list[index].image.toString(),
                                                      placeholder: (context, url) => CircularProgressIndicator(),
                                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),
                                                title: Text(
                                                  list[index].name.toString(),
                                                  style: TextStyle(
                                                      color: Apis.usersId.contains(list[index].id)
                                                          ? Colors.grey
                                                          : Colors.black,
                                                      fontSize: 20),
                                                ),
                                                subtitle: Text(Apis.usersId.contains(list[index].id)
                                                    ? "User already exist"
                                                    : list[index].about.toString()),
                                              ),
                                            ),
                                          );
                                          //   CartGroupScreen(
                                          //   user: isSearch ? searchList[index] : list[index],
                                          // );
                                        }),
                                  ),
                                ],
                              );
                            } else {
                              return Center(child: Text("No connection is found"));
                            }
                        }
                      });
                });
          }),
    );
  }
}
