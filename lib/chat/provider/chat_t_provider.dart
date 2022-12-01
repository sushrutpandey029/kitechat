import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../authentication/model/auth_user_model.dart';
import '../../authentication/provider/auth_provider.dart';
import '../model/chat_model.dart';
import '../model/chat_user_model.dart';
import '../model/send_message_model.dart';
import '../repository/chat_repo.dart';
import '../ui/screens/chat_screen.dart';

class ChatTProvider extends ChangeNotifier {
  ChatUserModel? selectedUser;

  final List<ChatModel> _chats = [];
  List<ChatModel> get chats => [..._chats];
  final ChatRepo _chatRepo = ChatRepo();
  List<ChatUserModel> chatUsersList = [];
  bool isLoading = false;

  void addmessages(ChatModel recievedchat) async {
    _chats.add(recievedchat);
    notifyListeners();
  }

  Future<void> fetchChatUsers(BuildContext context) async {
    List<ChatModel>? chatList;
    isLoading = true;

    String userId = context.read<AuthProvider>().authUserModel!.id;
    chatList = (await _chatRepo.fetchChatBySenderId(userId)).cast<ChatModel>();
    chatList.addAll(
        (await _chatRepo.fetchChatByReceiverId(userId)).cast<ChatModel>());
    chatList.sort((a, b) {
      return a.datetime.compareTo(b.datetime);
    });
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

    isLoading = false;
    notifyListeners();
  }

  void selectUser(
      BuildContext context, int index, bool newChat, AuthUserModel userModel,
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
    } else {
      selectedUser = chatUsersList.elementAt(index);
    }
    notifyListeners();
    _chats.clear();
    fetchChat(context);
    if (isforwarded) {
      if (isscanned) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ChatScreen(
            isGroupChat: false,
            selectedUser: selectedUser,
          ),
        ));
      } else {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ChatScreen(
            isGroupChat: false,
            selectedUser: selectedUser,
          ),
        ));
      }
    } else {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ChatScreen(
          isGroupChat: false,
          selectedUser: selectedUser,
        ),
      ));
    }
  }

  Future<void> fetchChat(BuildContext context,
      {bool isfetchmedia = false}) async {
    print('fetching chat');
    String userId = context.read<AuthProvider>().authUserModel!.id;
    try {
      if (isfetchmedia) {
        _chats.clear();
      }
      List<ChatModel> chatList = [];
      chatList.addAll((await _chatRepo.fetchChatBySenderAndReceiver(
              userId, selectedUser!.userId))
          .cast<ChatModel>());

      _chats.addAll(chatList);
      notifyListeners();
    } on Exception catch (e) {
      print(
        Exception(e),
      );
    }
  }

  Future<void> sendMessage(
    SendChatModel chatModel,
  ) async {
    try {
      await _chatRepo.sendMessage(chatModel);
    } on Exception catch (e) {
      print(
        Exception(e),
      );
    }

    notifyListeners();
  }

  Future<void> deleteMessage(int chatid) async {
    try {
      await _chatRepo.deletemessage(chatid);
      _chats.removeWhere((element) => element.id == chatid.toString());
    } on Exception catch (e) {
      print(
        Exception(e),
      );
    }

    notifyListeners();
  }

  Future<void> sendEmoji(
    SendChatModel chatModel,
  ) async {
    try {
      await _chatRepo.sendEmoji(chatModel);
    } on Exception catch (e) {
      print(
        Exception(e),
      );
    }

    notifyListeners();
  }

  Future<void> sendAudio(
    SendChatModel chatModel,
  ) async {
    try {
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
    } on Exception catch (e) {
      print(
        Exception(e),
      );
    }
  }

  Future<void> sendImage(
    SendChatModel chatModel,
  ) async {
    try {
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

      notifyListeners();
    } on Exception catch (e) {
      print(
        Exception(e),
      );
    }
  }

  Future<void> sendMultipleImages(
    SendChatModel chatModel,
  ) async {
    try {
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

      notifyListeners();
    } on Exception catch (e) {
      print(
        Exception(e),
      );
    }
  }

  Future<void> sendContact(
    SendChatModel chatModel,
  ) async {
    try {
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

      notifyListeners();
    } on Exception catch (e) {
      print(
        Exception(e),
      );
    }
  }

  Future<void> sendLocation(
    SendChatModel chatModel,
  ) async {
    try {
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

      notifyListeners();
    } on Exception catch (e) {
      print(
        Exception(e),
      );
    }
  }

  Future<void> sendDocFile(SendChatModel chatModel) async {
    try {
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

      notifyListeners();
    } on Exception catch (e) {
      print(
        Exception(e),
      );
    }
  }
}
