import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayoutchatapp/main.dart';
import 'package:wayoutchatapp/screens/card_groop_screen.dart';

import '../api/apis.dart';
import '../modals/chat_user_modal.dart';
import '../widgets/cart_chat_user.dart';
import '../widgets/dialods/profile_dialog.dart';

class GroupScreenData extends StatefulWidget {
  const GroupScreenData({Key? key}) : super(key: key);

  @override
  State<GroupScreenData> createState() => _GroupScreenDataState();
}

class _GroupScreenDataState extends State<GroupScreenData> {
  TextEditingController groupNameController = TextEditingController();
  List<ChatUserModal> list = [];
  final List<ChatUserModal> searchList = [];
  bool isSearch = false;
  List<ChatUserModal> gropuLists = [];
  String? _image;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Apis.gropuList.isEmpty
          ? SizedBox()
          : Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: FloatingActionButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    _image == null
                        ? Apis.createGroup(groupNameController.text, "")
                        : Apis.createGroupImage(groupNameController.text, File(_image!));
                    print("buguuu");
                    //Apis.saveMembers(Apis.members);
                    // Apis.createUserff();
                    Navigator.pop(context);
                    print("daban bugu");
                  }
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
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    showBottomSheet();
                  },
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(mq.height * .1),
                          child: Image.file(
                            File(_image!),
                            width: mq.width * .2,
                            height: mq.width * .2,
                            //  height: mq.height * 0.3,
                            fit: BoxFit.fill,
                          ),
                        )
                      : Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white70,
                          ),
                        ),
                ),
                SizedBox(
                    width: 190,
                    child: Form(
                      key: formKey,
                      child: TextFormField(
                        controller: groupNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter group name";
                          }
                        },
                      ),
                    )),
                SizedBox(
                  width: 30,
                )
              ],
            ),
            SizedBox(
              height: 45,
            ),
            Container(
              color: Colors.white70,
              padding: EdgeInsets.only(left: 15),
              height: 100,
              child: ListView.builder(
                  itemCount: Apis.gropuList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    print("list length");
                    print(Apis.gropuList.length);
                    return Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(mq.height * .3),
                            child: CachedNetworkImage(
                              width: mq.width * .15,
                              // height: mq.height * .055,
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
          ],
        ),
      ),
    );
  }

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
                            //  Apis.updateProfileImage(File(_image!));

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
                            // Apis.updateProfileImage(File(_image!));
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
}
