import 'package:dio/dio.dart';

import '../../shared/constants/url_constants.dart';

class UpdateProfileRepo {
  final String _kiteApi = '$baseUrl/Kiteapi_controller';

  Future<void> updateUserName(String userId, String userName) async {
    String path = '$_kiteApi/update_user_name';
    try {
      Response response = await Dio()
          .post(path, data: {"user_id": userId, "update_username": userName});

      print(response.data);
    } on DioError {
      rethrow;
    }
  }

  Future<void> updateUserBio(String userId, String userBio) async {
    String path = '$_kiteApi/update_user_bio';
    try {
      Response response = await Dio()
          .post(path, data: {"user_id": userId, "update_userbio": userBio});

      print(response.data);
    } on DioError {
      rethrow;
    }
  }

  Future<void> updateUserImage(String userId, String userImage) async {
    String path = '$_kiteApi/update_user_image';
    try {
      FormData formData = FormData.fromMap({
        "user_id": userId,
        "update_image": await MultipartFile.fromFile(userImage)
      });
      Response response = await Dio().post(
        path,
        data: formData,
      );

      print(response.data);
    } on DioError {
      rethrow;
    }
  }

  Future<void> updateUserNumber(String userId, String userNumber) async {
    String path = '$_kiteApi/update_user_number';
    try {
      Response response = await Dio()
          .post(path, data: {"user_id": userId, "change_number": userNumber});

      print(response.data);
    } on DioError {
      rethrow;
    }
  }

  Future<void> updateuuid(String userId, String uuid) async {
    String path = '$_kiteApi/update_user_uid';
    try {
      Response response =
          await Dio().post(path, data: {"user_id": userId, "user_uid": uuid});

      print(response.data);
    } on DioError {
      rethrow;
    }
  }

  Future<void> updatefcm(String userId, String fcm) async {
    String path = '$_kiteApi/update_user_fcm';
    try {
      Response response =
          await Dio().post(path, data: {"user_id": userId, "user_fcm": fcm});

      print(response.data);
    } on DioError {
      rethrow;
    }
  }
}
