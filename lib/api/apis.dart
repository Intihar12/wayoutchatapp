import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:wayoutchatapp/modals/messages_modal.dart';

import '../modals/chat_user_modal.dart';
import '../screens/notification_services.dart';

class Apis {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static late ChatUserModal me;

  static List<ChatUserModal> gropuList = [];

  //static List gropuList = [];
  static List gropuListIds = [];
  static var isgroup;
  static String? id;

  static User get user => auth.currentUser!;
  static FirebaseMessaging fmMessaging = FirebaseMessaging.instance;

  static Future<void> getFirebaseMessagingToken() async {
    await fmMessaging.requestPermission();
    await fmMessaging.getToken().then((value) {
      if (value != null) {
        me.pushToken = value;
        print("token: " + value);
      }
    });
    // FirebaseMessaging.onMessage.listen((message) {
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification!.android;
    //   print("android!.channelId.toString()");
    //
    //   print(android!.channelId.toString());
    //   print(android);
    // });
  }

  static Future<void> sendPushNotification(ChatUserModal chatUserModal, String msg) async {
    //var url = Uri.https('example.com', 'whatsit/create');
    try {
      final body = {
        "to": chatUserModal.pushToken,
        "notification": {
          "title": me.name, //our name should be send
          "body": msg,
          "android_channel_id": "intuu"
        },
        // "data": {
        //   "some_data": "User ID: ${me.id}",
        // },
      };
      var response = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAAzy5TOSI:APA91bEONCfx9ojXirLC6E0tRlNxj4fvrWiJj-ZFfNENFyjE-55WJYq5B1yMUTYetGesV4q3mVO8873opQriHlv2lipPN-FnmcPW4Bc4h9lvdJI46gmyJ0CIUe_59MS8E9pdpmRQ9voe'
          },
          body: jsonEncode(body));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      print("getPushNotification" + e.toString());
    }
  }

  static Future<bool> isUserExist() async {
    return (await fireStore.collection('Users').doc(user.uid).get()).exists;
  }

  static Future<bool> addChatUser(String email) async {
    final data = await fireStore.collection('Users').where("email", isEqualTo: email.toLowerCase()).get();
    print("data");
    print(data.docs);
    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      //List intuu = [data.docs.first.id, user.uid];
      fireStore.collection("Users").doc(user.uid).collection("my_users").doc(data.docs.first.id).set({});
      // fireStore.collection("chats").doc(getConversationId(data.docs.first.id)).set({"users": intuu});
      return true;
    } else {
      return false;
    }
  }

// todo
  static Future<void> addGroupUserList(List ids) async {
    print("this is id");
    print(ids);
    QuerySnapshot data = await fireStore.collection('Users').where("id", whereIn: ids.isEmpty ? [''] : ids).get();
    print("data");
    print(data.docs);
    gropuList.clear();
    for (var drvList in data.docs) {
      Map<String, dynamic>? map = drvList.data() as Map<String, dynamic>?;

      ChatUserModal modal = ChatUserModal.fromJson(map);
      gropuList.add(modal);
      print("this is group list");
      print(gropuList);

      //driverList = seracgDriverList;
    }
  }

  static Future<void> updateUserProfile() async {
    await fireStore.collection('Users').doc(user.uid).update({'name': me.name, 'about': me.about});
  }

  static Future<void> isSelfInfo(BuildContext context) async {
    return fireStore.collection('Users').doc(user.uid).get().then((value) async {
      if (value.exists) {
        print("klklk");
        me = ChatUserModal.fromJson(value.data());
        await getFirebaseMessagingToken();
        Apis.updateActiveUserStatus(true);
        NotificationServices().requestNotificationPermission();
        NotificationServices().forgroundMessage();
        NotificationServices().firebaseInit(context);
        NotificationServices().setupInteractMessage(context);
        NotificationServices().isTokenRefresh();
      } else {
        await createUser().then((value) => isSelfInfo(context));
      }
    });
  }

  // static Future<void> createchatUser(ChatUserModal users) async {
  //   print("emailll");
  //   print(me.email);
  //   final time = DateTime.now();
  //   final chatUserModal = UserModal(
  //     chatUserList: [
  //       ChatUserModal(
  //           email: me.email,
  //           about: me.about,
  //           createAt: me.createAt,
  //           id: me.id,
  //           image: me.image,
  //           isOnline: me.isOnline,
  //           lastActive: me.lastActive,
  //           name: me.name,
  //           pushToken: me.pushToken)
  //     ],
  //   );
  //
  //   Map<String, dynamic> privates = chatUserModal.toJson();
  //
  //   return await fireStore.collection('Usersuiu').doc(getConversationId(users.id.toString())).set(privates);
  // }
  //
  // static Future<void> createUserff(ChatUserModal users) async {
  //   final time = DateTime.now();
  //   final chatUserModal = UserModal(
  //     chatUserList: [
  //       ChatUserModal(
  //           email: users.email,
  //           about: users.about,
  //           createAt: users.createAt,
  //           id: users.id,
  //           image: users.image,
  //           isOnline: users.isOnline,
  //           lastActive: users.lastActive,
  //           name: users.name,
  //           pushToken: users.pushToken)
  //     ],
  //   );
  //   final chatUser = UserModal(
  //     chatUserList: [
  //       ChatUserModal(
  //           email: me.email,
  //           about: me.about,
  //           createAt: me.createAt,
  //           id: me.id,
  //           image: me.image,
  //           isOnline: me.isOnline,
  //           lastActive: me.lastActive,
  //           name: me.name,
  //           pushToken: me.pushToken)
  //     ],
  //   );
  //
  //   Map<String, dynamic> privates = chatUserModal.toJson();
  //   Map<String, dynamic> privatess = chatUser.toJson();
  //
  //   return await fireStore.collection('Usersuiu').doc(user.uid).set(privates);
  //   // return await fireStore.collection('Usersuiu').doc(user.uid).update({
  //   //   "chatUserList": FieldValue.arrayUnion([privates])
  //   // });
  // }

  static Future<void> createUser() async {
    final time = DateTime.now();
    final chatUserModal = ChatUserModal(
        id: user.uid,
        email: user.email,
        pushToken: "",
        lastActive: time,
        image: user.photoURL,
        createAt: time,
        name: user.displayName,
        about: "Hi, i am using we chat",
        isGroup: false);

    return await fireStore.collection('Users').doc(user.uid).set(chatUserModal.toJson());
  }

// todo create groupuser

  static Future<void> createGroup(String? name, String? imageUrl) async {
    print("groupname");
    print(name);
    final docId = DateTime.now().millisecondsSinceEpoch.toString();
    final time = DateTime.now();
    final chatUserModal = ChatUserModal(
        id: docId,
        email: "",
        pushToken: "",
        lastActive: time,
        image: imageUrl ?? "",
        createAt: time,
        name: name,
        about: "Hi, i am using we chat",
        isGroup: true);

    return await fireStore.collection('Users').doc(docId).set(chatUserModal.toJson()).then((value) {
      //  fireStore.collection("Users").doc(docId).collection("my_users").doc(docId).set({"groupIds": gropuListIds});

      for (var list in gropuListIds) {
        fireStore.collection("Users").doc(docId).collection("my_users").doc(list).set({});
        fireStore.collection("Users").doc(list).collection("my_users").doc(docId).set({});
      }
    });
  }

  static Future<void> updateGroupName(
    BuildContext context,
    String? name,
  ) async {
    return await fireStore.collection('Users').doc(id).update({"name": name}).then((value) {
      Navigator.pop(context);
    });
  }

  static Future<void> addOtherParticipants(BuildContext context, String id) async {
    //return await fireStore.collection('Users').doc(id).collection('my_users').doc().then((value) {
    //  fireStore.collection("Users").doc(docId).collection("my_users").doc(docId).set({"groupIds": gropuListIds});

    for (var list in gropuListIds) {
      fireStore.collection("Users").doc(id).collection("my_users").doc(list).set({});
      fireStore.collection("Users").doc(list).collection("my_users").doc(id).set({});
    }
    Navigator.pop(context);
  }

  // todo create group with img

  static Future<void> createGroupImage(String? name, File file) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final ext = file.path.split('.').last;

    final ref = storage.ref().child('images/${time}.${DateTime.now().millisecondsSinceEpoch.toString()}.$ext');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) => {print("data transfer ${p0.bytesTransferred / 100} kb")});
    final imgUrl = await ref.getDownloadURL();
    print("imgurl");
    print(imgUrl);

    await createGroup(name, imgUrl);
  }

  // todo test
  //static List<String> members = ["abc", "asd"];
  // static List<Map<String, dynamic>> members = [
  //   {"name": "intuu", "id": 23},
  //   {"name": "ali", "id": 2},
  //   {"name": "abc", "id": 21}
  // ];
  //
  // static Future<void> saveMembers(List<Map<String, dynamic>> members) async {
  //   // final Map<String, dynamic> membersMap = {};
  //   //
  //   // for (int i = 0; i < members.length; i++) {
  //   //   membersMap['member$i'] = members[i];
  //   // }
  //   await fireStore.collection('uiuiu').doc(user.uid).set({'items': members});
  // }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return fireStore.collection('Users').doc(user.uid).collection("my_users").snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyGroupId(String id) {
    return fireStore.collection('Users').doc(id).collection("my_users").snapshots();
  }

  // todo
  static Stream<QuerySnapshot<Map<String, dynamic>>> getListGroup(List id) {
    return fireStore.collection('Users').where("is", isEqualTo: id).snapshots();
  }

  static Future<void> sendFirstMessage(ChatUserModal chatUser, String msg, Type type) async {
    await fireStore.collection('Users').doc(chatUser.id).collection("my_users").doc(user.uid).set({}).then(
      (value) {
        sendMessage(chatUser, msg, type);
        // List ides = [chatUser.id, user.uid];
        //
        // fireStore.collection('chats').doc(getConversationId(user.uid)).set({"userss": ides});
      },
    );
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(List<String> usersId) {
    print("useridss ");
    print(usersId);
    return fireStore.collection('Users').where('id', whereIn: usersId.isEmpty ? [''] : usersId).snapshots();
  }

  // todo getAll users fpr group

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsersForGroup(List<String> usersId) {
    print("useridss ");
    print(usersId);
    return fireStore
        .collection('Users')
        .where('id', whereIn: usersId.isEmpty ? [''] : usersId)
        .where('isGroup', isEqualTo: false)
        .snapshots();
  }

  static Future<void> updateProfileImage(File file) async {
    final ext = file.path.split('.').last;

    final ref = storage.ref().child('profiles_pictures/${user.uid}.$ext');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) => {print("data transfer ${p0.bytesTransferred / 100} kb")});

    me.image = await ref.getDownloadURL();

    await fireStore.collection("Users").doc(user.uid).update({"image": me.image});
  }

// todo update group image

  static Future<void> updateGroupImage(File file) async {
    final ext = file.path.split('.').last;

    final ref = storage.ref().child('profiles_pictures/${user.uid}.$ext');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) => {print("data transfer ${p0.bytesTransferred / 100} kb")});

    me.image = await ref.getDownloadURL();

    await fireStore.collection("Users").doc(id).update({"image": me.image});
  }

  static String getConversationId(String id) {
    print("user.uid.hashCode: " + user.uid.hashCode.toString());
    print("id.hashCode : " + id.hashCode.toString());
    return user.uid.hashCode <= id.hashCode ? "${user.uid}_$id" : "${id}_${user.uid}";
  }

  // todo getdata

  // static Stream<QuerySnapshot<Map<String, dynamic>>> getusersbyid(ChatUserModal user) {
  //   print("user id is: " + user.id.toString());
  //   return fireStore
  //       .collection('chats').where("")
  // }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(ChatUserModal user) {
    print("user id is: " + user.id.toString());

    return isgroup != true
        ? fireStore
            .collection('chats/${getConversationId(user.id.toString())}/messages/')
            .orderBy("createAt", descending: true)
            .snapshots()
        : fireStore.collection('chats/${user.id}/messages/').orderBy("createAt", descending: true).snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(ChatUserModal chatUserModal) {
    var data = fireStore.collection('Users').where("id", isEqualTo: chatUserModal.id).snapshots();
    print("this is user info home");
    print(data);
    return fireStore.collection('Users').where("id", isEqualTo: chatUserModal.id).snapshots();
  }

  // todo getgroup info

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserGroupInfo(String id) {
    print("the group ids");
    print(id);

    var data = fireStore.collection('Users').where("id", isEqualTo: id).snapshots();
    print("this is data");

    return fireStore.collection('Users').where("id", isEqualTo: id).snapshots();
  }

  static Future<void> updateActiveUserStatus(bool isOnline) async {
    print("this is true or fall");
    print(isOnline);
    fireStore.collection('Users').doc(user.uid).update({
      "isOnline": isOnline,
      "lastActive": DateTime.now(),
      "pushToken": me.pushToken,
    });
    print("else");
  }

  // static void updateConnectivityActiveUserStatus(ConnectivityResult result) async {
  //   print("this is true or fall");
  //   print(result);
  //   await fireStore.collection('Users').doc(user.uid).update({
  //     "isOnline": result == ConnectivityResult.none ? false : true,
  //     "lastActive": DateTime.now(),
  //     "pushToken": me.pushToken,
  //   });
  //   print("else");
  // }

  // todo send

  static Future<void> sendMessage(ChatUserModal chatUser, String msg, Type type) async {
    final time = DateTime.now();
    print("chate user id");
    print(chatUser.id);

    final ref = fireStore.collection('chats/${getConversationId(chatUser.id.toString())}/messages/');
    DocumentReference docId = fireStore.collection("chats").doc(ref.id).collection("messages").doc();

    final MessagesModal messagesModal = MessagesModal(
      toId: chatUser.id,
      msg: msg,
      type: type,
      fromId: user.uid,
      sent: time,
      createAt: time,
      id: docId.id,
      readAudio: false,
    );

    Map<String, dynamic> temp = messagesModal.toJson();
    //temp["id"] = docId.id;
    //temp["createAt"] = time;
    await ref.doc(docId.id).set(temp).then((value) {
      sendPushNotification(
          chatUser,
          type == Type.text
              ? type == Type.audio
                  ? msg
                  : "audio"
              : "Image");
    });
  }

  // todo gropumessage

  static Future<void> sendGroupMessage(ChatUserModal chatUser, String msg, Type type) async {
    print("chatUser.id");
    print(chatUser.id);
    final time = DateTime.now();
    final docgroupId = DateTime.now().millisecondsSinceEpoch.toString();
    print("chate user id");
    print(chatUser.id);

    final ref = fireStore.collection('chats/${chatUser.id}/messages/');
    DocumentReference docId = fireStore.collection("chats").doc(ref.id).collection("messages").doc();

    final MessagesModal messagesModal = MessagesModal(
      toId: chatUser.id,
      msg: msg,
      type: type,
      fromId: user.uid,
      sent: time,
      createAt: time,
      id: docId.id,
      readAudio: false,
    );

    Map<String, dynamic> temp = messagesModal.toJson();
    //temp["id"] = docId.id;
    //temp["createAt"] = time;
    await ref.doc(docId.id).set(temp).then((value) {
      sendPushNotification(
          chatUser,
          type == Type.text
              ? type == Type.audio
                  ? msg
                  : "audio"
              : "Image");
    });
  }

  static Future<void> updateMessageReadStatus(MessagesModal message) async {
    fireStore
        .collection('chats/${getConversationId(message.fromId.toString())}/messages/')
        .doc(message.id)
        .update({"read": DateTime.now()});
  }

  static Future<void> updateAudioMessageReadStatus(MessagesModal message) async {
    fireStore
        .collection('chats/${getConversationId(message.fromId.toString())}/messages/')
        .doc(message.id)
        .update({"readAudio": true});
    print("messagesss: ");
    print(message.readAudio);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(ChatUserModal user) {
    return fireStore
        .collection('chats/${getConversationId(user.id.toString())}/messages/')
        .orderBy("createAt", descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> setChateImage(ChatUserModal chatUserModal, File file) async {
    final ext = file.path.split('.').last;

    final ref = storage.ref().child(
        'images/${getConversationId(chatUserModal.id.toString())}.${DateTime.now().millisecondsSinceEpoch.toString()}.$ext');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) => {print("data transfer ${p0.bytesTransferred / 100} kb")});
    final imgUrl = await ref.getDownloadURL();
    print("imgurl");
    print(imgUrl);

    await sendMessage(chatUserModal, imgUrl, Type.image);
  }

// todo send image

  static Future<void> setChateImageInGroup(ChatUserModal chatUserModal, File file) async {
    final ext = file.path.split('.').last;

    final ref =
        storage.ref().child('images/${chatUserModal.id}.${DateTime.now().millisecondsSinceEpoch.toString()}.$ext');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) => {print("data transfer ${p0.bytesTransferred / 100} kb")});
    final imgUrl = await ref.getDownloadURL();
    print("imgurl");
    print(imgUrl);

    await sendGroupMessage(chatUserModal, imgUrl, Type.image);
  }

  // todo
  static Future<void> deleteMessage(MessagesModal message) async {
    await fireStore
        .collection('chats/${getConversationId(message.toId.toString())}/messages/')
        .doc(message.id)
        .delete();

    if (message.type == Type.image) {
      await storage.refFromURL(message.msg.toString()).delete();
    }
  }

  static Future<void> updateMessage(MessagesModal message, String updateMessage) async {
    await fireStore
        .collection('chats/${getConversationId(message.toId.toString())}/messages/')
        .doc(message.id)
        .update({"msg": updateMessage});
  }

  static Future<void> uploadAudioFile(ChatUserModal chatUserModal, File audioFile) async {
    // Generate a unique filename for the audio file
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.wav';
    final ref = storage.ref().child(
        'audio/${getConversationId(chatUserModal.id.toString())}.${DateTime.now().millisecondsSinceEpoch.toString()}');

    // Upload the audio file to Firebase Storage
    //final ref = storage.ref().child('audio/$fileName');
    await ref.putFile(audioFile);

    // Get the download URL for the uploaded audio file
    final downloadUrl = await ref.getDownloadURL();
    await sendMessage(chatUserModal, downloadUrl, Type.audio);
  }

  // todo uploadAudio in group

  static Future<void> uploadAudioFileInGroup(ChatUserModal chatUserModal, File audioFile) async {
    // Generate a unique filename for the audio file
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.wav';
    final ref = storage.ref().child('audio/${chatUserModal.id}.${DateTime.now().millisecondsSinceEpoch.toString()}');

    // Upload the audio file to Firebase Storage
    //final ref = storage.ref().child('audio/$fileName');
    await ref.putFile(audioFile);

    // Get the download URL for the uploaded audio file
    final downloadUrl = await ref.getDownloadURL();
    await sendGroupMessage(chatUserModal, downloadUrl, Type.audio);
  }

  // todo connectivity
  static ConnectivityResult? connectivityResult;

  static Future<void> checkNetConnectivity() async {
    // final connectivityResult = await (Connectivity().checkConnectivity());
    await Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!

      connectivityResult = result;
      if (connectivityResult == ConnectivityResult.none) Apis.updateActiveUserStatus(false);
      if (connectivityResult != ConnectivityResult.none) Apis.updateActiveUserStatus(true);

      print("result wifi status intuu");

      // else {
      //   print("result wifi status true");
      //   Apis.updateActiveUserStatus(true);
      // }
    });
  }
}
