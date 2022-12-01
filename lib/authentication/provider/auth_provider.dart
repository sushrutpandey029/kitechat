import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../database/hive_models/auth_hive_model.dart';
import '../../database/hive_models/boxes.dart';
import '../../shared/ui/screens/wrapper.dart';
import '../../shared/ui/widgets/custom_dialouge.dart';

import '../model/auth_user_model.dart';
import '../model/join_user_model.dart';
import '../repository/auth_repo.dart';
import '../ui/screens/get_otp_screen.dart';
import '../ui/screens/set_profile_screen.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepo _authRepo = AuthRepo();
  String? _verificationId;
  bool isLoading = false;
  AuthUserModel? authUserModel;
  AuthUserModel? authUserModelForCall;
  JoinUserModel joinUserModel = JoinUserModel(
    userRegNo: "user_reg_no",
    country: "country",
    userPhoneNumber: "user_phone_number",
    userImage: "user_image",
    userName: "user_name",
    userBio: "user_bio",
    userDob: DateTime.now(),
    userIpAddress: "user_ip_address",
    userPhoneName: "user_phone_name",
    userUid: "uuid",
    userFcm: "fcm",
  );

  Future<void> sendOtp(String phoneNumber, BuildContext context) async {
    await _authRepo.sendOtp(phoneNumber, _verificationCompleted,
        _verificationFailed, _codeSent, _codeAutoRetrievalTimeOut);
    joinUserModel.userPhoneNumber = phoneNumber;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const GetOtpPage()));
  }

  void _verificationCompleted(PhoneAuthCredential phoneAuthCredential) {}

  void _verificationFailed(FirebaseAuthException exception) {}

  void _codeSent(String code, [int? i]) {
    _verificationId = code;
  }

  void _codeAutoRetrievalTimeOut(String code) {
    _verificationId = code;
  }

  Future<void> authenticate(String otp, BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      await _authRepo.authenticate(otp, _verificationId!);

      await getUser(joinUserModel.userPhoneNumber);

      final authPh = AuthHiveModel()..pNumber = joinUserModel.userPhoneNumber;
      final box = Boxes.getAuthHive();
      // authPh.save();
      await box
          .put('authPh', authPh)
          .then((value) => log('logged in ${authPh.pNumber}'));

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const SetProfilePage()));
    } on FirebaseAuthException catch (e) {
      print(e.message);
      showDialog(
          context: context,
          builder: (context) => CustomDialogue(message: e.message ?? ''));
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> joinUser(BuildContext context) async {
    isLoading = true;
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    joinUserModel.userIpAddress = await _getLocalIpAddress() ?? '';
    joinUserModel.userPhoneName = androidDeviceInfo.model;
    joinUserModel.userRegNo = _generateRegistrationNumber();
    try {
      bool isJoined = await _authRepo.joinUser(joinUserModel);
      if (isJoined) {
        getUser(joinUserModel.userPhoneNumber);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Wrapper(),
        ));
      }
    } on DioError catch (e) {
      showDialog(
          context: context,
          builder: (context) => CustomDialogue(message: e.message));
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> getUser(String userMobileNumber) async {
    try {
      authUserModel = await _authRepo.getUser(userMobileNumber);
    } on DioError catch (e) {
      print(e.message);
    }
    notifyListeners();
  }

  Future<void> getUserForCall(String userMobileNumber) async {
    isLoading = true;
    try {
      authUserModelForCall = await _authRepo.getUser(userMobileNumber);
      print(authUserModelForCall);
    } on DioError catch (e) {
      print(e.message);
    }
    isLoading = false;
    notifyListeners();
  }

  static Future<String?> _getLocalIpAddress() async {
    final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4, includeLinkLocal: true);

    try {
      // Try VPN connection first
      NetworkInterface vpnInterface =
          interfaces.firstWhere((element) => element.name == "tun0");
      return vpnInterface.addresses.first.address;
    } on StateError {
      // Try wlan connection next
      try {
        NetworkInterface interface =
            interfaces.firstWhere((element) => element.name == "wlan0");
        return interface.addresses.first.address;
      } catch (ex) {
        // Try any other connection next
        try {
          NetworkInterface interface = interfaces.firstWhere((element) =>
              !(element.name == "tun0" || element.name == "wlan0"));
          return interface.addresses.first.address;
        } catch (ex) {
          return null;
        }
      }
    }
  }

  String _generateRegistrationNumber() {
    DateTime dateTime = DateTime.now();
    int timeFactor = dateTime.millisecondsSinceEpoch % 1000000;

    String regNo = 'KITE${timeFactor.toString()}${dateTime.year}';
    return regNo;
  }
}
