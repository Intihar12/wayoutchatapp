import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wayoutchatapp/screens/profile_screen.dart';

import '../api/apis.dart';
import '../main.dart';
import '../modals/chat_user_modal.dart';
import '../widgets/cart_chat_user.dart';
import 'notification_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUserModal> list = [];
  final List<ChatUserModal> searchList = [];
  bool isSearch = false;

  @override
  void initState() {
    // TODO: implement initState
    Apis.isSelfInfo(context);
    super.initState();

    SystemChannels.lifecycle.setMessageHandler((message) {
      if (Apis.auth.currentUser != null) {
        if (message.toString().contains('resume')) Apis.updateActiveUserStatus(true);
        if (message.toString().contains('pause')) Apis.updateActiveUserStatus(false);
      }
      return Future.value(message);
    });
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
                  await Apis.auth.signOut();
                  await GoogleSignIn().signOut();
                },
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
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen(
                                    user: Apis.me,
                                  )));
                    },
                    icon: Icon(Icons.more_vert))
              ],
            ),
            body: StreamBuilder(
                stream: Apis.getAllUsers(),
                builder: (context, snapshot) {
                  print("intuu snapshot: ${snapshot}");
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
                        return Center(child: Text("No connce is found"));
                      }
                  }
                })),
      ),
    );
  }
}
