import 'dart:convert';

ChatModel chatModelFromMap(String str) => ChatModel.fromMap(json.decode(str));

String chatModelToMap(ChatModel data) => json.encode(data.toMap());

class ChatModel {
  ChatModel({
    required this.id,
    required this.senderId,
    required this.senderRegNo,
    required this.senderNumber,
    required this.senderName,
    required this.receiverId,
    required this.receiverRegNo,
    required this.receiverNumber,
    required this.receiverName,
    required this.textMessage,
    required this.emojiMessage,
    required this.datetime,
    required this.massageStatus,
    required this.imageMessage,
    required this.fileMessage,
    required this.audioMessage,
    required this.location,
    required this.contact,
  });

  String id;
  String senderId;
  String senderRegNo;
  String senderNumber;
  String senderName;
  String receiverId;
  String receiverRegNo;
  String receiverNumber;
  String receiverName;
  String textMessage;
  String emojiMessage;
  DateTime datetime;
  String massageStatus;
  String audioMessage;
  String imageMessage;
  String fileMessage;
  String location;
  String contact;

  factory ChatModel.fromMap(Map<String, dynamic> json) => ChatModel(
        id: json["id"] ?? '0',
        senderId: json["sender_id"] ?? '',
        senderRegNo: json["sender_reg_no"] ?? '',
        senderNumber: json["sender_number"] ?? '',
        senderName: json["sender_name"] ?? '',
        receiverId: json["receiver_id"] ?? '',
        receiverRegNo: json["receiver_reg_no"] ?? '',
        receiverNumber: json["receiver_number"] ?? '',
        receiverName: json["receiver_name"] ?? '',
        textMessage: json["text_masseg"] ?? '',
        emojiMessage: json["mems"] ?? '',
        datetime: DateTime.parse(
            json["datetime"] ?? DateTime.now().toIso8601String()),
        massageStatus: json["massage_status"] ?? '',
        imageMessage: json["file_msg"] ?? '',
        fileMessage: json["documents"] ?? '',
        audioMessage: json["voice_record_msg"] ?? '',
        location: json['user_location'] ?? '',
        contact: json['contacts'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "sender_id": senderId,
        "sender_reg_no": senderRegNo,
        "sender_number": senderNumber,
        "sender_name": senderName,
        "receiver_id": receiverId,
        "receiver_reg_no": receiverRegNo,
        "receiver_number": receiverNumber,
        "receiver_name": receiverName,
        "text_masseg": textMessage,
        "mems": emojiMessage,
        "datetime": datetime.toIso8601String(),
        "massage_status": massageStatus,
        "file_msg": imageMessage,
        "voice_record_msg": audioMessage,
        "user_location": location,
        "contacts": contact,
        "documents": fileMessage,
      };

  @override
  String toString() {
    return 'ChatModel(id: $id, senderId: $senderId, senderRegNo: $senderRegNo, senderNumber: $senderNumber, senderName: $senderName, receiverId: $receiverId, receiverRegNo: $receiverRegNo, receiverNumber: $receiverNumber, receiverName: $receiverName, textMasseg: $textMessage, datetime: $datetime, massageStatus: $massageStatus, imageMessage: $imageMessage, audioMessage: $audioMessage)';
  }
}
