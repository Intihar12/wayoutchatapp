import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayoutchatapp/api/apis.dart';
import 'package:wayoutchatapp/screens/addparticipant_aftercreating_group.dart';
import 'package:wayoutchatapp/screens/update_group_name_screen.dart';

import '../main.dart';
import '../modals/chat_user_modal.dart';

class GroupInfoScreen extends StatefulWidget {
  GroupInfoScreen({Key? key, required this.groupData}) : super(key: key);
  ChatUserModal groupData;

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: Apis.getUserInfo(widget.groupData),
      builder: (context, snapshot) {
        final data = snapshot.data!.docs;

        final list = data.map((e) => ChatUserModal.fromJson(e.data())).toList();
        return Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
          child: Column(
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
                      showBottomSheet();
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
                        Navigator.push(context, MaterialPageRoute(builder: (_) => AddParticipantAfterGroupScreen()));
                      } else if (value == 2) {
                        //  controller.buttonLoading.value = true;
                        Navigator.push(context, MaterialPageRoute(builder: (_) => UpdateGroupName()));
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
              Text(
                list[0].name.toString(),
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        );
      },
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
}
