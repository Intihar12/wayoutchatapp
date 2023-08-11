class ChatUserModal {
  // String? firstId;
  DateTime? latestActive;
  bool? isPrivate;
  List? users;
  List? adminIds;
  String? image;
  String? groupId;
  String? groupName;

  ChatUserModal(
      {this.isPrivate, this.latestActive, this.users, this.adminIds, this.groupId, this.image, this.groupName});

  factory ChatUserModal.fromJson(Map<String, dynamic>? json) => ChatUserModal(
      // firstId: json?["firstId"],
      latestActive: json?["latestActive"] != null ? json!["latestActive"].toDate() : json?["latestActive"],
      isPrivate: json?["isPrivate"],
      users: json?["users"],
      adminIds: json?["adminIds"],
      groupId: json?["groupId"],
      groupName: json?["groupName"],
      image: json?["image"]);

  Map<String, dynamic> toJson() => {
        "latestActive": latestActive,
        "isPrivate": isPrivate,
        "users": users,
        "adminIds": adminIds,
        "image": image,
        "groupId": groupId,
        "groupName": groupName
      };
}
