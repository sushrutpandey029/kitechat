import 'dart:developer';

import 'package:hive/hive.dart';

import '../../chat/model/chat_model.dart';
import '../hive_models/message_hive_model.dart';

class MessageHiveRepo {
  Future<void> addMessages(List<ChatModel> chatModelList, bool isClear) async {
    Box box = Hive.box<MessageHiveModel>('messages');
    if (isClear) {
      box.clear();
    }
    for (ChatModel chatModel in chatModelList) {
      MessageHiveModel messageHiveModel = MessageHiveModel()
        ..id = chatModel.id
        ..senderId = chatModel.senderId
        ..senderRegNo = chatModel.senderRegNo
        ..senderNumber = chatModel.senderNumber
        ..senderName = chatModel.senderName
        ..receiverId = chatModel.receiverId
        ..receiverRegNo = chatModel.receiverRegNo
        ..receiverNumber = chatModel.receiverNumber
        ..receiverName = chatModel.receiverName
        ..textMasseg = chatModel.textMessage
        ..datetime = chatModel.datetime
        ..massageStatus = chatModel.massageStatus
        ..imageMessage = chatModel.imageMessage
        ..audioMessage = chatModel.audioMessage;
      // ..documents = chatModel.documents
      // ..gallery = chatModel.gallery
      // ..contacts = chatModel.contacts
      // ..location = chatModel.location
      // ..memes = chatModel.memes;

      await box.add(messageHiveModel);
    }
    // box.clear();

// messageHiveModel.save();
  }

  List<ChatModel> fetchMessages() {
    Box<MessageHiveModel> box = Hive.box<MessageHiveModel>('messages');

    print('fetch message');
    // log(box.values.toList().toString());
    List<ChatModel> chatList = [];
    chatList
        .addAll(box.values.toList().map((e) => ChatModel.fromMap(e.toMap())));
    log(chatList.toString());
    return chatList;
  }

  void clearBox() {
    Box box = Hive.box<MessageHiveModel>('messages');
    box.clear();
  }

  List<ChatModel> fetchById(String senderId, String receiverId) {
    Box<MessageHiveModel> box = Hive.box<MessageHiveModel>('messages');
    List<MessageHiveModel> messageList = box.values.toList();
    List<ChatModel> chatList = [];

    for (var element in messageList) {
      if (element.senderId == senderId && element.receiverId == receiverId) {
        chatList.add(ChatModel.fromMap(element.toMap()));
      }
    }
    //  log(chatList.toString());
    return chatList;
  }
}
