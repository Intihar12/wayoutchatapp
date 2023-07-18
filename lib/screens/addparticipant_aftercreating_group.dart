import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wayoutchatapp/main.dart';
import 'package:wayoutchatapp/screens/card_groop_screen.dart';

import '../api/apis.dart';
import '../modals/chat_user_modal.dart';
import '../widgets/cart_chat_user.dart';
import '../widgets/dialods/profile_dialog.dart';
import 'group_screen_data.dart';

class AddParticipantAfterGroupScreen extends StatefulWidget {
  const AddParticipantAfterGroupScreen({Key? key}) : super(key: key);

  @override
  State<AddParticipantAfterGroupScreen> createState() => _AddParticipantAfterGroupScreenState();
}

class _AddParticipantAfterGroupScreenState extends State<AddParticipantAfterGroupScreen> {
  List<ChatUserModal> list = [];
  final List<ChatUserModal> searchList = [];
  bool isSearch = false;
  List<ChatUserModal> gropuLists = [];
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> addGroupUserList(List ids) async {
    Apis.gropuList.clear();
    QuerySnapshot data = await fireStore.collection('Users').where("id", whereIn: ids.isEmpty ? [''] : ids).get();

    for (var drvList in data.docs) {
      Map<String, dynamic>? map = drvList.data() as Map<String, dynamic>?;

      ChatUserModal modal = ChatUserModal.fromJson(map);

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
                  print("buguuu");
                  Apis.addOtherParticipants(context, Apis.id.toString());
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => GroupScreenData()));
                  print("ides");
                  // Apis.gropuListIds.add(Apis.user.uid);
                  // print(Apis.gropuListIds);
                  //Apis.saveMembers(Apis.members);
                  // Apis.createUserff();
                  print("daban bugu");
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
        stream: Apis.getMyGroupId(Apis.id.toString()),
        builder: (context, snapShot) {
          switch (snapShot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              List<String> usersId = snapShot.data?.docs.map((e) => e.id).toList() ?? [];

              return StreamBuilder(
                stream: Apis.getMyUsersId(),
                builder: (context, snapShot) {
                  switch (snapShot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      return StreamBuilder(
                          stream: Apis.getAllUsersForGroup(snapShot.data?.docs.map((e) => e.id).toList() ?? []),
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
                                final data = snapshot.data?.docs;

                                list = data?.map((e) => ChatUserModal.fromJson(e.data())).toList() ?? [];

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
                                                              placeholder: (context, url) =>
                                                                  CircularProgressIndicator(),
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
                                                  onTap: usersId.contains(list[index].id)
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
                                                          color: usersId.contains(list[index].id)
                                                              ? Colors.grey
                                                              : Colors.black,
                                                          fontSize: 20),
                                                    ),
                                                    subtitle: Text(usersId.contains(list[index].id)
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
                  }
                },
              );
          }
        },
      ),
    );
  }
}
