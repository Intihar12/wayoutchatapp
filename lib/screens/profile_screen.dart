import 'package:provider/provider.dart';
import 'package:wayoutchatapp/barrel.dart';

import '../provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key, required this.user}) : super(key: key);
  UserModal user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    // ThemeProvider themeChanger = Provider.of<ThemeProvider>(context, listen: false);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.teal,
            onPressed: () async {
              await Apis.updateActiveUserStatus(false);
              await Apis.auth.signOut().then((value) async => {
                    await GoogleSignIn().signOut().then((value) => {
                          Navigator.pop(context),
                          Navigator.pop(context),
                          Apis.auth = FirebaseAuth.instance,
                          Navigator.push(context, MaterialPageRoute(builder: (_) => LoginHomeScreen()))
                        })
                  });
            },
            icon: Icon(Icons.logout),
            label: Text("Log out"),
          ),
        ),
        appBar: AppBar(
          // automaticallyImplyLeading: false,
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
                                  height: mq.width * .3,
                                  fit: BoxFit.fill,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(mq.height * .1),
                                child: CachedNetworkImage(
                                  width: mq.width * .3,
                                  height: mq.width * .3,
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
                              color: Colors.teal,
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
                    onSaved: (val) => Apis.me?.name = val ?? '',
                    validator: (val) => val != null && val.isNotEmpty ? null : "required field",
                    decoration: InputDecoration(
                        prefix: Icon(
                          Icons.person,
                          color: Colors.teal,
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
                    onSaved: (val) => Apis.me?.about = val ?? '',
                    validator: (val) => val != null && val.isNotEmpty ? null : "required field",
                    decoration: InputDecoration(
                        prefix: Icon(
                          Icons.person,
                          color: Colors.teal,
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
                        Apis.updateUserProfile()
                            .then((value) => {Dialogs.showSnackBar(context, "Update successfully")});
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: StadiumBorder(),
                        minimumSize: Size(mq.width * 0.6, mq.height * .05)),
                    icon: Icon(Icons.edit),
                    label: Text(
                      "Update",
                    ),
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text(
                      "Light mode",
                      //style: TextStyle(color: themeChanger.themeMode == ThemeMode.dark ? Colors.white : Colors.black),
                    ),
                    value: ThemeMode.light,
                    groupValue: Provider.of<ThemeProvider>(context, listen: false).themeMode,
                    onChanged: (ThemeMode? value) {
                      Provider.of<ThemeProvider>(context, listen: false).setTheme(value!);
                    },
                    // Provider.of<ThemeProvider>(context, listen: false).setTheme(ThemeMode.light),
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text("Dark mode"),
                    value: ThemeMode.dark,
                    groupValue: Provider.of<ThemeProvider>(context, listen: false).themeMode,
                    onChanged: (ThemeMode? value) {
                      Provider.of<ThemeProvider>(context, listen: false).setTheme(value!);
                    },
                    // onChanged:()=> (context).read<ThemeProvider>().setTheme(ThemeMode.dark),
                    // Provider.of<ThemeProvider>(context, listen: false).setTheme(ThemeMode.dark)
                  ),
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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05, left: mq.width * .05),
            children: [
              Text(
                "Update profile pictuer",
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
                            Apis.updateProfileImage(File(_image!));

                            Navigator.pop(context);
                          }
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.panorama,
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
                            Apis.updateProfileImage(File(_image!));
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
