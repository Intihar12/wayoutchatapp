import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayoutchatapp/modals/chat_user_modal.dart';
import 'package:wayoutchatapp/screens/auth/login_screen.dart';

import '../api/apis.dart';
import '../api/apis.dart';
import '../diologs/diologs_screen.dart';
import '../main.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key, required this.user})
      : super(
          key: key,
        );
  ChatUserModal user;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formKey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: FloatingActionButton.extended(
            onPressed: () async {
              await Apis.auth.signOut().then((value) async => {
                    await GoogleSignIn().signOut().then((value) => {
                          Navigator.pop(context),
                          Navigator.pop(context),
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginHomeScreen()))
                        })
                  });
            },
            icon: Icon(Icons.logout),
            label: Text("Log out"),
          ),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Profile Screen"),
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .02),
              child: Column(
                children: [
                  SizedBox(
                    height: mq.height * .02,
                  ),
                  Center(
                    child: Stack(
                      children: [
                        _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(mq.height * .1),
                                child: Image.file(
                                  File(_image!),
                                  width: mq.width * .3,
                                  // height: mq.height * .2,
                                  fit: BoxFit.fill,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(mq.height * .1),
                                child: CachedNetworkImage(
                                  width: mq.width * .3,
                                  // height: mq.height * .2,
                                  fit: BoxFit.fill,
                                  imageUrl: widget.user.image!,
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                              ),
                        Positioned(
                          right: -15,
                          bottom: -10,
                          child: MaterialButton(
                            elevation: 1,
                            onPressed: () {
                              showBottomSheet();
                            },
                            shape: CircleBorder(),
                            color: Colors.white,
                            child: Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: mq.height * .02,
                  ),
                  Text(widget.user.email.toString()),
                  SizedBox(
                    height: mq.height * .02,
                  ),
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => Apis.me.name = val ?? '',
                    validator: (val) => val != null && val.isNotEmpty ? null : "required field",
                    decoration: InputDecoration(
                        prefix: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(),
                        hintText: "eg, Happy Singh",
                        label: Text("Name")),
                  ),
                  SizedBox(
                    height: mq.height * .02,
                  ),
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => Apis.me.about = val ?? '',
                    validator: (val) => val != null && val.isNotEmpty ? null : "required field",
                    decoration: InputDecoration(
                        prefix: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(),
                        hintText: "eg, Happy Singh",
                        label: Text("About")),
                  ),
                  SizedBox(
                    height: mq.height * .02,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        Apis.updateUserProfile().then((value) => {Dialogs.showSnackBar(context, "Update successfully")});
                      }
                    },
                    style: ElevatedButton.styleFrom(shape: StadiumBorder(), minimumSize: Size(mq.width * 0.6, mq.height * .05)),
                    icon: Icon(Icons.edit),
                    label: Text("Update"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05, left: mq.width * .05),
            children: [
              Text("Pick profile pictuer"),
              SizedBox(
                height: mq.height * .07,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
// Pick an image.
                          final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              _image = image.path;
                            });
                            Apis.updateProfileImage(File(_image!));

                            Navigator.pop(context);
                          }
                        },
                        child: Icon(Icons.browse_gallery)),
                    SizedBox(
                      width: mq.width * .07,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
// Pick an image.
                          final XFile? image = await picker.pickImage(source: ImageSource.camera);
                          if (image != null) {
                            setState(() {
                              _image = image.path;
                            });
                            Apis.updateProfileImage(File(_image!));
                            Navigator.pop(context);
                          }
                        },
                        child: Icon(Icons.camera_alt))
                  ],
                ),
              )
            ],
          );
        });
  }
}
