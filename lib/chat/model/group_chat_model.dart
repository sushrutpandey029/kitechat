// To parse this JSON data, do
//
//     final groupChatModel = groupChatModelFromMap(jsonString);

import 'dart:convert';

import 'package:meta/meta.dart';

GroupChatModel groupChatModelFromMap(String str) =>
    GroupChatModel.fromMap(json.decode(str));

String groupChatModelToMap(GroupChatModel data) => json.encode(data.toMap());

class GroupChatModel {
  String id;
  String grpId;
  String senderId;
  String senderRegNo;
  String senderNumber;
  String senderName;
  String textMasseg;
  String fileMsg;
  String galleryFiles;
  String userLocation;
  String documents;
  String contacts;
  String voiceRecordMsg;
  String memsIconMsg;
  DateTime datetime;
  String massageStatus;
  GroupChatModel({
    required this.id,
    required this.grpId,
    required this.senderId,
    required this.senderRegNo,
    required this.senderNumber,
    required this.senderName,
    required this.textMasseg,
    required this.fileMsg,
    required this.galleryFiles,
    required this.userLocation,
    required this.documents,
    required this.contacts,
    required this.voiceRecordMsg,
    required this.memsIconMsg,
    required this.datetime,
    required this.massageStatus,
  });

  factory GroupChatModel.fromMap(Map<String, dynamic> json) => GroupChatModel(
        id: json["id"],
        grpId: json["grp_id"],
        senderId: json["sender_id"],
        senderRegNo: json["sender_reg_no"],
        senderNumber: json["sender_number"],
        senderName: json["sender_name"],
        textMasseg: json["text_masseg"],
        fileMsg: json["file_msg"],
        galleryFiles: json["gallery_files"],
        userLocation: json["user_location"],
        documents: json["documents"],
        contacts: json["contacts"],
        voiceRecordMsg: json["voice_record_msg"],
        memsIconMsg: json["mems_icon_msg"],
        datetime: DateTime.parse(json["datetime"]),
        massageStatus: json["massage_status"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "grp_id": grpId,
        "sender_id": senderId,
        "sender_reg_no": senderRegNo,
        "sender_number": senderNumber,
        "sender_name": senderName,
        "text_masseg": textMasseg,
        "file_msg": fileMsg,
        "gallery_files": galleryFiles,
        "user_location": userLocation,
        "documents": documents,
        "contacts": contacts,
        "voice_record_msg": voiceRecordMsg,
        "mems_icon_msg": memsIconMsg,
        "datetime": datetime.toIso8601String(),
        "massage_status": massageStatus,
      };

  @override
  String toString() {
    return 'GroupChatModel(id: $id, grpId: $grpId, senderId: $senderId, senderRegNo: $senderRegNo, senderNumber: $senderNumber, senderName: $senderName, textMasseg: $textMasseg, fileMsg: $fileMsg, galleryFiles: $galleryFiles, userLocation: $userLocation, documents: $documents, contacts: $contacts, voiceRecordMsg: $voiceRecordMsg, memsIconMsg: $memsIconMsg, datetime: $datetime, massageStatus: $massageStatus)';
  }
}
