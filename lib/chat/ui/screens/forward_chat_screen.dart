import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../authentication/model/auth_user_model.dart';
import '../../../authentication/provider/auth_provider.dart';
import '../../../shared/ui/widgets/custom_app_bar.dart';
import '../../model/chat_model.dart';
import '../../model/send_message_model.dart';
import '../../provider/chat_provider.dart';
import '../../provider/chat_t_provider.dart';
import 'chat_screen.dart';

class ForwardChatScreen extends StatefulWidget {
  const ForwardChatScreen({
    super.key,
    required this.message,
    required this.type,
  });
  final String message;
  final String type;

  @override
  State<ForwardChatScreen> createState() => _ForwardChatScreenState();
}

class _ForwardChatScreenState extends State<ForwardChatScreen> {
  late IO.Socket socket;
  void connectSocket() {
    socket = IO.io(
      'https://kitemsg.herokuapp.com/',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );
    socket.connect();
    socket.emit(
      "/test",
      context.read<AuthProvider>().authUserModel!.id,
    );
    socket.onConnect((data) {
      print('Connection established- ${socket.id}');
      socket.on("msg-recieve", (data) {
        print(data);
        Provider.of<ChatTProvider>(context, listen: false)
            .addmessages(ChatModel.fromMap(data));
      });
    });
    socket.onConnectError((data) => print('Connection Error: $data'));
    socket.onDisconnect((data) => print('Socket.IO server disconnected'));
  }

  @override
  void initState() {
    connectSocket();
    super.initState();
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final message = widget.message;
    final type = widget.type;
    return Scaffold(
      appBar: customAppBar('Forward to..', backButton: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
            ),
            child: Text(
              'Recent Chats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1.5,
            height: 10,
            indent: 20,
            endIndent: 20,
          ),
          Consumer<ChatTProvider>(builder: (context, value, widget) {
            return Expanded(
              child: ListView.builder(
                itemCount: value.chatUsersList.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 4,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onTap: () async {
                        //todo : remove this 
                        value.selectUser(
                            context,
                            index,
                            false,
                            AuthUserModel(
                              id: '',
                              userRegNo: '',
                              country: '',
                              userPhoneNumber: '',
                              userImage: '',
                              userName: '',
                              userBio: '',
                              userDob: DateTime.now(),
                              userCreateDateTime: DateTime.now(),
                              userIpAddress: '',
                              userPhoneName: '',
                              userStatus: '',
                              userFcm: '',
                              userUid: '',
                            ),
                            isforwarded: true);
                        AuthUserModel userModel =
                            context.read<AuthProvider>().authUserModel!;

                        SendChatModel chatModel = SendChatModel(
                            userSenderId: userModel.id,
                            userSenderName: userModel.userName,
                            userSenderNumber: userModel.userPhoneNumber,
                            userSenderRegNo: userModel.userRegNo,
                            userReceiverId: value.selectedUser!.userId,
                            userReceiverName: value.selectedUser!.userName,
                            userReceiverRegNo: value.selectedUser!.userRegNo,
                            userReceiverNumber: value.selectedUser!.userPhoneNo,
                            textMessage: type == 'text' ? this.widget.message : '',
                            emojiMessage: '',
                            imageMessage: type == 'image' ?  this.widget.message : '',
                            fileMessage: type == 'file' ?  this.widget.message : '',
                            audioMessage: type == 'audio' ?  this.widget.message : '',
                            location: type == 'location' ?  this.widget.message : '',
                            contact: type == 'conatact' ?  this.widget.message : '');
                        await value.sendMessage(chatModel);
                        final msg = {
                          "text_masseg": chatModel.textMessage,
                          "sender_id": chatModel.userSenderId,
                          "reciever_id": chatModel.userReceiverId,
                          "sender_reg_no": chatModel.userSenderRegNo,
                          "sender_number": chatModel.userSenderNumber,
                          "sender_name": chatModel.userSenderName,
                          "reciever_reg_no": chatModel.userReceiverRegNo,
                          "reciever_number": chatModel.userReceiverNumber,
                          "reciever_name": chatModel.userReceiverName,
                          "mems": chatModel.emojiMessage,
                          "datetime": DateTime.now().toIso8601String(),
                          "file_msg": chatModel.fileMessage,
                          "voice_record_msg": chatModel.audioMessage,
                          "user_location": chatModel.location,
                          "contacts": chatModel.contact,
                        };

                        socket.emit("send-msg", msg);
                        value.addmessages(ChatModel.fromMap(msg));
                      },
                      contentPadding: EdgeInsets.only(left: 2.w),
                      tileColor: const Color.fromARGB(255, 231, 231, 231),
                      leading: CircleAvatar(
                        radius: 20.sp,
                        child: const Icon(Icons.person),
                      ),
                      title:
                          Text(value.chatUsersList.elementAt(index).userName),
                      trailing: Padding(
                        padding: EdgeInsets.only(right: 4.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              DateFormat.jm().format(value.chatUsersList
                                  .elementAt(index)
                                  .lastMessageTime),
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            // SizedBox(
                            //   height: 2.75.h,
                            //   child: value.chatUsersList
                            //               .elementAt(index)
                            //               .unreadMessagesCount ==
                            //           0
                            //       ? null
                            //       : CircleAvatar(
                            //           child: Text(
                            //               value.chatUsersList
                            //                   .elementAt(index)
                            //                   .unreadMessagesCount
                            //                   .toString(),
                            //               style: TextStyle(fontSize: 14.sp)),
                            //         ),
                            // )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
