// class UserModal {
//   List<ChatUserModal>? chatUserList;
//
//   UserModal({this.chatUserList});
//
//   factory UserModal.fromJson(Map<String, dynamic>? json) => UserModal(
//         chatUserList: json?["chatUserList"] == null
//             ? []
//             : List<ChatUserModal>.from(json?["chatUserList"]!.map((x) => ChatUserModal.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "chatUserList": chatUserList == null ? [] : List<dynamic>.from(chatUserList!.map((x) => x.toJson())),
//       };
// }

class UserModal {
  String? name;
  String? about;
  String? image;
  String? id;
  DateTime? lastActive;
  DateTime? createAt;
  String? email;
  String? pushToken;
  bool? isOnline;
  bool? isGroup;

  UserModal(
      {this.name,
      this.isOnline,
      this.about,
      this.createAt,
      this.id,
      this.image,
      this.email,
      this.lastActive,
      this.pushToken,
      this.isGroup});

  factory UserModal.fromJson(Map<String, dynamic>? json) => UserModal(
      name: json?["name"],
      about: json?["about"],
      isOnline: json?["isOnline"],
      isGroup: json?["isGroup"],
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
        "isGroup": isGroup,
        "createAt": createAt,
        "image": image,
        "email": email,
        "id": id,
        "lastActive": lastActive,
        "pushToken": pushToken
      };
}
