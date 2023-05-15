class MessagesModal {
  String? toId;
  String? msg;
  String? read;
  Type? type;
  String? fromId;
  String? sent;

  MessagesModal({this.fromId, this.msg, this.read, this.sent, this.toId, this.type});

  factory MessagesModal.fromJson(Map<String, dynamic>? json) => MessagesModal(
      toId: json?["toId"],
      msg: json?["msg"],
      read: json?["read"],
      type: json?["type"] == Type.image.name ? Type.image : Type.text,
      fromId: json?["fromId"],
      sent: json?["sent"]);

  Map<String, dynamic> toJson() => {"toId": toId, "msg": msg, "read": read, "type": type?.name, "fromId": fromId, "sent": sent};
}

enum Type { text, image }
