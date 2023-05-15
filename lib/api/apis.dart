import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wayoutchatapp/modals/messages_modal.dart';

import '../modals/chat_user_modal.dart';

class Apis {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static late ChatUserModal me;
  static User get user => auth.currentUser!;
  static Future<bool> isUserExist() async {
    return (await fireStore.collection('Users').doc(user.uid).get()).exists;
  }

  static Future<void> updateUserProfile() async {
    await fireStore.collection('Users').doc(user.uid).update({'name': me.name, 'about': me.about});
  }

  static Future<void> isSelfInfo() async {
    return fireStore.collection('Users').doc(user.uid).get().then((value) async {
      if (value.exists) {
        me = ChatUserModal.fromJson(value.data());
      } else {
        await createUser().then((value) => isSelfInfo());
      }
    });
  }

  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
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

    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((p0) => {print("data transfer ${p0.bytesTransferred / 100} kb")});

    me.image = await ref.getDownloadURL();

    await fireStore.collection("Users").doc(user.uid).update({"image": me.image});
  }

  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode ? "${user.uid}_$id" : "${id}_${user.uid}";

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(ChatUserModal user) {
    print("user id is: " + user.id.toString());
    return fireStore.collection('chats/${getConversationId(user.id.toString())}/messages/').snapshots();
  }

  static Future<void> sendMessage(ChatUserModal chatUser, String msg) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final MessagesModal messagesModal = MessagesModal(toId: chatUser.id, msg: msg, type: Type.text, fromId: user.uid, sent: time, read: '');
    final ref = fireStore.collection('chats/${getConversationId(chatUser.id.toString())}/messages/');
    DocumentReference docId = fireStore.collection("chats").doc(ref.id).collection("messages").doc();
    Map<String, dynamic> temp = messagesModal.toJson();
    temp["id"] = docId.id;
    await ref.doc(docId.id).set(temp);
  }
}
