// To parse this JSON data, do
//
//     final welcome = welcomeFromMap(jsonString);

class AuthUserModel {
  AuthUserModel(
      {required this.id,
      required this.userRegNo,
      required this.country,
      required this.userPhoneNumber,
      required this.userImage,
      required this.userName,
      required this.userBio,
      required this.userDob,
      required this.userCreateDateTime,
      required this.userIpAddress,
      required this.userPhoneName,
      required this.userStatus,
      required this.userUid,
      required this.userFcm});

  String id;
  String userRegNo;
  String country;
  String userPhoneNumber;
  String userImage;
  String userName;
  String userBio;
  DateTime userDob;
  DateTime userCreateDateTime;
  String userIpAddress;
  String userPhoneName;
  String userStatus;
  String userUid;
  String userFcm;

  factory AuthUserModel.fromMap(Map<String, dynamic> json) => AuthUserModel(
        id: json["id"],
        userRegNo: json["user_reg_no"],
        country: json["country"],
        userPhoneNumber: json["user_phone_number"],
        userImage: json["user_image"],
        userName: json["user_name"],
        userBio: json["user_bio"],
        userDob: DateTime.parse(json["user_dob"]),
        userCreateDateTime: DateTime.parse(json["user_create_datetime"]),
        userIpAddress: json["user_ip_address"],
        userPhoneName: json["user_phone_name"],
        userStatus: json["user_status"],
        userUid: json["user_uid"] ?? '',
        userFcm: json["user_fcm"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_reg_no": userRegNo,
        "country": country,
        "user_phone_number": userPhoneNumber,
        "user_image": userImage,
        "user_name": userName,
        "user_bio": userBio,
        "user_dob": userDob.toIso8601String(),
        "user_create_datetime": userCreateDateTime.toIso8601String(),
        "user_ip_address": userIpAddress,
        "user_phone_name": userPhoneName,
        "user_status": userStatus,
        "user_uid": userUid,
        "user_fcm": userFcm,
      };

  @override
  String toString() {
    return 'AuthUserModel(id: $id, userRegNo: $userRegNo, country: $country, userPhoneNumber: $userPhoneNumber, userImage: $userImage, userName: $userName, userBio: $userBio, userDob: $userDob, userCreateDateTime: $userCreateDateTime, userIpAddress: $userIpAddress, userPhoneName: $userPhoneName, userStatus: $userStatus,  user_uid: $userUid, user_fcm: $userFcm,)';
  }
}
