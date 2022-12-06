import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../authentication/provider/auth_provider.dart';
import '../../shared/ui/widgets/custom_dialouge.dart';
import '../repo/update_profile_repo.dart';

class UpdateProfileProvider extends ChangeNotifier {
  final UpdateProfileRepo _profileRepo = UpdateProfileRepo();
  bool isLoading = false;

  Future<void> updateProfile(
    BuildContext context, {
    required String userId,
    required bool isFirst,
    // required String userNumber,
    String? userName,
    String? userBio,
    String? userImage,
    String? uuid,
    String? fcm,
  }) async {
    try {
      isLoading = true;
      notifyListeners();
      if (userName != null) {
        await _profileRepo.updateUserName(userId, userName);
      }
      if (userBio != null) {
        await _profileRepo.updateUserBio(userId, userBio);
      }
      if (userImage != null) {
        await _profileRepo.updateUserImage(userId, userImage);
      }
      // if (userNumber != null) {
      //   await _profileRepo.updateUserNumber(userId, userNumber);
      // }
      if (uuid != null) {
        await _profileRepo.updateuuid(userId, uuid);
      }
      if (fcm != null) {
        await _profileRepo.updatefcm(userId, fcm);
      }
      if (userName != null || userBio != null || userImage != null) {
        await context.read<AuthProvider>().getUser(
            context.read<AuthProvider>().authUserModel!.userPhoneNumber);
      }

      isLoading = false;
      notifyListeners();
      if (!isFirst) {
        Navigator.pop(context);
      }
      log('here');
    } on DioError catch (e) {
      showDialog(
          context: context,
          builder: (context) => CustomDialogue(
                message: e.message,
              ));
    }
  }
}
