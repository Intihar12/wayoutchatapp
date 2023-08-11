import 'package:wayoutchatapp/barrel.dart';
import 'package:wayoutchatapp/modals/chat_user_modal.dart';

class GroupInfoScreen extends StatefulWidget {
  GroupInfoScreen({Key? key, required this.groupData}) : super(key: key);
  ChatUserModal groupData;

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  int? Participants;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  // Future<void> addGroupUser() async {
  //   Apis.gropuList.clear();
  //   // QuerySnapshot data = await fireStore.collection('Users').where("id", whereIn: ids.isEmpty ? [''] : ids).get();
  //   QuerySnapshot data = await fireStore.collection('Users').doc(Apis.id).collection("my_users").get();
  //   listId = data.docs.map((e) => e.id).toList() ?? [];
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  addGroupUser();
  }

  @override
  Widget build(BuildContext context) {
    // addGroupUser();
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 15, bottom: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
              stream: Apis.getUserGroupInfo(widget.groupData),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data!.docs;

                    final list = data.map((e) => ChatUserModal.fromJson(e.data())).toList();

                    Apis.groupName = list[0].groupName.toString();
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 40.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.arrow_back)),
                              InkWell(
                                onTap: () {
                                  Apis.getAdminIds.contains(Apis.user.uid) ? showBottomSheet() : SizedBox();
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(mq.height * .1),
                                  child: CachedNetworkImage(
                                    width: mq.width * .3,
                                    height: mq.width * .3,
                                    // height: mq.height * .055,
                                    fit: BoxFit.fill,
                                    imageUrl: list[0].image.toString(),
                                    placeholder: (context, url) => CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Container(
                                        //width: mq.width * .15,
                                        // height: mq.width * .20,
                                        color: Colors.grey,
                                        child: Icon(Icons.camera_alt)),
                                  ),
                                ),
                              ),
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
                                          "Add participants",
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
                                          "Change subject",
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
                                    Apis.getAdminIds.contains(Apis.user.uid)
                                        ? Navigator.push(context,
                                            MaterialPageRoute(builder: (_) => AddParticipantAfterGroupScreen()))
                                        : participantBottomSheet(context);
                                  } else if (value == 2) {
                                    //  controller.buttonLoading.value = true;
                                    Apis.getAdminIds.contains(Apis.user.uid)
                                        ? Navigator.push(context, MaterialPageRoute(builder: (_) => UpdateGroupName()))
                                        : changeSubjectGroup(context);
                                    ;
                                    //UpdateSupplierBottomSheet(context);
                                    // _showDialog(context);
                                  }
                                },
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Text(
                              list[0].groupName.toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    );
                }
              },
            ),
            SizedBox(
              height: 70,
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection('chats').doc(Apis.id).snapshots(),
                builder: (context, snapshot) {
                  List<String> usersIds = [];
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data!;
                      List users = data['users'];
                      Apis.getAdminIds = data['adminIds'];

                      Apis.deleteParticipantId = data['users'];
                      Apis.groupParticipantsIds = data['users'];
                      if (users.contains(Apis.id)) {
                        users.remove(Apis.id);
                      }

                      return FutureBuilder(
                          future: Apis.getAllUsersForGroup(users),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                              case ConnectionState.none:
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              case ConnectionState.active:
                              case ConnectionState.done:
                                final data = snapshot.data;

                                List<UserModal> list =
                                    data?.map((e) => UserModal.fromJson(e.data() as Map<String, dynamic>?)).toList() ??
                                        [];

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      list.length.toString() + " participants",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Apis.getAdminIds.contains(Apis.user.uid)
                                        ? Padding(
                                            padding: const EdgeInsets.only(left: 14.0, bottom: 20),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) => AddParticipantAfterGroupScreen()));
                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                    alignment: Alignment.center,
                                                    height: 45,
                                                    width: 45,
                                                    decoration:
                                                        BoxDecoration(shape: BoxShape.circle, color: Colors.teal),
                                                    child: Icon(
                                                      Icons.person_add,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text("Add participants")
                                                ],
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                    Apis.getAdminIds.contains(Apis.user.uid)
                                        ? Padding(
                                            padding: const EdgeInsets.only(left: 14.0),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context, MaterialPageRoute(builder: (context) => InviteLink()));
                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 45,
                                                    width: 45,
                                                    decoration:
                                                        BoxDecoration(shape: BoxShape.circle, color: Colors.teal),
                                                    child: Icon(
                                                      Icons.link,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text("Invite via link")
                                                ],
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                    ListView.builder(
                                        itemCount: list.length,
                                        shrinkWrap: true,
                                        padding: EdgeInsets.only(top: mq.height * .01),
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          Participants = list.length;

                                          return Padding(
                                            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                                            child: InkWell(
                                                onTap: Apis.getAdminIds.contains(Apis.user.uid)
                                                    ? () async {
                                                        _showAlertDialog(context, list[index].name.toString(),
                                                            list[index].id.toString());
                                                        setState(() {});
                                                      }
                                                    : () {},
                                                child: ListTile(
                                                  leading: InkWell(
                                                    onTap: () {
                                                      // showDialog(
                                                      //     context: context,
                                                      //     builder: (_) => ProfileDialog(
                                                      //       user: list[index],
                                                      //     ));
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
                                                    "${list[index].id == Apis.user.uid ? "you" : list[index].name.toString()}",
                                                    style: TextStyle(color: Colors.black, fontSize: 20),
                                                  ),
                                                  subtitle: Text(list[index].about.toString()),

                                                  trailing: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: Colors.tealAccent,
                                                    ),
                                                    child: Apis.getAdminIds.contains(list[index].id)
                                                        ? Text("Group Admin")
                                                        : SizedBox(),
                                                  ),
                                                  // InkWell(
                                                  //     onTap: () {
                                                  //       _showAlertDialog(context, list[index].email.toString(),
                                                  //           list[index].id.toString());
                                                  //     },
                                                  //     child: Icon(Icons.more_horiz)),
                                                )),
                                          );
                                          //   CartGroupScreen(
                                          //   user: isSearch ? searchList[index] : list[index],
                                          // );
                                        }),
                                  ],
                                );
                            }
                          });
                  }
                })
          ],
        ),
      ),
    ));
  }

  String? _image;

  void showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05, left: mq.width * .05),
            children: [
              Text(
                "Group icon",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: mq.height * .07,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
// Pick an image.
                          final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              _image = image.path;
                            });
                            Apis.updateGroupImage(File(_image!));
                            setState(() {});
                            Navigator.pop(context);
                          }
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.image,
                              color: Colors.teal,
                            ),
                            Text("Gallery")
                          ],
                        )),
                    SizedBox(
                      width: mq.width * .3,
                    ),
                    InkWell(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
// Pick an image.
                          final XFile? image = await picker.pickImage(source: ImageSource.camera);
                          if (image != null) {
                            setState(() {
                              _image = image.path;
                            });
                            Apis.updateGroupImage(File(_image!));
                            setState(() {});
                            Navigator.pop(context);
                          }
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: Colors.teal,
                            ),
                            Text("Camera")
                          ],
                        ))
                  ],
                ),
              )
            ],
          );
        });
  }

  void _showAlertDialog(BuildContext context, String name, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () {
                      _deleteParticipant(context, name, id);
                      // Navigator.pop(context);
                    },
                    child: Text(
                      "Remove Participant",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    )),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                    onTap: () {
                      Apis.groupAdmin(context, id);
                    },
                    child: Text(
                      "Make group admin",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ))
              ],
            ),
          ),
          // content: Text(email.toString()),
          // actions: [
          //   Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       InkWell(
          //           onTap: () {
          //             _deleteParticipant(context, name, id);
          //           },
          //           child: Text("Remove Participant")),
          //       InkWell(
          //           onTap: () {
          //             Apis.groupAdmin(context, id);
          //           },
          //           child: Text("Make group admin"))
          //     ],
          //   ),
          // ],
        );
      },
    );
  }

  void participantBottomSheet(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "only admin can add participants",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black38),
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Ok",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ))
              ],
            ),
          ),
          // content: Text(email.toString()),
          // actions: [
          //   Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       InkWell(
          //           onTap: () {
          //             _deleteParticipant(context, name, id);
          //           },
          //           child: Text("Remove Participant")),
          //       InkWell(
          //           onTap: () {
          //             Apis.groupAdmin(context, id);
          //           },
          //           child: Text("Make group admin"))
          //     ],
          //   ),
          // ],
        );
      },
    );
  }

  void changeSubjectGroup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "only admin can change this subject",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black38),
                ),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Ok",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ))
              ],
            ),
          ),
          // content: Text(email.toString()),
          // actions: [
          //   Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       InkWell(
          //           onTap: () {
          //             _deleteParticipant(context, name, id);
          //           },
          //           child: Text("Remove Participant")),
          //       InkWell(
          //           onTap: () {
          //             Apis.groupAdmin(context, id);
          //           },
          //           child: Text("Make group admin"))
          //     ],
          //   ),
          // ],
        );
      },
    );
  }

  void _deleteParticipant(BuildContext context, String? email, String? id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('you want to remove this participant'),
          content: Text(email.toString()),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final data = fireStore.collection('chats').doc(id).get();

                    Apis.deleteParticipant(context, id.toString()).then((value) {
                      setState(() {});
                      Navigator.pop(context);
                    });
                  },
                  child: Text('Yes'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
