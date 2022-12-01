//depriciated provider

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../authentication/model/auth_user_model.dart';
import '../../authentication/provider/auth_provider.dart';
import '../../database/repository/message_hive_repo.dart';
import '../model/chat_model.dart';
import '../model/chat_user_model.dart';
import '../model/send_message_model.dart';
import '../repository/chat_repo.dart';
import '../ui/screens/chat_screen.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepo _chatRepo = ChatRepo();
  List<ChatUserModel> chatUsersList = [];
  bool isLoading = false;
  ChatUserModel? selectedUser;
  List<ChatModel> finalChatList = [];
  final MessageHiveRepo _messageHiveRepo = MessageHiveRepo();

  void fetchChatUsersLocal(BuildContext context) {
    isLoading = true;
    String userId = context.read<AuthProvider>().authUserModel!.id;
    log(userId);
    List<ChatModel> chatList = _messageHiveRepo.fetchMessages();
    List<ChatUserModel> userList = [];
    List<String> userIdList = [];

    for (ChatModel chat in chatList) {
      if (chat.senderId == userId) {
        if (userIdList.contains(chat.receiverId)) {
          userList
              .where((element) => element.userId == chat.receiverId)
              .first
              .lastMessage = chat.textMessage;
          userList
              .where((element) => element.userId == chat.receiverId)
              .first
              .userName = chat.receiverName;
          userList
              .where((element) => element.userId == chat.receiverId)
              .first
              .lastMessageTime = chat.datetime;
          int unReadMessageCount = userList
              .where((element) => element.userId == chat.receiverId)
              .first
              .unreadMessagesCount;
          userList
              .where((element) => element.userId == chat.receiverId)
              .first
              .unreadMessagesCount = ++unReadMessageCount;
          //todo: check for unread message count
          print(unReadMessageCount);
        } else {
          userIdList.add(chat.receiverId);
          userList.add(ChatUserModel(
            userId: chat.receiverId,
            userRegNo: chat.receiverRegNo,
            userName: chat.receiverName,
            userPhoneNo: chat.receiverNumber,
            lastMessage: chat.textMessage,
            lastMessageTime: chat.datetime,
            unreadMessagesCount: 0,
          ));

          //todo: check for unread message count
        }
      } else {
        if (userIdList.contains(chat.senderId)) {
          userList
              .where((element) => element.userId == chat.senderId)
              .first
              .lastMessage = chat.textMessage;
          userList
              .where((element) => element.userId == chat.senderId)
              .first
              .userName = chat.senderName;
          userList
              .where((element) => element.userId == chat.senderId)
              .first
              .lastMessageTime = chat.datetime;
          int unReadMessageCount = userList
              .where((element) => element.userId == chat.senderId)
              .first
              .unreadMessagesCount;
          userList
              .where((element) => element.userId == chat.senderId)
              .first
              .unreadMessagesCount = ++unReadMessageCount;
          //todo: check for unread message count
        } else {
          userIdList.add(chat.senderId);
          userList.add(ChatUserModel(
            userId: chat.senderId,
            userRegNo: chat.senderRegNo,
            userName: chat.senderName,
            userPhoneNo: chat.senderNumber,
            lastMessage: chat.textMessage,
            lastMessageTime: chat.datetime,
            unreadMessagesCount: 0,
          ));
          //todo: check for unread message count
        }
      }
    }

    userList.sort((a, b) {
      return b.lastMessageTime.compareTo(a.lastMessageTime);
    });

    chatUsersList = userList;
    log(chatUsersList.toString());
    // });
    isLoading = false;
  }

  Future<void> fetchChatUsers(BuildContext context) async {
    List<ChatModel>? chatList;
    isLoading = true;

    fetchChatUsersLocal(context);
    // _messageHiveRepo.clearBox();
    // notifyListeners();
    // initalise(context).then((value) async {
    String userId = context.read<AuthProvider>().authUserModel!.id;
    chatList = (await _chatRepo.fetchChatBySenderId(userId)).cast<ChatModel>();
    chatList.addAll(
        (await _chatRepo.fetchChatByReceiverId(userId)).cast<ChatModel>());
    chatList.sort((a, b) {
      return a.datetime.compareTo(b.datetime);
    });
    List<ChatUserModel> userList = [];
    List<String> userIdList = [];
    await _messageHiveRepo.addMessages(chatList, true);

    for (ChatModel chat in chatList) {
      if (chat.senderId == userId) {
        if (userIdList.contains(chat.receiverId)) {
          userList
              .where((element) => element.userId == chat.receiverId)
              .first
              .lastMessage = chat.textMessage;
          userList
              .where((element) => element.userId == chat.receiverId)
              .first
              .userName = chat.receiverName;
          userList
              .where((element) => element.userId == chat.receiverId)
              .first
              .lastMessageTime = chat.datetime;
          int unReadMessageCount = userList
              .where((element) => element.userId == chat.receiverId)
              .first
              .unreadMessagesCount;
          userList
              .where((element) => element.userId == chat.receiverId)
              .first
              .unreadMessagesCount = ++unReadMessageCount;

          //todo: check for unread message count
        } else {
          userIdList.add(chat.receiverId);
          userList.add(ChatUserModel(
            userId: chat.receiverId,
            userRegNo: chat.receiverRegNo,
            userName: chat.receiverName,
            userPhoneNo: chat.receiverNumber,
            lastMessage: chat.textMessage,
            lastMessageTime: chat.datetime,
            unreadMessagesCount: 0,
          ));
          //todo: check for unread message count
        }
      } else {
        if (userIdList.contains(chat.senderId)) {
          userList
              .where((element) => element.userId == chat.senderId)
              .first
              .lastMessage = chat.textMessage;
          userList
              .where((element) => element.userId == chat.senderId)
              .first
              .userName = chat.senderName;
          userList
              .where((element) => element.userId == chat.senderId)
              .first
              .lastMessageTime = chat.datetime;

          int unReadMessageCount = userList
              .where((element) => element.userId == chat.senderId)
              .first
              .unreadMessagesCount;
          userList
              .where((element) => element.userId == chat.senderId)
              .first
              .unreadMessagesCount = ++unReadMessageCount;
          //todo: check for unread message count
        } else {
          userIdList.add(chat.senderId);
          userList.add(ChatUserModel(
            userId: chat.senderId,
            userRegNo: chat.senderRegNo,
            userName: chat.senderName,
            userPhoneNo: chat.senderNumber,
            lastMessage: chat.textMessage,
            lastMessageTime: chat.datetime,
            unreadMessagesCount: 0,
          ));
          //todo: check for unread message count
        }
      }
    }

    userList.sort((a, b) {
      return b.lastMessageTime.compareTo(a.lastMessageTime);
    });

    chatUsersList = userList;
    // });

    isLoading = false;
    notifyListeners();
  }

  void selectUser(
      int index, BuildContext context, bool newChat, AuthUserModel userModel,
      {bool isscanned = false, bool isforwarded = false}) {
    if (newChat) {
      selectedUser = ChatUserModel(
        userId: userModel.id,
        userRegNo: userModel.userRegNo,
        userName: userModel.userName,
        userPhoneNo: userModel.userPhoneNumber,
        lastMessage: '',
        lastMessageTime: DateTime.now(),
        unreadMessagesCount: 0,
      );
      // chatUsersList.add(selectedUser!);
    } else {
      selectedUser = chatUsersList.elementAt(index);
    }
    notifyListeners();
    finalChatList.clear();

    if (isforwarded) {
      fetchChat(context);
      isscanned
          ? Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const ChatScreen(
                isGroupChat: false,
              ),
            ))
          : Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ChatScreen(isGroupChat: false),
            ));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const ChatScreen(isGroupChat: false),
      ));
    }
  }

  void fetchChatLocal(String senderId, String receiverId) {
    List<ChatModel> chatList = _messageHiveRepo.fetchById(senderId, receiverId);
    chatList.addAll(_messageHiveRepo.fetchById(receiverId, senderId));
    chatList.sort((a, b) {
      return a.datetime.compareTo(b.datetime);
    });
    finalChatList = chatList;
    log(finalChatList.toString());
    notifyListeners();
  }

  Future<void> fetchChat(BuildContext context) async {
    print('fetching chat');
    String userId = context.read<AuthProvider>().authUserModel!.id;
    fetchChatLocal(userId, selectedUser!.userId);
    List<ChatModel> chatList = [];
    chatList.addAll((await _chatRepo.fetchChatBySenderAndReceiver(
            userId, selectedUser!.userId))
        .cast<ChatModel>());
    chatList.addAll((await _chatRepo.fetchChatBySenderAndReceiver(
            selectedUser!.userId, userId))
        .cast<ChatModel>());

    chatList.sort((a, b) {
      return a.datetime.compareTo(b.datetime);
    });
    _messageHiveRepo.addMessages(chatList, true);
    finalChatList = chatList;
    notifyListeners();
  }

  Future<void> sendMessage(
      SendChatModel chatModel, BuildContext context) async {
    _messageHiveRepo.addMessages([ChatModel.fromMap(chatModel.toMap())], false);
    fetchChatUsersLocal(context);
    fetchChatLocal(chatModel.userSenderId, chatModel.userReceiverId);

    await _chatRepo.sendMessage(chatModel);

    await fetchChatUsers(context);
    await fetchChat(context);
    notifyListeners();
  }

  Future<void> sendEmoji(SendChatModel chatModel, BuildContext context) async {
    _messageHiveRepo.addMessages([ChatModel.fromMap(chatModel.toMap())], false);
    fetchChatUsersLocal(context);
    fetchChatLocal(chatModel.userSenderId, chatModel.userReceiverId);
    notifyListeners();
    await _chatRepo.sendEmoji(chatModel);
    notifyListeners();
    await fetchChatUsers(context);
    await fetchChat(context);
    notifyListeners();
  }

  Future<void> sendAudio(SendChatModel chatModel, BuildContext context) async {
    try {
      _messageHiveRepo
          .addMessages([ChatModel.fromMap(chatModel.toMap())], false);
      fetchChatUsersLocal(context);
      fetchChatLocal(chatModel.userSenderId, chatModel.userReceiverId);
      notifyListeners();
      await _chatRepo.sendAudio(
          chatModel.userSenderId,
          chatModel.userSenderRegNo,
          chatModel.userSenderNumber,
          chatModel.userSenderName,
          chatModel.userReceiverId,
          chatModel.userReceiverRegNo,
          chatModel.userReceiverNumber,
          chatModel.userReceiverName,
          chatModel.audioMessage);
      notifyListeners();
      await fetchChatUsers(context);
      await fetchChat(context);
      notifyListeners();
    } on Exception catch (e) {
      print(
        Exception(e),
      );
    }
  }

  Future<void> sendImage(SendChatModel chatModel, BuildContext context) async {
    try {
      _messageHiveRepo
          .addMessages([ChatModel.fromMap(chatModel.toMap())], false);
      fetchChatUsersLocal(context);
      fetchChatLocal(chatModel.userSenderId, chatModel.userReceiverId);

      await _chatRepo.sendImage(
          chatModel.userSenderId,
          chatModel.userSenderRegNo,
          chatModel.userSenderNumber,
          chatModel.userSenderName,
          chatModel.userReceiverId,
          chatModel.userReceiverRegNo,
          chatModel.userReceiverNumber,
          chatModel.userReceiverName,
          chatModel.imageMessage);

      await fetchChatUsers(context);
      await fetchChat(context);
      notifyListeners();
    } on Exception catch (e) {
      print(
        Exception(e),
      );
    }
  }

  Future<void> sendMultipleImages(
      SendChatModel chatModel, BuildContext context) async {
    try {
      _messageHiveRepo
          .addMessages([ChatModel.fromMap(chatModel.toMap())], false);
      fetchChatUsersLocal(context);
      fetchChatLocal(chatModel.userSenderId, chatModel.userReceiverId);

      await _chatRepo.sendImage(
          chatModel.userSenderId,
          chatModel.userSenderRegNo,
          chatModel.userSenderNumber,
          chatModel.userSenderName,
          chatModel.userReceiverId,
          chatModel.userReceiverRegNo,
          chatModel.userReceiverNumber,
          chatModel.userReceiverName,
          chatModel.imageMessage);

      await fetchChatUsers(context);
      await fetchChat(context);
      notifyListeners();
    } on Exception catch (e) {
      print(
        Exception(e),
      );
    }
  }

  Future<void> sendContact(
      SendChatModel chatModel, BuildContext context) async {
    try {
      _messageHiveRepo
          .addMessages([ChatModel.fromMap(chatModel.toMap())], false);
      fetchChatUsersLocal(context);
      fetchChatLocal(chatModel.userSenderId, chatModel.userReceiverId);

      await _chatRepo.sendContact(
          chatModel.userSenderId,
          chatModel.userSenderRegNo,
          chatModel.userSenderNumber,
          chatModel.userSenderName,
          chatModel.userReceiverId,
          chatModel.userReceiverRegNo,
          chatModel.userReceiverNumber,
          chatModel.userReceiverName,
          chatModel.contact);

      await fetchChatUsers(context);
      await fetchChat(context);
      notifyListeners();
    } on Exception catch (e) {
      print(
        Exception(e),
      );
    }
  }

  Future<void> sendLocation(
      SendChatModel chatModel, BuildContext context) async {
    try {
      _messageHiveRepo
          .addMessages([ChatModel.fromMap(chatModel.toMap())], false);
      fetchChatUsersLocal(context);
      fetchChatLocal(chatModel.userSenderId, chatModel.userReceiverId);

      await _chatRepo.sendLocation(
          chatModel.userSenderId,
          chatModel.userSenderRegNo,
          chatModel.userSenderNumber,
          chatModel.userSenderName,
          chatModel.userReceiverId,
          chatModel.userReceiverRegNo,
          chatModel.userReceiverNumber,
          chatModel.userReceiverName,
          chatModel.location);

      await fetchChatUsers(context);
      await fetchChat(context);
      notifyListeners();
    } on Exception catch (e) {
      print(
        Exception(e),
      );
    }
  }

  Future<void> sendDocFile(
      SendChatModel chatModel, BuildContext context) async {
    try {
      _messageHiveRepo
          .addMessages([ChatModel.fromMap(chatModel.toMap())], false);
      fetchChatUsersLocal(context);
      fetchChatLocal(chatModel.userSenderId, chatModel.userReceiverId);

      await _chatRepo.sendDoc(
        chatModel.userSenderId,
        chatModel.userSenderRegNo,
        chatModel.userSenderNumber,
        chatModel.userSenderName,
        chatModel.userReceiverId,
        chatModel.userReceiverRegNo,
        chatModel.userReceiverNumber,
        chatModel.userReceiverName,
        chatModel.fileMessage,
      );

      await fetchChatUsers(context);
      await fetchChat(context);
      notifyListeners();
    } on Exception catch (e) {
      print(
        Exception(e),
      );
    }
  }
}
