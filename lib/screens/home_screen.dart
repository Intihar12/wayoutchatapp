import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:provider/provider.dart';
import 'package:wayoutchatapp/barrel.dart';
import 'package:wayoutchatapp/provider/provider.dart';
import 'package:wayoutchatapp/screens/voice_call_screen.dart';

import '../modals/call.dart';
import '../modals/chat_user_modal.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, this.receivedAction}) : super(key: key);
  final ReceivedAction? receivedAction;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserModal> list = [];
  List<ChatUserModal> listGroupData = [];
  final List<UserModal> searchList = [];
  bool isSearch = false;

  ConnectivityResult? _connectivityResult;
  Timer? _timer;

// intuu hussain
  //
  // void _startConnectivityCheck() async {
  //   // _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
  //   ConnectivityResult result = await Connectivity().checkConnectivity();
  //   setState(() {
  //     _connectivityResult = result;
  //   });
  //   Apis.updateConnectivityActiveUserStatus(result);
  //   // }
  //   //);
  // }
  // final themeChanger = Provider.of<ThemeProvider>(context);
  handleNotification() {
    print("handleNotification in chate screen");
    if (widget.receivedAction != null) {
      Map userMap = widget.receivedAction!.payload!;
      print("userMap[" "]");
      print(userMap["name"]);
      UserModal user =
          UserModal(id: userMap['user'], name: userMap['name'], image: userMap['photo'], email: userMap['email']);
      CallModel call = CallModel(
        id: userMap['id'],
        channel: userMap['channel'],
        caller: userMap['caller'],
        called: userMap['called'],
        active: jsonDecode(userMap['active']),
        accepted: true,
        rejected: jsonDecode(userMap['rejected']),
        connected: true,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return VideoPage(call: call, user: user);
          },
        ),
      );
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ThemeProvider>(context, listen: false).getTheme();
    });
    // Provider.of<ThemeProvider>(context, listen: false).getTheme();

    Apis.isSelfInfo(context);
    super.initState();

    Future.delayed(const Duration(milliseconds: 1000)).then(
      (value) {
        handleNotification();
      },
    );
    Future.delayed(Duration(seconds: 2), () async {
      await Apis.initDynamicLinks(context);
    });
    Apis.checkNetConnectivity();
    Apis.getMyUsersIds();
    //Apis.initDynamicLinks(context);
    // _startConnectivityCheck();
    // Apis.checkNetConnectivity();
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (Apis.auth.currentUser != null) {
        if (message.toString().contains('resume')) Apis.updateActiveUserStatus(true);
        if (message.toString().contains('pause')) Apis.updateActiveUserStatus(false);
      }
      return Future.value(message);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List listOfUsers = [];

  @override
  Widget build(BuildContext context) {
    //Apis.initDynamicLinks(context);
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
          onWillPop: () {
            if (isSearch) {
              setState(() {
                isSearch = !isSearch;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: FloatingActionButton(
                  onPressed: () async {
                    // print("buguuu");
                    // //Apis.saveMembers(Apis.members);
                    // // Apis.createUserff();
                    // print("daban bugu");
                    addUserDialog();
                  },
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.add_comment),
                ),
              ),
              appBar: AppBar(
                leading: Icon(Icons.home_outlined),
                title: isSearch
                    ? TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Name,email...",
                        ),
                        autofocus: true,
                        style: TextStyle(fontSize: 17, letterSpacing: 0.5),
                        onChanged: (value) {
                          searchList.clear();

                          for (var i in list) {
                            if (i.name!.toLowerCase().contains(value.toLowerCase()) ||
                                i.email!.toLowerCase().contains(value.toLowerCase())) {
                              searchList.add(i);
                            }
                            setState(() {
                              searchList;
                            });
                          }
                        },
                      )
                    : Text("We chat"),
                actions: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          isSearch = !isSearch;
                        });
                      },
                      icon: Icon(isSearch ? Icons.clear : Icons.search)),
                  // IconButton(
                  //     onPressed: () {
                  //       // Navigator.push(
                  //       //     context,
                  //       //     MaterialPageRoute(
                  //       //         builder: (_) => AudioWave(
                  //       //                message:  ,
                  //       //             )));
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (_) => ProfileScreen(
                  //                     user: Apis.me,
                  //                   )));
                  //     },
                  //     icon: Icon(Icons.more_vert)),

                  // todo popupmenue

                  PopupMenuButton<int>(
                    icon: Icon(
                      Icons.more_vert,
                      // color: Colors.black,
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
                              "Profile",
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
                              "New Group",
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
                        Apis.creatGroupDynamicLink();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ProfileScreen(
                                      user: Apis.me!,
                                    )));
                        // deleteSupplierBottomSheet(context);
                        //controller.buttonLoading.value = true;
                        // _showDialog(context);
                        // if value 2 show dialog
                      } else if (value == 2) {
                        //  controller.buttonLoading.value = true;
                        Navigator.push(context, MaterialPageRoute(builder: (_) => GroupScreen()));
                        //UpdateSupplierBottomSheet(context);
                        // _showDialog(context);
                      }
                    },
                  ),
                ],
              ),
              body: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .orderBy("latestActive", descending: true)
                      .where("users", arrayContains: Apis.user.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    final data = snapshot.data?.docs;
                    listGroupData =
                        data?.map((e) => ChatUserModal.fromJson(e.data() as Map<String, dynamic>)).toList() ?? [];
                    // print("listGroupData");
                    // print(listGroupData);
                    // print(listGroupData.length);
                    //List getId = [];
                    // List getIds = [];
                    // print("data");
                    // print(data);
                    // data?.forEach((element) {
                    //   List getId = element['users'];
                    //   getId.forEach((entry) {
                    //     if (getIds.contains(entry)) {
                    //       //chatMessages.remove(entry);
                    //     } else {
                    //       getIds.add(entry);
                    //     }
                    //   });
                    // });
                    //
                    // if (getIds.contains(Apis.user.uid)) {
                    //   getIds.remove(Apis.user.uid);
                    // }
                    List? getIde = [];
                    listGroupData.forEach((element) {
                      if (element.isPrivate == true) {
                        List? getIdes = element.users;
                        getIdes?.forEach((entry) {
                          if (getIde.contains(entry)) {
                            // getIde.add(entry);
                            //chatMessages.remove(entry);
                          } else {
                            getIde.add(entry);
                          }
                        });
                      }
                    });

                    if (getIde.contains(Apis.user.uid)) {
                      getIde.remove(Apis.user.uid);
                    }

                    print("streem");
                    // print("getIde");
                    // print(getIde);
                    // print("getIds");
                    //   print(getIds);

                    return FutureBuilder(
                        future: Apis.getAllGroupUsers(getIde),
                        builder: (contexts, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                            case ConnectionState.none:
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            case ConnectionState.active:
                            case ConnectionState.done:
                              final data = snapshot.data;
                              //
                              list = data?.map((e) => UserModal.fromJson(e.data() as Map<String, dynamic>?)).toList() ??
                                  [];
                              print("future");

                              //   if (list.isNotEmpty) {
                              return ListView.builder(
                                  itemCount: isSearch ? searchList.length : listGroupData.length,
                                  padding: EdgeInsets.only(top: mq.height * .01),
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    // print("index");
                                    // print(index);
                                    // int indexs;

                                    int listIndex = 0;
                                    for (int i = 0; i <= index; i++) {
                                      if (listGroupData[i].isPrivate == true) {
                                        // print("before :${listIndex}");
                                        // int? hjhj;
                                        // hjhj++;
                                        listIndex++;
                                        //  print("after :${listIndex}");
                                      }
                                    }

                                    return listGroupData[index].isPrivate == false
                                        ? GroupCartChatUser(
                                            user: listGroupData[index],
                                          )
                                        : CartChatUser(
                                            user: isSearch ? searchList[index] : list[listIndex - 1],
                                          );
                                  });
                          }
                          // else {
                          //   return Center(child: Text("No connection is found"));
                          // }
                          // }
                        });
                  })),
        ));
  }

  void addUserDialog() {
    String email = "";
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Icon(
                    Icons.person_add,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text("  Add user"),
                ],
              ),
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                  hintText: "Email id",
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.blue,
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "cancel",
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    if (email.isNotEmpty) {
                      // print("email");
                      // print(email);
                      await Apis.addChatUser(email, DateTime.now()).then((value) {
                        // print(value);
                        // print("value");
                        if (!value) {
                          Dialogs.showSnackBar(context, "User not exist");
                        }
                      }).whenComplete(() {
                        Apis.getMyUsersIds();
                        Navigator.pop(context);
                        setState(() {});
                      });
                    }
                    setState(() {});
                  },
                  child: Text(
                    "Add",
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                )
              ],
            ));
  }
}
