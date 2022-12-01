import 'package:hive/hive.dart';

part 'message_hive_model.g.dart';

@HiveType(typeId: 0)
class MessageHiveModel extends HiveObject {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String senderId;
  @HiveField(2)
  late String senderRegNo;
  @HiveField(3)
  late String senderNumber;
  @HiveField(4)
  late String senderName;
  @HiveField(5)
  late String receiverId;
  @HiveField(6)
  late String receiverRegNo;
  @HiveField(7)
  late String receiverNumber;
  @HiveField(8)
  late String receiverName;
  @HiveField(9)
  late String textMasseg;
  @HiveField(10)
  late DateTime datetime;
  @HiveField(11)
  late String massageStatus;
  @HiveField(12)
  String? imageMessage;
  @HiveField(13)
  String? audioMessage;
  // @HiveField(14)
  // List<String>? documents;
  // @HiveField(15)
  // List<String>? gallery;
  // @HiveField(16)
  // List<String>? contacts;
  // @HiveField(17)
  // String? location;
  // @HiveField(18)
  // String? memes;

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "sender_id": senderId,
      "sender_reg_no": senderRegNo,
      "sender_number": senderNumber,
      "sender_name": senderName,
      "receiver_id": receiverId,
      "receiver_reg_no": receiverRegNo,
      "receiver_number": receiverNumber,
      "receiver_name": receiverName,
      "text_masseg": textMasseg,
      "datetime": datetime.toIso8601String(),
      "massage_status": massageStatus,
      'file_msg': imageMessage,
      'voice_record_msg': audioMessage,
      // 'documents': documents,
      // 'gallery_files': gallery,
      // 'contacts': contacts,
      // 'location': location,
      // 'memes': memes,
    };
  }

  @override
  String toString() {
    return 'MessageHiveModel(id: $id, senderId: $senderId, senderRegNo: $senderRegNo, senderNumber: $senderNumber, senderName: $senderName, receiverId: $receiverId, receiverRegNo: $receiverRegNo, receiverNumber: $receiverNumber, receiverName: $receiverName, textMasseg: $textMasseg, datetime: $datetime, massageStatus: $massageStatus, imageMessage: $imageMessage, audioMessage: $audioMessage)';
    // return 'MessageHiveModel(id: $id, senderId: $senderId, senderRegNo: $senderRegNo, senderNumber: $senderNumber, senderName: $senderName, receiverId: $receiverId, receiverRegNo: $receiverRegNo, receiverNumber: $receiverNumber, receiverName: $receiverName, textMasseg: $textMasseg, datetime: $datetime, massageStatus: $massageStatus, imageMessage: $imageMessage, audioMessage: $audioMessage, documents: $documents, gallery: $gallery, contacts: $contacts, location: $location, memes: $memes)';
  }
}
