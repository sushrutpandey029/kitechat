
import 'dart:convert';

GroupModel sendChatModelFromMap(String str) => GroupModel.fromMap(json.decode(str));

String sendChatModelToMap(GroupModel data) => json.encode(data.toMap());

class GroupModel {
    GroupModel({
        required this.id,
        required this.userId,
        required this.userRegNo,
        required this.userName,
        required this.groupName,
        required this.groupImage,
        required this.groupDescription,
        required this.cretaedDate,
        required this.userRole,
    });

    String id;
    String userId;
    String userRegNo;
    String userName;
    String groupName;
    String groupImage;
    String groupDescription;
    DateTime cretaedDate;
    String userRole;

    factory GroupModel.fromMap(Map<String, dynamic> json) => GroupModel(
        id: json["id"],
        userId: json["user_id"],
        userRegNo: json["user_reg_no"],
        userName: json["user_name"],
        groupName: json["group_name"],
        groupImage: json["group_image"],
        groupDescription: json["group_description"],
        cretaedDate: DateTime.parse(json["cretaed_date"]),
        userRole: json["user_role"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "user_reg_no": userRegNo,
        "user_name": userName,
        "group_name": groupName,
        "group_image": groupImage,
        "group_description": groupDescription,
        "cretaed_date": cretaedDate.toIso8601String(),
        "user_role": userRole,
    };
}
