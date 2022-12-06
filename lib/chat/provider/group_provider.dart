import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kite/authentication/model/auth_user_model.dart';
import 'package:kite/authentication/provider/auth_provider.dart';
import 'package:kite/chat/model/add_group_model.dart';
import 'package:kite/chat/model/group_chat_model.dart';
import 'package:kite/chat/model/group_model.dart';
import 'package:kite/chat/provider/chat_provider.dart';
import 'package:kite/chat/repository/group_repo.dart';
import 'package:provider/provider.dart';

import '../model/group_member_model.dart';
import '../ui/screens/chat_screen.dart';

class GroupProvider extends ChangeNotifier {
  bool isCreating = false;
  GroupRepo _groupRepo = GroupRepo();
  List<GroupModel> groupList = [];
  GroupModel? selectedGroup;
  List<GroupMemberModel> groupMembersList = [];
  List<GroupChatModel> groupChatList = [];

  Future<void> createGroup(
      AddGroupModel addGroupModel, BuildContext context) async {
    try {
      isCreating = true;
      notifyListeners();
      AuthUserModel authUserModel = context.read<AuthProvider>().authUserModel!;
      addGroupModel.userId = authUserModel.id;
      addGroupModel.userName = authUserModel.userName;
      addGroupModel.userRegNo = authUserModel.userRegNo;
      addGroupModel.userNumber = authUserModel.userPhoneNumber;
      print(addGroupModel);
      await _groupRepo.createGroup(addGroupModel);
      isCreating = false;
      notifyListeners();
      // context.read<ChatProvider>().fetchChat(context);

      getGroupById(authUserModel.id, context);
      Navigator.pop(context);
    } on DioError catch (e) {
      log(e.message);
    }
  }

  Future<void> getGroupById(String userId, BuildContext context) async {
    groupList = await _groupRepo.getGroupById(userId);
    notifyListeners();
  }

  void selectGroup(int index, BuildContext context) {
    selectedGroup = groupList.elementAt(index);
    fetchGroupMembers();
    groupChatList.clear();
    fetchGroupMessages(selectedGroup!.id);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatScreen(
                  isGroupChat: true,
                )));
  }

  Future<void> fetchGroupMembers() async {
    groupMembersList = await _groupRepo.fetchGroupMembers(selectedGroup!.id);
    notifyListeners();
  }

  Future<void> addGroupMember(AuthUserModel authUserModel) async {
    await _groupRepo.addMemberToGroup(authUserModel, selectedGroup!);
    fetchGroupMembers();
  }

  Future<void> fetchGroupMessages(String groupId) async {
    groupChatList = await _groupRepo.fetchGroupMessages(groupId);
    notifyListeners();
  }

  Future<void> sendGroupMessage(
      {required String textMessage, required BuildContext context}) async {
    AuthUserModel authUserModel = context.read<AuthProvider>().authUserModel!;
    await _groupRepo.sendGroupMessage(
      groupId: selectedGroup!.id,
      userSenderId: authUserModel.id,
      userSenderRegNo: authUserModel.userRegNo,
      userSenderNumber: authUserModel.userPhoneNumber,
      userSenderName: authUserModel.userName,
      textMessage: textMessage,
    );
    fetchGroupMessages(selectedGroup!.id);
  }
}
