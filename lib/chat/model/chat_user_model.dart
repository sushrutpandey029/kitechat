import 'dart:convert';

class ChatUserModel {
  String userId;
  String userRegNo;
  String userName;
  String userPhoneNo;
  String lastMessage;
  DateTime lastMessageTime;
  int unreadMessagesCount;
  ChatUserModel({
    required this.userId,
    required this.userRegNo,
    required this.userName,
    required this.userPhoneNo,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadMessagesCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userRegNo': userRegNo,
      'userName': userName,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.millisecondsSinceEpoch,
      'unreadMessagesCount': unreadMessagesCount,
    };
  }

  factory ChatUserModel.fromMap(Map<String, dynamic> map) {
    return ChatUserModel(
      userId: map['userId'] ?? '',
      userRegNo: map['userRegNo'] ?? '',
      userName: map['userName'] ?? '',
      userPhoneNo: map['userPhoneNo'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime:
          DateTime.fromMillisecondsSinceEpoch(map['lastMessageTime']),
      unreadMessagesCount: map['unreadMessagesCount']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatUserModel.fromJson(String source) =>
      ChatUserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChatUserModel(userId: $userId, userRegNo: $userRegNo, userName: $userName, userPhoneNo: $userPhoneNo, lastMessage: $lastMessage, lastMessageTime: $lastMessageTime, unreadMessagesCount: $unreadMessagesCount)';
  }
}
