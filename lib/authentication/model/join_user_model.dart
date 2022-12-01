class JoinUserModel {
  JoinUserModel(
      {required this.userRegNo,
      required this.country,
      required this.userPhoneNumber,
      required this.userImage,
      required this.userName,
      required this.userBio,
      required this.userDob,
      required this.userIpAddress,
      required this.userPhoneName,
      required this.userUid,
      required this.userFcm});

  String userRegNo;
  String country;
  String userPhoneNumber;
  String userImage;
  String userName;
  String userBio;
  DateTime userDob;
  String userIpAddress;
  String userPhoneName;
  String userUid;
  String userFcm;

  factory JoinUserModel.fromMap(Map<String, dynamic> json) => JoinUserModel(
        userRegNo: json["user_reg_no"],
        country: json["country"],
        userPhoneNumber: json["user_phone_number"],
        userImage: json["user_image"],
        userName: json["user_name"],
        userBio: json["user_bio"],
        userDob: DateTime.parse(json["user_dob"]),
        userIpAddress: json["user_ip_address"],
        userPhoneName: json["user_phone_name"],
        userUid: json["user_uid"] ?? '',
        userFcm: json["user_fcm"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "user_reg_no": userRegNo,
        "country": country,
        "user_phone_number": userPhoneNumber,
        "user_image": userImage,
        "user_name": userName,
        "user_bio": userBio,
        "user_dob": userDob.toIso8601String(),
        "user_ip_address": userIpAddress,
        "user_phone_name": userPhoneName,
        "uuid": userUid,
        "fcm": userFcm,
      };

  @override
  String toString() {
    return 'JoinUserModel(userRegNo: $userRegNo, country: $country, userPhoneNumber: $userPhoneNumber, userImage: $userImage, userName: $userName, userBio: $userBio, userDob: $userDob, userIpAddress: $userIpAddress, userPhoneName: $userPhoneName,uuid: $userUid, fcm: $userFcm,)';
  }
}
