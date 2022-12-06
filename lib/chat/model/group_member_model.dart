// To parse this JSON data, do
//
//     final groupMemberModel = groupMemberModelFromMap(jsonString);

import 'dart:convert';

import 'package:meta/meta.dart';

GroupMemberModel groupMemberModelFromMap(String str) =>
    GroupMemberModel.fromMap(json.decode(str));

String groupMemberModelToMap(GroupMemberModel data) =>
    json.encode(data.toMap());

class GroupMemberModel {
  String id;
  String kiteGroupId;
  String kiteGroupName;
  String userId;
  String userRegNo;
  String userName;
  String userNumber;
  String userRole;
  String userIsleft;
  DateTime userAddDate;

  GroupMemberModel({
    required this.id,
    required this.kiteGroupId,
    required this.kiteGroupName,
    required this.userId,
    required this.userRegNo,
    required this.userName,
    required this.userNumber,
    required this.userRole,
    required this.userIsleft,
    required this.userAddDate,
  });

  factory GroupMemberModel.fromMap(Map<String, dynamic> json) =>
      GroupMemberModel(
        id: json["id"],
        kiteGroupId: json["kite_group_id"],
        kiteGroupName: json["kite_group_name"],
        userId: json["user_id"],
        userRegNo: json["user_reg_no"],
        userName: json["user_name"],
        userNumber: json["user_number"],
        userRole: json["user_role"],
        userIsleft: json["user_isleft"],
        userAddDate: DateTime.parse(json["user_add_date"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "kite_group_id": kiteGroupId,
        "kite_group_name": kiteGroupName,
        "user_id": userId,
        "user_reg_no": userRegNo,
        "user_name": userName,
        "user_number": userNumber,
        "user_role": userRole,
        "user_isleft": userIsleft,
        "user_add_date": userAddDate.toIso8601String(),
      };

  @override
  String toString() {
    return 'GroupMemberModel(id: $id, kiteGroupId: $kiteGroupId, kiteGroupName: $kiteGroupName, userId: $userId, userRegNo: $userRegNo, userName: $userName, userNumber: $userNumber, userRole: $userRole, userIsleft: $userIsleft, userAddDate: $userAddDate)';
  }
}
