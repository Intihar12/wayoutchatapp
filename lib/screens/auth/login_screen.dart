import 'package:wayoutchatapp/barrel.dart';

class LoginHomeScreen extends StatefulWidget {
  const LoginHomeScreen({Key? key}) : super(key: key);

  @override
  State<LoginHomeScreen> createState() => _LoginHomeScreenState();
}

class _LoginHomeScreenState extends State<LoginHomeScreen> {
  bool isAnimate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("login screen is");
    // Future.delayed(Duration(seconds: 4), () async {
    //   await Apis.initDynamicLinks(context);
    // });
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        isAnimate = true;
      });
    });
  }

  googleLoginButtonLick() {
    Dialogs.showProgressBar(context);
    signInWithGoogle().then((user) async => {
          Navigator.pop(context),
          if (user != null)
            {
              if ((await Apis.isUserExist()))
                {
                  print('/user : ${user.user}'),
                  print('/ user info : ${user.additionalUserInfo}'),
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()))
                }
              else
                {
                  await Apis.createUser().then(
                      (value) => {Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()))})
                }
            }
        });
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await Apis.auth.signInWithCredential(credential);
    } catch (e) {
      print("signInWithGoogle : ${e}");
      Dialogs.showSnackBar(context, "Network error");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Welcome to We chat"),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
              top: mq.height * .15,
              right: isAnimate ? mq.width * .25 : -mq.width * .5,
              width: mq.width * .5,
              duration: Duration(seconds: 1),
              child: Icon(Icons.markunread_outlined)),
          Positioned(
              bottom: mq.height * .15,
              left: mq.width * .05,
              width: mq.width * .9,
              height: mq.height * .07,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 219, 255, 178), shape: StadiumBorder()),
                onPressed: () {
                  googleLoginButtonLick();
                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
                },
                icon: Image.asset(
                  "assets/images/googleIcon.png",
                  height: mq.height * .03,
                ),
                label: Text(
                  "Sign with google",
                  style: TextStyle(color: Colors.black),
                ),
              ))
        ],
      ),
    );
  }
}
