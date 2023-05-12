import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../modals/chat_user_modal.dart';

class Apis {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
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
}
