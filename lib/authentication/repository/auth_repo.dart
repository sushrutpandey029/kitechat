import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../shared/constants/url_constants.dart';
import '../model/auth_user_model.dart';
import '../model/join_user_model.dart';

class AuthRepo {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final String _kiteApi = '$baseUrl/Kiteapi_controller';

  Future<void> sendOtp(
      String phoneNumber,
      PhoneVerificationCompleted verificationCompleted,
      PhoneVerificationFailed verificationFailed,
      PhoneCodeSent codeSent,
      PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout) async {
    try {
     
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
           print('otp sent');
    } on FirebaseAuthException catch (e) {
      print(e.message);
      rethrow;
    }
  }

  Future<String?> authenticate(String otp, String verificationId) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user?.uid;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      rethrow;
    }
  }

  Future<bool> joinUser(JoinUserModel user) async {
    String url = '$_kiteApi/joinuser';

    String imageName = user.userImage.split('/').last;

    try {
      FormData formData = FormData.fromMap({
        'user_reg_no': user.userRegNo,
        'country': user.country,
        'user_phone_number': user.userPhoneNumber,
        'user_name': user.userName,
        'user_bio': user.userBio,
        'user_dob': user.userDob,
        'user_ip_address': user.userIpAddress,
        'user_phone_name': user.userPhoneName,
        'user_image':
            await MultipartFile.fromFile(user.userImage, filename: imageName),
        'uuid': user.userUid,
        'fcm': user.userFcm,
      });
      Response response = await Dio().post(url,
          data: formData,
          options: Options(
              followRedirects: false,
              // will not throw errors
              validateStatus: (status) => true,
              headers: {'Connection': 'keep-alive'}));
      print(response.data);

      return response.data['status'] == 1;
    } on DioError {
      rethrow;
    }
  }

  Future<AuthUserModel?> getUser(String mobileNo) async {
    String url = '$_kiteApi/list_of_user';
    try {
      Response response =
          await Dio().post(url, data: {"user_phone_number": mobileNo});

      if (response.data['status'] == 1) {
        // print(response.data["data"][0]);
        return AuthUserModel.fromMap(response.data["txt_msg"][0]);
      }
      return null;
    } on DioError {
      rethrow;
    }
  }
}
