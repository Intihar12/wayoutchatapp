import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  static Future<void> updateUserProfile() async {
    await fireStore.collection('Users').doc(user.uid).update({'name': me.name, 'about': me.about});
  }

  static Future<void> isSelfInfo(BuildContext context) async {
    return fireStore.collection('Users').doc(user.uid).get().then((value) async {
      if (value.exists) {
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

  static Future<void> createUser() async {
    final time = DateTime.now();
    final chatUserModal = ChatUserModal(
      id: user.uid,
      email: user.email,
      pushToken: "",
      lastActive: time,
      image: user.photoURL,
      createAt: time,
      isOnline: false,
      name: user.displayName,
      about: "He, i am using we chat",
    );
    return await fireStore.collection('Users').doc(user.uid).set(chatUserModal.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return fireStore.collection('Users').where("id", isNotEqualTo: user.uid).snapshots();
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

  static String getConversationId(String id) =>
      user.uid.hashCode <= id.hashCode ? "${user.uid}_$id" : "${id}_${user.uid}";

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(ChatUserModal user) {
    print("user id is: " + user.id.toString());
    return fireStore
        .collection('chats/${getConversationId(user.id.toString())}/messages/')
        .orderBy("createAt", descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(ChatUserModal chatUserModal) {
    return fireStore.collection('Users').where("id", isEqualTo: chatUserModal.id).snapshots();
  }

  static Future<void> updateActiveUserStatus(bool isOnline) async {
    fireStore.collection('Users').doc(user.uid).update({
      "isOnline": isOnline,
      "lastActive": DateTime.now(),
      "pushToken": me.pushToken,
    });
  }

  static Future<void> sendMessage(ChatUserModal chatUser, String msg, Type type) async {
    final time = DateTime.now();
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
    );

    Map<String, dynamic> temp = messagesModal.toJson();
    //temp["id"] = docId.id;
    //temp["createAt"] = time;
    await ref
        .doc(docId.id)
        .set(temp)
        .then((value) => sendPushNotification(chatUser, type == Type.text ? msg : "Image"));
  }

  static Future<void> updateMessageReadStatus(MessagesModal message) async {
    fireStore
        .collection('chats/${getConversationId(message.fromId.toString())}/messages/')
        .doc(message.id)
        .update({"read": DateTime.now()});
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

    await sendMessage(chatUserModal, imgUrl, Type.image);
  }

  static Future<void> deleteMessage(MessagesModal message) async {
    await fireStore
        .collection('chats/${getConversationId(message.toId.toString())}/messages/')
        .doc(message.id)
        .delete();

    if (message.type == Type.image) {
      await storage.refFromURL(message.msg.toString()).delete();
    }
  }
}
