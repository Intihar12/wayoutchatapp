import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wayoutchatapp/screens/group_screen.dart';
import 'package:wayoutchatapp/screens/profile_screen.dart';

import '../api/apis.dart';
import '../diologs/diologs_screen.dart';
import '../main.dart';
import '../modals/chat_user_modal.dart';
import '../voice_chat/voice_chat.dart';
import '../widgets/cart_chat_user.dart';
import 'notification_services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUserModal> list = [];
  final List<ChatUserModal> searchList = [];
  bool isSearch = false;

  ConnectivityResult? _connectivityResult;
  Timer? _timer;

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

  @override
  void initState() {
    // TODO: implement initState
    Apis.isSelfInfo(context);
    super.initState();
    Apis.checkNetConnectivity();
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

  @override
  Widget build(BuildContext context) {
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
                  print("buguuu");
                  //Apis.saveMembers(Apis.members);
                  // Apis.createUserff();
                  print("daban bugu");
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen(
                                    user: Apis.me,
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
                    print("darta ::");
                    print(snapShot.data?.docs);
                    return StreamBuilder(
                        stream: Apis.getAllUsers(snapShot.data?.docs.map((e) => e.id).toList() ?? []),
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
                                return ListView.builder(
                                    itemCount: isSearch ? searchList.length : list.length,
                                    padding: EdgeInsets.only(top: mq.height * .01),
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return CartChatUser(
                                        user: isSearch ? searchList[index] : list[index],
                                      );
                                    });
                              } else {
                                return Center(child: Text("No connection is found"));
                              }
                          }
                        });
                }
              },
            ),
          )),
    );
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
                      print("email");
                      print(email);
                      await Apis.addChatUser(email).then((value) {
                        print(value);
                        print("value");
                        if (!value) {
                          Dialogs.showSnackBar(context, "User not exist");
                        }
                      });

                      Navigator.pop(context);
                    }
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
