class ChatUserModal {
  String? name;
  String? about;
  String? image;
  String? id;
  String? lastActive;
  String? createAt;
  String? email;
  String? pushToken;
  bool? isOnline;

  ChatUserModal({this.name, this.isOnline, this.about, this.createAt, this.id, this.image, this.email, this.lastActive, this.pushToken});

  factory ChatUserModal.fromJson(Map<String, dynamic>? json) => ChatUserModal(
      name: json?["name"],
      about: json?["about"],
      isOnline: json?["isOnline"],
      createAt: json?["createAt"],
      image: json?["image"] == null ? null : json?["image"],
      email: json?["email"],
      id: json?["id"],
      lastActive: json?["lastActive"],
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
