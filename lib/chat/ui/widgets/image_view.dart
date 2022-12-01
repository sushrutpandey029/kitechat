import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../../authentication/model/auth_user_model.dart';
import '../../../authentication/provider/auth_provider.dart';
import '../../model/chat_model.dart';
import '../../model/send_message_model.dart';

import '../../provider/chat_t_provider.dart';

class ImageView extends StatefulWidget {
  final bool isSendImage;
  final String? imgUrl;
  final XFile? imagefile;
  final ChatTProvider? value;
  final TextEditingController? messageController;
  final List<File>? imageFiles;
  final Socket? socket;
  const ImageView(
      {this.imgUrl,
      required this.isSendImage,
      this.imagefile,
      this.value,
      this.messageController,
      this.imageFiles,
      this.socket,
      super.key});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Consumer<ChatTProvider>(
          builder: (context, value, widget) {
            return Text(value.selectedUser!.userName);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.star_border_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share),
          ),
          widget.imgUrl != null
              ? IconButton(
                  onPressed: () async {
                    final saved = await GallerySaver.saveImage(widget.imgUrl!,
                        albumName: 'Kite');
                    print(saved);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Downloaded To gallery')));
                  },
                  icon: const Icon(Icons.download),
                )
              : IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
                ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SizedBox(
          //   height: .h,
          // ),
          widget.imgUrl != null
              ? Image.network(
                  widget.imgUrl!,
                  height: 82.h,
                  alignment: Alignment.center,
                )
              : widget.imageFiles != null
                  ? Expanded(
                      child: Stack(
                        children: [
                          PageView(
                            children: widget.imageFiles!.map((imageone) {
                              return SizedBox(
                                height: 85.h,
                                child: Image.file(
                                  File(imageone.path),
                                  height: 85.h,
                                ),
                              );
                            }).toList(),
                          ),
                          Positioned(
                            left: 20,
                            top: 20,
                            child: Text(
                              'Total Images: ${widget.imageFiles!.length.toString()}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Image.file(
                      File(widget.imagefile!.path),
                      height: 85.h,
                    ),
        ],
      ),
      floatingActionButton: widget.isSendImage
          ? FloatingActionButton(
              onPressed: () async {
                setState(() {
                  isloading = true;
                });
                AuthUserModel userModel =
                    context.read<AuthProvider>().authUserModel!;
                if (widget.imageFiles != null) {
                  for (var file in widget.imageFiles!) {
                    SendChatModel chatModel = SendChatModel(
                        userSenderId: userModel.id,
                        userSenderName: userModel.userName,
                        userSenderNumber: userModel.userPhoneNumber,
                        userSenderRegNo: userModel.userRegNo,
                        userReceiverId: widget.value!.selectedUser!.userId,
                        userReceiverName: widget.value!.selectedUser!.userName,
                        userReceiverRegNo:
                            widget.value!.selectedUser!.userRegNo,
                        userReceiverNumber:
                            widget.value!.selectedUser!.userPhoneNo,
                        textMessage: widget.messageController!.text,
                        emojiMessage: "",
                        imageMessage: file.path,
                        fileMessage: '',
                        audioMessage: '',
                        location: '',
                        contact: '');
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
                      "file_msg": chatModel.imageMessage,
                      "voice_record_msg": chatModel.audioMessage,
                      "user_location": chatModel.location,
                      "contacts": chatModel.contact,
                    };

                    await widget.value!.sendImage(chatModel);
                    widget.socket!.emit("send-msg", msg);
                    widget.value!.fetchChat(context, isfetchmedia: true);
                  }
                  Navigator.of(context).pop();
                } else {
                  SendChatModel chatModel = SendChatModel(
                      userSenderId: userModel.id,
                      userSenderName: userModel.userName,
                      userSenderNumber: userModel.userPhoneNumber,
                      userSenderRegNo: userModel.userRegNo,
                      userReceiverId: widget.value!.selectedUser!.userId,
                      userReceiverName: widget.value!.selectedUser!.userName,
                      userReceiverRegNo: widget.value!.selectedUser!.userRegNo,
                      userReceiverNumber:
                          widget.value!.selectedUser!.userPhoneNo,
                      textMessage: widget.messageController!.text,
                      emojiMessage: "",
                      imageMessage: widget.imagefile!.path,
                      fileMessage: '',
                      audioMessage: '',
                      location: '',
                      contact: '');
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
                    "file_msg": chatModel.imageMessage,
                    "voice_record_msg": chatModel.audioMessage,
                    "user_location": chatModel.location,
                    "contacts": chatModel.contact,
                  };

                  await widget.value!.sendImage(chatModel).then((value) {
                    widget.socket!.emit("send-msg", msg);
                    widget.value!.fetchChat(context, isfetchmedia: true);
                    Navigator.of(context).pop();
                  });
                }

                if (mounted) {
                  setState(() {
                    isloading = true;
                  });
                }
              },
              child: isloading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Icon(Icons.send),
            )
          : null,
    );
  }
}
