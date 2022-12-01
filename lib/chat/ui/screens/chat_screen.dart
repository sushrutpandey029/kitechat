import 'dart:async';
import 'dart:io';
import 'package:audio_wave/audio_wave.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../authentication/model/auth_user_model.dart';
import '../../../authentication/provider/auth_provider.dart';
import '../../../shared/ui/widgets/custom_dialouge.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../util/custom_navigation.dart';
import '../../model/chat_model.dart';
import '../../model/chat_user_model.dart';
import '../../model/send_message_model.dart';
import '../../provider/chat_t_provider.dart';
import '../widgets/chat_app_bar_widget.dart';
import '../widgets/image_view.dart';
import '../widgets/message_tile_widget.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.isGroupChat, this.selectedUser})
      : super(key: key);
  final bool isGroupChat;
  final ChatUserModel? selectedUser;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;

  // final recorder = FlutterSoundRecorder();
  bool showEmoji = false;
  bool haveText = false;
  bool isAttaching = false;
  bool isbanner = false;
  bool istop = false;
  String statusText = "";

  final TextEditingController messageController = TextEditingController();

  PhoneContact? _phoneContact;
  bool? _serviceEnabled;
  LocationPermission? permission;
  Position? _locationData;

  TextEditingController textEditingController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      statusText = "Recording...";
      recordFilePath = await getFilePath();

      RecordMp3.instance.start(recordFilePath!, (type) {
        statusText = "Record error--->$type";
        setState(() {});
      });
    } else {
      statusText = "No microphone permission";
    }
    setState(() {});
  }

  void pauseRecord() {
    if (RecordMp3.instance.status == RecordStatus.PAUSE) {
      bool s = RecordMp3.instance.resume();
      if (s) {
        statusText = "Recording...";
        setState(() {});
      }
    } else {
      bool s = RecordMp3.instance.pause();
      if (s) {
        statusText = "Recording pause...";
        setState(() {});
      }
    }
  }

  bool stopRecord() {
    bool s = RecordMp3.instance.stop();
    if (s) {
      statusText = "Record complete";

      setState(() {});
    }
    return s;
  }

  void resumeRecord() {
    bool s = RecordMp3.instance.resume();
    if (s) {
      statusText = "Recording...";
      setState(() {});
    }
  }

  String? recordFilePath;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = "${storageDirectory.path}/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return "$sdPath/audio_${DateTime.now().toIso8601String()}.mp3";
  }

  // Future record() async {
  //   if (!isRecorderReady) {
  //     return;
  //   }
  //   await recorder.startRecorder(
  //     toFile: 'audio',
  //   );
  // }

  // Future<String> stop() async {
  //   // print(await recorder.stopRecorder());
  //   if (!isRecorderReady) {
  //     return '';
  //   }
  //   final path = await recorder.stopRecorder();

  //   print('recorded audiopath:$path');
  //   return path!;
  // }

//  void startRecord() async {
//     bool hasPermission = await checkPermission();
//     if (hasPermission) {
//       statusText = "Recording...";
//       recordFilePath = await getFilePath();
//       isComplete = false;
//       RecordMp3.instance.start(recordFilePath, (type) {
//         statusText = "Record error--->$type";
//         setState(() {});
//       });
//     } else {
//       statusText = "No microphone permission";
//     }
//     setState(() {});
//   }
//   Future initRecorder() async {
//     _askPermissions();
//   }

  // Future<void> _askPermissions() async {
  //   PermissionStatus permissionStatus = await _getMicrophonePermission();
  //   if (permissionStatus == PermissionStatus.granted) {
  //     // await recorder.openAudioSession();
  //     // isRecorderReady = true;
  //   } else {
  //     _handleInvalidPermissions(permissionStatus);
  //   }
  // }

  // Future<PermissionStatus> _getMicrophonePermission() async {
  //   PermissionStatus permission = await Permission.microphone.request();
  //   if (permission != PermissionStatus.granted &&
  //       permission != PermissionStatus.permanentlyDenied) {
  //     PermissionStatus permissionStatus = await Permission.microphone.request();
  //     return permissionStatus;
  //   } else {
  //     return permission;
  //   }
  // }

  // void _handleInvalidPermissions(PermissionStatus permissionStatus) {
  //   if (permissionStatus == PermissionStatus.denied) {
  //   } else if (permissionStatus == PermissionStatus.permanentlyDenied) {}
  // }

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
        final message = ChatModel.fromMap(data);
        if (message.imageMessage != '') {
          Provider.of<ChatTProvider>(context, listen: false)
              .fetchChat(context, isfetchmedia: true);
        } else if (message.audioMessage != '') {
          Provider.of<ChatTProvider>(context, listen: false)
              .fetchChat(context, isfetchmedia: true);
        } else {
          Provider.of<ChatTProvider>(context, listen: false)
              .addmessages(message);
        }
      });
    });
    socket.onConnectError((data) => print('Connection Error: $data'));
    socket.onDisconnect((data) => print('Socket.IO server disconnected'));
  }

  @override
  void initState() {
    connectSocket();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          isbanner = false;
        });
      }
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        setState(() {
          isbanner = true;
          istop = !istop;
        });
      }
      // if (_scrollController.offset == 0.0) {
      //   setState(() {
      //     isbanner = true;
      //   });
      // }
    });
    messageController.addListener(() {
      if (messageController.text == '') {
        setState(() {
          haveText = false;
        });
      } else {
        setState(() {
          haveText = true;
        });
      }
    });

    super.initState();
  }

  void sendmessage(
    SendChatModel chatModel,
  ) async {
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
    Provider.of<ChatTProvider>(context, listen: false)
        .addmessages(ChatModel.fromMap(msg));
    await Provider.of<ChatTProvider>(context, listen: false)
        .sendMessage(chatModel);
  }

  String renderMessage(ChatModel chatMessage) {
    if (chatMessage.imageMessage != '') {
      return chatMessage.imageMessage;
    } else if (chatMessage.audioMessage != '') {
      return chatMessage.audioMessage;
    } else if (chatMessage.fileMessage != '') {
      return chatMessage.fileMessage;
    } else if (chatMessage.contact != '') {
      return chatMessage.contact;
    } else if (chatMessage.location != '') {
      return chatMessage.location;
    } else {
      return chatMessage.textMessage;
    }
  }

  String findType(var chatMessage) {
    if (chatMessage.contact != '') {
      return 'contact';
    } else if (chatMessage.location != '') {
      return 'location';
    } else if (chatMessage.audioMessage != '') {
      return 'audio';
    } else if (chatMessage.imageMessage != '') {
      return 'image';
    } else if (chatMessage.fileMessage != '') {
      return 'file';
    } else {
      return 'text';
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: chatAppBar(context, socket),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Consumer<ChatTProvider>(builder: (context, value, widget) {
          return Column(
            children: [
              isbanner
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromRGBO(155, 184, 234, 1)),
                        child: Row(
                          children: const [
                            Icon(Icons.lock),
                            SizedBox(
                              width: 2,
                            ),
                            Expanded(
                              child: Text(
                                'Messages and calls are end-to-end encrypted. No one outside of this chat, not even Kite, can read or listen to them.',
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  dragStartBehavior: DragStartBehavior.down,
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: value.chats.length,
                  padding: !istop ? null : EdgeInsets.only(top: 5.h),
                  itemBuilder: ((context, index) {
                    // if (value.finalChatList.length == index) {
                    //   setState(() {
                    //     isbanner = false;
                    //   });
                    // }
                    index = value.chats.length - index - 1;
                    return MessageTileWidget(
                      type: findType(value.chats.elementAt(index)),
                      message: renderMessage(value.chats.elementAt(index)),
                      time: DateFormat.jm()
                          .format(value.chats.elementAt(index).datetime),
                      isByUser: value.chats.elementAt(index).senderId ==
                          context.read<AuthProvider>().authUserModel!.id,
                      recievernumber:
                          value.chats.elementAt(index).receiverNumber,
                      isContinue: index == 0 ||
                          value.chats.elementAt(index - 1).senderId ==
                              value.chats.elementAt(index).senderId,
                      chatid: int.parse(value.chats.elementAt(index).id),
                    );
                  }),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              isAttaching ? attachmenttray(value) : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    elevation: 10,
                    color: const Color.fromARGB(255, 210, 210, 210),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.sp),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                showEmoji = !showEmoji;
                              });
                            },
                            icon: const Icon(Icons.emoji_emotions_outlined)),
                        SizedBox(
                          width: haveText ? 51.w : 43.w,
                          child: RecordMp3.instance.status ==
                                  RecordStatus.RECORDING
                              ? AudioWave(
                                  height: 32,
                                  width: 20,
                                  spacing: 2.5,
                                  alignment: 'right',
                                  animationLoop: 2,
                                  beatRate: const Duration(milliseconds: 1000),
                                  bars: [
                                    AudioWaveBar(
                                        heightFactor: 0.9,
                                        color: Colors.lightBlueAccent),
                                    AudioWaveBar(
                                        heightFactor: 0.3, color: Colors.blue),
                                    AudioWaveBar(
                                        heightFactor: 0.5, color: Colors.black),
                                  ],
                                )
                              : TextField(
                                  maxLines: 4,
                                  minLines: 1,
                                  controller: messageController,
                                  decoration: const InputDecoration(
                                      hintText: 'Message',
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none),
                                ),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                isAttaching = !isAttaching;
                              });
                            },
                            icon: const Icon(Icons.attach_file)),
                        if (!haveText)
                          if (!haveText)
                            IconButton(
                                onPressed: () async {
                                  final XFile? captureImg = await ImagePicker()
                                      .pickImage(source: ImageSource.camera);
                                  if (captureImg != null) {
                                    customNavigator(
                                        context,
                                        ImageView(
                                          isSendImage: true,
                                          imagefile: captureImg,
                                          value: value,
                                          messageController: messageController,
                                          socket: socket,
                                        ));
                                  }
                                },
                                icon: const Icon(Icons.camera_alt_outlined)),
                      ],
                    ),
                  ),
                  if (!haveText)
                    CircleAvatar(
                      radius: 20.sp,
                      child: IconButton(
                        onPressed: () async {
                          if (RecordMp3.instance.status ==
                              RecordStatus.RECORDING) {
                            stopRecord();
                            if (recordFilePath != "") {
                              AuthUserModel userModel =
                                  context.read<AuthProvider>().authUserModel!;
                              await Future.delayed(const Duration(seconds: 2),
                                  () async {
                                SendChatModel chatModel = SendChatModel(
                                  userSenderId: userModel.id,
                                  userSenderName: userModel.userName,
                                  userSenderNumber: userModel.userPhoneNumber,
                                  userSenderRegNo: userModel.userRegNo,
                                  userReceiverId: value.selectedUser!.userId,
                                  userReceiverName:
                                      value.selectedUser!.userName,
                                  userReceiverRegNo:
                                      value.selectedUser!.userRegNo,
                                  userReceiverNumber:
                                      value.selectedUser!.userPhoneNo,
                                  textMessage: messageController.text,
                                  emojiMessage: "",
                                  imageMessage: '',
                                  fileMessage: '',
                                  contact: '',
                                  location: '',
                                  audioMessage: recordFilePath!,
                                );
                                await value.sendAudio(chatModel);
                                final msg = {
                                  "text_masseg": chatModel.textMessage,
                                  "sender_id": chatModel.userSenderId,
                                  "reciever_id": chatModel.userReceiverId,
                                  "sender_reg_no": chatModel.userSenderRegNo,
                                  "sender_number": chatModel.userSenderNumber,
                                  "sender_name": chatModel.userSenderName,
                                  "reciever_reg_no":
                                      chatModel.userReceiverRegNo,
                                  "reciever_number":
                                      chatModel.userReceiverNumber,
                                  "reciever_name": chatModel.userReceiverName,
                                  "mems": chatModel.emojiMessage,
                                  "datetime": DateTime.now().toIso8601String(),
                                  "file_msg": chatModel.imageMessage,
                                  "voice_record_msg": chatModel.audioMessage,
                                  "user_location": chatModel.location,
                                  "contacts": chatModel.contact,
                                };
                                socket.emit("send-msg", msg);
                                value.fetchChat(context, isfetchmedia: true);
                              });
                            }
                          } else {
                            startRecord();
                          }
                          setState(() {});
                        },
                        icon: Icon(
                            RecordMp3.instance.status == RecordStatus.RECORDING
                                ? Icons.stop
                                : Icons.mic),
                      ),
                    ),
                  if (haveText)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: const CircleBorder(),
                          padding: EdgeInsets.all(14.sp)),
                      onPressed: () {
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
                            textMessage: messageController.text,
                            emojiMessage: "",
                            imageMessage: '',
                            fileMessage: '',
                            audioMessage: '',
                            location: '',
                            contact: '');
                        sendmessage(chatModel);
                        messageController.clear();
                        FocusScope.of(context).unfocus();
                      },
                      child: const Icon(Icons.send),
                    )
                ],
              ),
              showEmoji ? Expanded(child: selectEmoji()) : const SizedBox(),
              const SizedBox(),
            ],
          );
        }),
      ),
    );
  }

  Widget selectEmoji() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: EmojiPicker(
        config: const Config(bgColor: Colors.white, columns: 8),
        textEditingController: messageController,
        onBackspacePressed: () {},
        onEmojiSelected: (category, emoji) {},
      ),
    );
  }

  Widget attachmenttray(ChatTProvider value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w + 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              CircleAvatar(
                child: IconButton(
                  onPressed: (() async {
                    // Pick an image
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(type: FileType.image, allowMultiple: true);
                    if (result != null) {
                      List<File> files =
                          result.paths.map((path) => File(path!)).toList();
                      customNavigator(
                          context,
                          ImageView(
                            isSendImage: true,
                            imageFiles: files,
                            value: value,
                            messageController: messageController,
                            socket: socket,
                          ));

                      setState(() {
                        isAttaching = !isAttaching;
                      });
                    }
                  }),
                  icon: const Icon(Icons.image),
                  iconSize: 20,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 0.5.h),
                child: const Text(
                  "Gallery",
                ),
              ),
            ],
          ),
          Column(
            children: [
              kIsWeb && !FlutterContactPicker.available
                  ? const SizedBox()
                  : CircleAvatar(
                      // backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: () async {
                          final PhoneContact contact =
                              await FlutterContactPicker.pickPhoneContact();

                          setState(() {
                            _phoneContact = contact;
                          });
                          if (_phoneContact != null) {
                            PhoneNumber? phoneNum = _phoneContact!.phoneNumber;
                            String? contactName = _phoneContact!.fullName;
                            String? phoneNumber = phoneNum!.number;
                            print("phoneNumber - $phoneNumber");
                            print("contactName - $contactName");
                            AuthUserModel userModel =
                                context.read<AuthProvider>().authUserModel!;
                            SendChatModel chatModel = SendChatModel(
                                userSenderId: userModel.id,
                                userSenderName: userModel.userName,
                                userSenderNumber: userModel.userPhoneNumber,
                                userSenderRegNo: userModel.userRegNo,
                                userReceiverId: value.selectedUser!.userId,
                                userReceiverName: value.selectedUser!.userName,
                                userReceiverRegNo:
                                    value.selectedUser!.userRegNo,
                                userReceiverNumber:
                                    value.selectedUser!.userPhoneNo,
                                textMessage: "",
                                emojiMessage: "",
                                imageMessage: '',
                                fileMessage: '',
                                audioMessage: '',
                                location: '',
                                contact: '$contactName: $phoneNumber');
                            setState(() {
                              isAttaching = !isAttaching;
                            });
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
                            await value.sendContact(
                              chatModel,
                            );
                          }
                        },
                        icon: const Icon(Icons.person),
                        iconSize: 20,
                      ),
                    ),
              Container(
                margin: EdgeInsets.only(top: 0.5.h),
                child: const Text("Contacts"),
              ),
            ],
          ),
          Column(
            children: [
              CircleAvatar(
                // backgroundColor: Colors.white,
                child: IconButton(
                  onPressed: (() async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(type: FileType.image, allowMultiple: true);
                    if (result != null) {
                      List<File> files =
                          result.paths.map((path) => File(path!)).toList();
                      AuthUserModel userModel =
                          context.read<AuthProvider>().authUserModel!;
                      for (var file in files) {
                        SendChatModel chatModel = SendChatModel(
                          userSenderId: userModel.id,
                          userSenderName: userModel.userName,
                          userSenderNumber: userModel.userPhoneNumber,
                          userSenderRegNo: userModel.userRegNo,
                          userReceiverId: value.selectedUser!.userId,
                          userReceiverName: value.selectedUser!.userName,
                          userReceiverRegNo: value.selectedUser!.userRegNo,
                          userReceiverNumber: value.selectedUser!.userPhoneNo,
                          textMessage: messageController.text,
                          emojiMessage: "",
                          imageMessage: '',
                          fileMessage: file.path,
                          audioMessage: '',
                          contact: '',
                          location: '',
                        );

                        await value.sendDocFile(chatModel);
                        print("sent file - ${file.path}");
                      }
                    } else {
                      // User canceled the picker
                    }
                    setState(() {
                      isAttaching = !isAttaching;
                    });
                  }),
                  icon: const Icon(Icons.description),
                  iconSize: 20,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 0.5.h),
                child: const Text("Files"),
              ),
            ],
          ),
          Column(
            children: [
              CircleAvatar(
                // backgroundColor: Colors.white,
                child: IconButton(
                  onPressed: (() async {
                    await getcurrentlocation();
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
                        textMessage: messageController.text,
                        emojiMessage: "",
                        imageMessage: '',
                        fileMessage: '',
                        audioMessage: '',
                        location:
                            '${_locationData!.latitude},${_locationData!.longitude}',
                        contact: '');
                    setState(() {
                      isAttaching = !isAttaching;
                    });
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
                    await value.sendLocation(chatModel);
                  }),
                  icon: const Icon(Icons.near_me),
                  iconSize: 20,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 0.5.h),
                child: const Text("Location"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> getcurrentlocation() async {
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled!) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    _locationData = await Geolocator.getCurrentPosition();
  }
}
