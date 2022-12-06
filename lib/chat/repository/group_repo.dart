import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:kite/authentication/model/auth_user_model.dart';
import 'package:kite/chat/model/add_group_model.dart';
import 'package:kite/chat/model/group_chat_model.dart';
import 'package:kite/chat/model/group_member_model.dart';
import 'package:kite/chat/model/group_model.dart';

import '../../shared/constants/url_constants.dart';

class GroupRepo {
  final String _chatApi = '$baseUrl/Kiteapi_controller';
  Future<void> createGroup(AddGroupModel addGroupModel) async {
    String url = '$_chatApi/create_group';
    String imageName = addGroupModel.groupImage.split('/').last;
    try {
      FormData formData = FormData.fromMap({
        'user_id': addGroupModel.userId,
        'user_reg_no': addGroupModel.userRegNo,
        'user_name': addGroupModel.userName,
        'user_number': addGroupModel.userNumber,
        'group_name': addGroupModel.groupName,
        'group_image': await MultipartFile.fromFile(addGroupModel.groupImage),
        'group_description': addGroupModel.groupDescription,
      });
      Response response = await Dio().post(url,
          data: formData,
          options: Options(
              followRedirects: false,
              // will not throw errors
              validateStatus: (status) => true,
              headers: {'Connection': 'keep-alive'}));
      log(response.toString());
    } on Exception {
      rethrow;
    }
  }

  Future<List<GroupModel>> getGroupById(String userId) async {
    String path = "$_chatApi/group_list_by_id";
    try {
      Response response = await Dio().post(path,
          data: {"user_id": userId},
          options: Options(
              followRedirects: false,
              // will not throw errors
              validateStatus: (status) => true,
              headers: {'Connection': 'keep-alive'}));
      log(response.toString());
      List<GroupModel> list = [];
      if (response.data['status'] == 1) {
        for (Map<String, dynamic> map in response.data['data']) {
          GroupModel groupModel = GroupModel.fromMap(map);
          list.add(groupModel);
        }
      }
      return list;
    } on Exception {
      rethrow;
    }
  }

  Future<List<GroupMemberModel>> fetchGroupMembers(String groupId) async {
    String path = '$_chatApi/grp_member_list';
    try {
      Response response = await Dio().post(path,
          data: {"group_id": groupId},
          options: Options(
              followRedirects: false,
              // will not throw errors
              validateStatus: (status) => true,
              headers: {'Connection': 'keep-alive'}));
      List<GroupMemberModel> list = [];
      print(response.toString());
      if (response.data['status'] == 1) {
        for (Map<String, dynamic> map in response.data['data']) {
          GroupMemberModel groupMemberModel = GroupMemberModel.fromMap(map);
          list.add(groupMemberModel);
        }
      }
      return list;
    } on Exception {
      rethrow;
    }
  }

  Future<void> addMemberToGroup(
      AuthUserModel authUserModel, GroupModel groupModel) async {
    String path = '$_chatApi/add_grp_members';
    try {
      Response response = await Dio().post(path, data: {
        "group_id": groupModel.id,
        "group_name": groupModel.groupName,
        "user_id": authUserModel.id,
        "user_number": authUserModel.userPhoneNumber,
        "user_reg_no": authUserModel.userRegNo,
        "user_name": authUserModel.userName
      });
      print(response.toString());
    } on Exception {
      rethrow;
    }
  }

  Future<List<GroupChatModel>> fetchGroupMessages(String groupId) async {
    String path = "$_chatApi/display_grp_msg";
    try {
      List<GroupChatModel> list = [];
      Response response = await Dio().post(path,
          data: {"grp_id": groupId},
          options: Options(
              followRedirects: false,
              // will not throw errors
              validateStatus: (status) => true,
              headers: {'Connection': 'keep-alive'}));
      if (response.data['status'] == 1) {
        for (Map<String, dynamic> map in response.data['data']) {
          GroupChatModel chatModel = GroupChatModel.fromMap(map);
          list.add(chatModel);
        }
      }
      return list;
    } on Exception {
      rethrow;
    }
  }

  Future<void> sendGroupMessage(
      {required String groupId,
      required String userSenderId,
      required String userSenderRegNo,
      required String userSenderNumber,
      required String userSenderName,
      required String textMessage}) async {
    String path = "$_chatApi/send_grp_textmsg";
    try {
      Response response = await Dio().post(path, data: {
        "grp_id": groupId,
        "user_sender_id": userSenderId,
        "user_sender_reg_no": userSenderRegNo,
        "user_sender_number": userSenderNumber,
        "user_sender_name": userSenderName,
        "text_massage": textMessage
      });
      print(response.toString());
    } on Exception {
      rethrow;
    }
  }
}
