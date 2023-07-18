class MessagesModal {
  String? id;
  String? toId;
  String? msg;
  DateTime? read;
  Type? type;
  String? fromId;
  DateTime? sent;
  DateTime? createAt;
  bool? readAudio;
  List<ChatUserList>? chatUserList;
  MessagesModal(
      {this.id,
      this.fromId,
      this.msg,
      this.read,
      this.sent,
      this.toId,
      this.type,
      this.createAt,
      this.readAudio,
      this.chatUserList});

  factory MessagesModal.fromJson(Map<String, dynamic>? json) => MessagesModal(
        id: json?["id"],
        toId: json?["toId"],
        msg: json?["msg"],
        read: json?["read"] != null ? json!["read"].toDate() : json?["read"],
        type: makeTypeOfData(json?["type"]),
        // json?["type"] == Type.image.name ? json!["type"] == Type.audio.name ? Type.image : Type.audio : Type.text,
        fromId: json?["fromId"],
        sent: json?["sent"] != null ? json!["sent"].toDate() : json?["sent"],
        createAt: json?["createAt"] != null ? json!["createAt"].toDate() : json?["createAt"],
        readAudio: json?["readAudio"],
        chatUserList: json?["chatUserList"] == null
            ? []
            : List<ChatUserList>.from(json?["chatUserList"]!.map((x) => ChatUserList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "toId": toId,
        "msg": msg,
        "read": read,
        "type": type?.name,
        "fromId": fromId,
        "sent": sent,
        "createAt": createAt,
        "readAudio": readAudio,
        "trips": chatUserList == null ? [] : List<dynamic>.from(chatUserList!.map((x) => x.toJson())),
      };
}

Type makeTypeOfData(String type) {
  print("type in modal: $type");
  if (type == 'image') {
    return Type.image;
  }
  if (type == 'audio') {
    return Type.audio;
  }
  if (type == 'text') {
    return Type.text;
  }
  return Type.text;
}

enum Type { text, image, audio }

class ChatUserList {
  String? name;
  String? about;
  String? image;
  String? id;
  DateTime? lastActive;
  DateTime? createAt;
  String? email;
  String? pushToken;
  bool? isOnline;

  ChatUserList(
      {this.name,
      this.isOnline,
      this.about,
      this.createAt,
      this.id,
      this.image,
      this.email,
      this.lastActive,
      this.pushToken});

  factory ChatUserList.fromJson(Map<String, dynamic>? json) => ChatUserList(
      name: json?["name"],
      about: json?["about"],
      isOnline: json?["isOnline"],
      createAt: json?["createAt"] != null ? json!["createAt"].toDate() : json?["createAt"],
      image: json?["image"] == null ? null : json?["image"],
      email: json?["email"],
      id: json?["id"],
      lastActive: json?["lastActive"] != null ? json!["lastActive"].toDate() : json?["lastActive"],
      pushToken: json?["pushToken"]);

  Map<String, dynamic> toJson() => {
        "name": name,
        "about": about,
        "isOnline": isOnline,
        "createAt": createAt,
        "image": image,
        "email": email,
        "id": id,
        "lastActive": lastActive,
        "pushToken": pushToken
      };
}
