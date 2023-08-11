import 'package:wayoutchatapp/barrel.dart';

import '../modals/chat_user_modal.dart';
import '../screens/group_invite_sheet.dart';

class Apis {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static UserModal? me;

  static List<UserModal> gropuList = [];

  //static List gropuList = [];
  static List gropuListIds = [];
  static var isgroup;
  static String? id;
  static String? listId;
  static List usersId = [];

  static User get user => auth.currentUser!;
  static FirebaseMessaging fmMessaging = FirebaseMessaging.instance;

  static Future<void> getFirebaseMessagingToken() async {
    await fmMessaging.requestPermission();
    await fmMessaging.getToken().then((value) {
      if (value != null) {
        me?.pushToken = value;
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

  static Future<void> sendPushNotification(UserModal chatUserModal, String msg) async {
    //var url = Uri.https('example.com', 'whatsit/create');
    try {
      final body = {
        "to": chatUserModal.pushToken,
        "notification": {
          "title": me?.name, //our name should be send
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
    } catch (e) {}
  }

  static Future<bool> isUserExist() async {
    return (await fireStore.collection('Users').doc(user.uid).get()).exists;
  }

  static Future<bool> addChatUser(String email, DateTime latestActive) async {
    final data = await fireStore.collection('Users').where("email", isEqualTo: email.toLowerCase()).get();

    final time = DateTime.now();

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      List chatUsers = [data.docs.first.id, user.uid];

      final idCollectionModal = ChatUserModal(
        users: chatUsers,
        isPrivate: true,
        latestActive: latestActive ?? time,
      );

      // fireStore.collection("chats").doc(getConversationId(data.docs.first.id)).set(
      //     {"latestActive": latestActive ?? time, "isPrivate": true, "users": intuu, "firstId": data.docs.first.id});
      //
      fireStore.collection("chats").doc(getConversationId(data.docs.first.id)).set(idCollectionModal.toJson());
      return true;
    } else {
      return false;
    }
  }

// todo
  static Future<void> addGroupUserList(List ids) async {
    QuerySnapshot data = await fireStore.collection('Users').where("id", whereIn: ids.isEmpty ? [''] : ids).get();

    gropuList.clear();
    for (var drvList in data.docs) {
      Map<String, dynamic>? map = drvList.data() as Map<String, dynamic>?;

      UserModal modal = UserModal.fromJson(map);
      gropuList.add(modal);

      //driverList = seracgDriverList;
    }
  }

  static Future<void> updateUserProfile() async {
    await fireStore.collection('Users').doc(user.uid).update({'name': me?.name, 'about': me?.about});
  }

  static Future<void> isSelfInfo(BuildContext context) async {
    return fireStore.collection('Users').doc(user.uid).get().then((value) async {
      if (value.exists) {
        print("klklk");
        me = UserModal.fromJson(value.data());
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
    final chatUserModal = UserModal(
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

  static Future<void> createGroup(BuildContext context, String? name, String? imageUrl) async {
    final docId = DateTime.now().millisecondsSinceEpoch.toString();
    final time = DateTime.now();
    // final chatUserModal = UserModal(
    //     id: docId,
    //     email: "",
    //     pushToken: "",
    //     lastActive: time,
    //     image: imageUrl ?? "",
    //     createAt: time,
    //     name: name,
    //     about: "Hi, i am using we chat",
    //     isGroup: true);
    //
    // return await fireStore.collection('Users').doc(docId).set(chatUserModal.toJson()).then((value) {
    //  fireStore.collection("Users").doc(docId).collection("my_users").doc(docId).set({"groupIds": gropuListIds});
    //gropuListIds.add(docId);
    List listParticipantId = [];
    listParticipantId.add(user.uid);

    final idCollectionModal = ChatUserModal(
        groupName: name,
        image: imageUrl ?? "",
        latestActive: time,
        isPrivate: false,
        users: gropuListIds,
        adminIds: listParticipantId,
        groupId: docId);
    fireStore.collection("chats").doc(docId).set(idCollectionModal.toJson());
    // fireStore.collection("chats").doc(getConversationId(list)).set({"isPrivate": true, "users": list});
    //  Navigator.pop(context);
    // fireStore.collection("Users").doc(list).collection("my_users").doc(docId).set({});
    // }
  }

  static List groupParticipantsIds = [];
  static List getAdminIds = [];

  static Future<void> groupAdmin(BuildContext context, String? participantId) async {
    final time = DateTime.now();
    List listParticipantId = [];
    getAdminIds.add(participantId);
    final idCollectionModal = ChatUserModal(
        latestActive: time,
        adminIds: getAdminIds,
        isPrivate: false,
        users: groupParticipantsIds,
        image: groupImage,
        groupName: groupName,
        groupId: groupId);

    fireStore.collection("chats").doc(id).update(idCollectionModal.toJson());
    Navigator.pop(context);
  }

  static Future<void> addOtherParticipants(
    BuildContext context,
    String id,
  ) async {
    usersId.addAll(gropuListIds);
    final time = DateTime.now();
    List listParticipantId = [];
    final idCollectionModal = ChatUserModal(
      adminIds: getAdminIds,
      groupName: groupName,
      image: groupId,
      groupId: id,
      users: usersId,
      isPrivate: false,
      latestActive: time,
    );
    fireStore.collection("chats").doc(id).update(idCollectionModal.toJson());
    // fireStore.collection("Users").doc(list).collection("my_users").doc(id).set({});

    Navigator.pop(context);
  }

// todo group join by link
  static Future<void> groupJoinByLink(BuildContext context, String id, UserModal group) async {
    usersId.add(user.uid);
    final time = DateTime.now();
    final idCollectionModal =
        ChatUserModal(adminIds: getAdminIds, isPrivate: false, latestActive: time, users: usersId);
    fireStore.collection("chats").doc(id).update(idCollectionModal.toJson()).whenComplete(() {});
    // fireStore.collection("Users").doc(list).collection("my_users").doc(id).set({});
  }

  static Future<void> updateGroupName(
    BuildContext context,
    String? name,
  ) async {
    final time = DateTime.now();
    final idCollectionModal = ChatUserModal(
        adminIds: getAdminIds,
        groupName: name,
        image: groupId,
        groupId: id,
        users: usersId,
        isPrivate: false,
        latestActive: time);
    return fireStore.collection("chats").doc(id).update(idCollectionModal.toJson()).then((value) {
      Navigator.pop(context);
    });
    // return await fireStore.collection('Users').doc(id).update({"name": name}).then((value) {
    //   Navigator.pop(context);
    // });
  }

  // todo create group with img

  static Future<void> createGroupImage(BuildContext context, String? name, File file) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final ext = file.path.split('.').last;

    final ref = storage.ref().child('images/${time}.${DateTime.now().millisecondsSinceEpoch.toString()}.$ext');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) => {print("data transfer ${p0.bytesTransferred / 100} kb")});
    final imgUrl = await ref.getDownloadURL();

    await createGroup(context, name, imgUrl);
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

  // static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersIds() {
  //   // return fireStore.collection('Users').doc(user.uid).collection("my_users").snapshots();
  //   return fireStore.collection('chats').where("users", arrayContains: user.uid).get();
  // }
  static StreamController<List<String>> userIdsStreamController = StreamController<List<String>>();
  static List<String> usersIdSet = [];
  static List<String> usersIds = [];

  static getMyUsersIds() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('chats').where("users", arrayContains: user.uid).get();

      querySnapshot.docs.forEach((doc) {
        // Assuming the "users" field is an array of strings.
        List<String> users = List.from(doc.data()['users']);
        userIdsStreamController.add(users);
        usersIds.addAll(users);
      });

      return usersIds;
    } catch (e) {
      print("Error fetching user IDs: $e");
      return usersIds;
    }
  }

  // static Stream<QuerySnapshot<Map<String, dynamic>>> getMyGroupId(String id) {
  //   return fireStore.collection('Users').doc(id).collection("my_users").snapshots();
  // }
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyGroupId(String id) {
    return fireStore.collection('chats').doc(id).collection("my_users").snapshots();
  }

  // todo
  static Stream<QuerySnapshot<Map<String, dynamic>>> getListGroup(List id) {
    return fireStore.collection('Users').where("is", isEqualTo: id).snapshots();
  }

  static Future<void> sendFirstMessage(UserModal chatUser, String msg, Type type) async {
    await fireStore.collection('Users').doc(chatUser.id).collection("my_users").doc(user.uid).set({}).then(
      (value) {
        sendMessage(chatUser, msg, type);
        // List ides = [chatUser.id, user.uid];
        //
        // fireStore.collection('chats').doc(getConversationId(user.uid)).set({"userss": ides});
      },
    );
  }

  // static List<List<dynamic>> partition<T>(List<dynamic> list, int size) {
  //   List<List<dynamic>> result = [];
  //   for (var i = 0; i < list.length; i += size) {
  //     result.add(list.sublist(i, i + size > list.length ? list.length : i + size));
  //   }
  //   return result;
  // }

  static Future<List<DocumentSnapshot>> getAllUsers(String? usersId) async {
    List<DocumentSnapshot> data = [];
    // for (var chunk in chunks) {
    // for (var tempUser in usersId) {
    DocumentSnapshot<Map<String, dynamic>> doc;
    doc = await fireStore.collection('Users').doc(usersId).get();
    data.add(doc);
    //  }

    return data;
  }

  static Future<List<DocumentSnapshot>> getAllGroupUsers(List<dynamic> usersId) async {
    List<DocumentSnapshot> data = [];
    // for (var chunk in chunks) {
    for (var tempUser in usersId) {
      DocumentSnapshot<Map<String, dynamic>> doc;
      doc = await fireStore.collection('Users').doc(tempUser).get();
      data.add(doc);
    }

    return data;
  }

  static Future<QuerySnapshot> getAllGroupUserskk() async {
    //List<DocumentSnapshot> data = [];
    // for (var chunk in chunks) {
    final QuerySnapshot data = await fireStore.collection('chats').orderBy('latestActive', descending: true).get();
    // for (var tempUser in usersId) {
    //   DocumentSnapshot<Map<String, dynamic>> doc;
    //   doc = await fireStore.collection('Users').doc(tempUser).get();
    //   data.add(doc);
    // }

    return data;
  }

  // Future<List<QueryDocumentSnapshot>> listItems(List<dynamic> itemIds) async {
  //   final chunks = partition(itemIds, 10);
  //   final querySnapshots = await Future.wait(chunks.map((chunk) {
  //     Query itemsQuery = FirebaseFirestore.instance.collection('collection').where("id", whereIn: chunk);
  //     return itemsQuery.get();
  //   }).toList());
  //   return querySnapshots == null
  //       ? []
  //       : await Stream.fromIterable(querySnapshots).flatMap((qs) => Stream.fromIterable(qs.docs)).toList();
  // }

  // todo getAll users fpr group

  static Future<List<DocumentSnapshot>> getAllUsersForAddParticipants(List<dynamic> usersId) async {
    List<DocumentSnapshot> data = [];
    // for (var chunk in chunks) {
    for (var tempUser in usersId) {
      DocumentSnapshot<Map<String, dynamic>> doc;
      doc = await fireStore.collection('Users').doc(tempUser).get();
      data.add(doc);
    }

    return data;
  }

  static Future<List<DocumentSnapshot>> getAllUsersForGroup(List<dynamic> usersId) async {
    List<DocumentSnapshot> data = [];
    // for (var chunk in chunks) {
    for (var tempUser in usersId) {
      DocumentSnapshot<Map<String, dynamic>> doc;
      doc = await fireStore.collection('Users').doc(tempUser).get();
      data.add(doc);
    }
    for (var entity in data) {
      if (getAdminIds.contains(entity['id'])) {
        data.remove(entity);
        data.insert(0, entity);
      }
    }
    DocumentSnapshot? tempDoc;
    tempDoc = data.firstWhere((element) => element['id'] == user.uid);
    data.removeWhere((element) => element['id'] == user.uid);
    data.insert(0, tempDoc);
    // data.firstWhere((element) {
    //   element['id'] == user.uid;
    //   data.remove(element);
    //   data.insert(0, element);
    //   return true;
    // });
    return data;
  }

  static Future<void> updateProfileImage(File file) async {
    final ext = file.path.split('.').last;

    final ref = storage.ref().child('profiles_pictures/${user.uid}.$ext');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) => {print("data transfer ${p0.bytesTransferred / 100} kb")});

    me?.image = await ref.getDownloadURL();

    await fireStore.collection("Users").doc(user.uid).update({"image": me?.image});
  }

// todo update group image

  static Future<void> updateGroupImage(File file) async {
    final ext = file.path.split('.').last;

    final ref = storage.ref().child('profiles_pictures/${user.uid}.$ext');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) => {print("data transfer ${p0.bytesTransferred / 100} kb")});

    me?.image = await ref.getDownloadURL();
    String? image = await ref.getDownloadURL();
    await fireStore.collection("chats").doc(id).update({"image": image});
  }

  static String getConversationId(String id) {
    return user.uid.hashCode <= id.hashCode ? "${user.uid}_$id" : "${id}_${user.uid}";
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(UserModal user) {
    return isgroup != true
        ? fireStore
            .collection('chats/${getConversationId(user.id.toString())}/messages/')
            .orderBy("createAt", descending: true)
            .snapshots()
        : fireStore.collection('chats/${user.id}/messages/').orderBy("createAt", descending: true).snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllGroupMessages(ChatUserModal user) {
    return fireStore.collection('chats/${user.groupId}/messages/').orderBy("createAt", descending: true).snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserGroupInfo(ChatUserModal chatUserModal) {
    var data = fireStore.collection('Users').where("id", isEqualTo: chatUserModal.groupId).snapshots();

    return fireStore.collection('chats').where("groupId", isEqualTo: chatUserModal.groupId).snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(UserModal chatUserModal) {
    var data = fireStore.collection('Users').where("id", isEqualTo: chatUserModal.id).snapshots();

    return fireStore.collection('Users').where("id", isEqualTo: chatUserModal.id).snapshots();
  }

  // todo getgroup info

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserGroupFormIdInfo(String id) {
    return fireStore.collection('Users').where("id", isEqualTo: id).snapshots();
  }

  static Future<void> updateActiveUserStatus(bool isOnline) async {
    fireStore.collection('Users').doc(user.uid).update({
      "isOnline": isOnline,
      "lastActive": DateTime.now(),
      "pushToken": me?.pushToken,
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

  static Future<void> sendMessage(UserModal chatUser, String msg, Type type) async {
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
      fireStore.collection("chats").doc(getConversationId(chatUser.id.toString())).update({"latestActive": time});
    });
  }

  // todo gropumessage

  static Future<void> sendGroupMessage(ChatUserModal chatUser, String msg, Type type) async {
    final time = DateTime.now();
    final docgroupId = DateTime.now().millisecondsSinceEpoch.toString();

    final ref = fireStore.collection('chats/${chatUser.groupId}/messages/');
    DocumentReference docId = fireStore.collection("chats").doc(ref.id).collection("messages").doc();

    final MessagesModal messagesModal = MessagesModal(
      toId: chatUser.groupId,
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
      // sendPushNotification(
      //     chatUser,
      //     type == Type.text
      //         ? type == Type.audio
      //             ? msg
      //             : "audio"
      //         : "Image");
      fireStore.collection("chats").doc(chatUser.groupId).update({"latestActive": time});
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
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(UserModal user) {
    return fireStore
        .collection('chats/${getConversationId(user.id.toString())}/messages/')
        .orderBy("createAt", descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> setChateImage(UserModal chatUserModal, File file) async {
    final ext = file.path.split('.').last;

    final ref = storage.ref().child(
        'images/${getConversationId(chatUserModal.id.toString())}.${DateTime.now().millisecondsSinceEpoch.toString()}.$ext');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) => {print("data transfer ${p0.bytesTransferred / 100} kb")});
    final imgUrl = await ref.getDownloadURL();

    await sendMessage(chatUserModal, imgUrl, Type.image);
  }

// todo send image

  static Future<void> setChateImageInGroup(ChatUserModal chatUserModal, File file) async {
    final ext = file.path.split('.').last;

    final ref =
        storage.ref().child('images/${chatUserModal.groupId}.${DateTime.now().millisecondsSinceEpoch.toString()}.$ext');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) => {print("data transfer ${p0.bytesTransferred / 100} kb")});
    final imgUrl = await ref.getDownloadURL();

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

  static List deleteParticipantId = [];

  static Future<void> deleteParticipant(BuildContext context, String ids) async {
    if (deleteParticipantId.contains(ids)) {
      deleteParticipantId.remove(ids);
    }
    print(deleteParticipantId);
    final time = DateTime.now();
    final idCollectionModal = ChatUserModal(
        latestActive: time,
        users: deleteParticipantId,
        isPrivate: false,
        adminIds: getAdminIds,
        groupId: groupId,
        groupName: groupName,
        image: groupImage);
    // fireStore
    //     .collection("chats")
    //     .doc(id)
    //     .update({"latestActive": time, "isPrivate": false, "users": deleteParticipantId, "adminIds": getAdminIds});
    //
    fireStore.collection("chats").doc(id).update(idCollectionModal.toJson()).then((value) => Navigator.pop(context));
  }

  // static Future<void> deleteParticipant(String? userid) async {
  //    //await fireStore.collection('chats').doc(id).collection('my_users').doc(userid).delete();
  //   await fireStore.collection('chats').doc(id)
  //     ..delete();
  // }

  static Future<void> updateMessage(MessagesModal message, String updateMessage) async {
    await fireStore
        .collection('chats/${getConversationId(message.toId.toString())}/messages/')
        .doc(message.id)
        .update({"msg": updateMessage});
  }

  static Future<void> uploadAudioFile(UserModal chatUserModal, File audioFile) async {
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
    final ref =
        storage.ref().child('audio/${chatUserModal.groupId}.${DateTime.now().millisecondsSinceEpoch.toString()}');

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

      // else {
      //   print("result wifi status true");
      //   Apis.updateActiveUserStatus(true);
      // }
    });
  }

  static Uri? urls;
  static String? groupName;
  static String? groupImage;
  static String? groupId;

  static creatGroupDynamicLink() {
    createDynamicLink(path: '/invite?groupId=${groupId}');
  }

  static Future<Uri> createDynamicLink({String? path}) async {
    final String _prefix = 'https://chatappfirebase.page.link';
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

    DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: _prefix,
      link: Uri.parse("$_prefix$path"),
      androidParameters: const AndroidParameters(
        packageName: 'com.example.wayoutchatapp',
        minimumVersion: 1,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.example.wayoutchatapp',
        minimumVersion: '1.0.0',
      ),
    );

    Uri? url;
    final ShortDynamicLink shortLink = await dynamicLinks.buildShortLink(parameters);
    url = shortLink.shortUrl;
    //  url = await dynamicLinks.buildLink(parameters);
    print("url app");

    urls = url;
    print(url);

    return url;
  }

  static String? name;
  static StreamSubscription<PendingDynamicLinkData?>? linkSubscription;

  cancelUri() {
    linkSubscription?.cancel();
  }

  static Future<void> initDynamicLinks(BuildContext context) async {
    String? link;
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

    dynamicLinks.getInitialLink().then((dynamicLinkData) async {
      link = dynamicLinkData?.link.toString();

      if (dynamicLinkData?.link.path != null) {
        name = dynamicLinkData!.link.queryParameters['groupName'];

        if (dynamicLinkData.link.path.contains('invite')) {
          welcomeSheet(
            context,
            groupId: dynamicLinkData.link.queryParameters['groupId'],
          );
        }
      }
      // }
    });

    linkSubscription = dynamicLinks.onLink.listen((dynamicLinkData) {
      // logger.i('UTM Paramters onLink ${dynamicLinkData.link}');

      if (dynamicLinkData.link.path.contains('invite')) {
        welcomeSheet(context, groupId: dynamicLinkData.link.queryParameters['groupId']);
      }
    }, onError: (err) {});
  }
}
