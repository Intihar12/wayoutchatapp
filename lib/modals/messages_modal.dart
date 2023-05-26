class MessagesModal {
  String? id;
  String? toId;
  String? msg;
  DateTime? read;
  Type? type;
  String? fromId;
  DateTime? sent;
  DateTime? createAt;

  MessagesModal({this.id, this.fromId, this.msg, this.read, this.sent, this.toId, this.type, this.createAt});

  factory MessagesModal.fromJson(Map<String, dynamic>? json) => MessagesModal(
      id: json?["id"],
      toId: json?["toId"],
      msg: json?["msg"],
      read: json?["read"] != null ? json!["read"].toDate() : json?["read"],
      type: json?["type"] == Type.image.name ? Type.image : Type.text,
      fromId: json?["fromId"],
      sent: json?["sent"] != null ? json!["sent"].toDate() : json?["sent"],
      createAt: json?["createAt"] != null ? json!["createAt"].toDate() : json?["createAt"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "toId": toId, "msg": msg, "read": read, "type": type?.name, "fromId": fromId, "sent": sent, "createAt": createAt};
}

enum Type { text, image }
