import 'dart:convert';

class AddGroupModel {
String userId;
String userRegNo;
String userName;
String userNumber;
String groupName;
String groupImage;
String groupDescription;
  AddGroupModel({
    required this.userId,
    required this.userRegNo,
    required this.userName,
    required this.userNumber,
    required this.groupName,
    required this.groupImage,
    required this.groupDescription,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'user_reg_no': userRegNo,
      'user_name': userName,
      'user_number': userNumber,
      'group_name': groupName,
      'group_image': groupImage,
      'group_description': groupDescription,
    };
  }

  factory AddGroupModel.fromMap(Map<String, dynamic> map) {
    return AddGroupModel(
      userId: map['user_id'] ?? '',
      userRegNo: map['user_reg_no'] ?? '',
      userName: map['user_name'] ?? '',
      userNumber: map['user_number'],
      groupName: map['group_name'] ?? '',
      groupImage: map['group_image'] ?? '',
      groupDescription: map['group_description'] ?? '',
    );
  }

  @override
  String toString() {
    return 'AddGroupModel(userId: $userId, userRegNo: $userRegNo, userName: $userName, userNumber: $userNumber, groupName: $groupName, groupImage: $groupImage, groupDescription: $groupDescription)';
  }

  String toJson() => json.encode(toMap());

  factory AddGroupModel.fromJson(String source) => AddGroupModel.fromMap(json.decode(source));
}
