import 'package:wayoutchatapp/barrel.dart';

class ViewProfileScreen extends StatefulWidget {
  ViewProfileScreen({Key? key, required this.user})
      : super(
          key: key,
        );
  UserModal user;

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  final formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Joined on: ",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Text(
              MyDateUtils.getLastMessageTime(context: context, lastTime: widget.user.createAt, showYer: true),
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        appBar: AppBar(
          // automaticallyImplyLeading: false,

          title: Text(widget.user.name!),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .02),
            child: Column(
              children: [
                SizedBox(
                  height: mq.height * .02,
                ),
                Center(
                  child: ClipRRect(
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
                ),
                SizedBox(
                  height: mq.height * .02,
                ),
                Text(
                  widget.user.email.toString(),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(
                  height: mq.height * .02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "About: ",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    Text(
                      widget.user.about.toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
