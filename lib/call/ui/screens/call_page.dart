import 'dart:developer';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../../authentication/model/auth_user_model.dart';
import '../../../authentication/provider/auth_provider.dart';
import '../../../chat/model/chat_model.dart';
import '../../../chat/model/chat_user_model.dart';
import '../../../chat/model/send_message_model.dart';
import '../../../chat/provider/chat_provider.dart';
import '../../../chat/provider/chat_t_provider.dart';
import 'provider/video_call_provider.dart';

enum CallStatus { calling, accepted, ringing }

class CallPage extends StatefulWidget {
  final ChatUserModel? calleeDeatails;
  final String calleeNumber;
  final CallStatus? callStatus;
  final bool isvideo;
  final Socket? socket;

  const CallPage({
    Key? key,
    required this.calleeNumber,
    this.calleeDeatails,
    this.callStatus,
    required this.isvideo,
    this.socket,
  }) : super(key: key);

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  // final AgoraTokenRepo _tokenRepo = AgoraTokenRepo();
  final AgoraClient agoraClient = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      // uid: int.parse( context.read<AuthProvider>().authUserModel!.id),
      appId: 'a0999c11fe3b4b1a988fe04850510fb9',
      channelName: 'test',
    ),
    enabledPermission: [Permission.camera, Permission.microphone],
  );
  CallStatus? callStatus;
  bool isLoading = true;
  AuthUserModel? userModel;
  bool isvideo = true;
  @override
  void initState() {
    callStatus = widget.callStatus ?? CallStatus.calling;
    isvideo = widget.isvideo;

    // getcalluser();
    initialiseSignals();

    super.initState();
  }

  void initAgora() async {
   
    await agoraClient.initialize();
  }
  // getcalluser() async {
  //   await context.read<AuthProvider>().getUserForCall(widget.calleeNumber).then(
  //       (value) =>
  //           userModel = context.read<AuthProvider>().authUserModelForCall!);
  // }

  initialiseSignals() async {
    initAgora();
    AuthUserModel userSenderModel = context.read<AuthProvider>().authUserModel!;

    if (callStatus == CallStatus.calling) {
      // videoToken = await _tokenRepo.generateToken(userSenderModel.userIpAddress,
      //     int.parse(userSenderModel.id), context);

      // await Provider.of<VideoCallProvider>(context, listen: false)
      //     .connectCall(context, widget.calleeNumber);

      if (isvideo) {
        SendChatModel chatModel = SendChatModel(
            userSenderId: userSenderModel.id,
            userSenderName: userSenderModel.userName,
            userSenderNumber: userSenderModel.userPhoneNumber,
            userSenderRegNo: userSenderModel.userRegNo,
            userReceiverId: widget.calleeDeatails!.userId,
            userReceiverName: widget.calleeDeatails!.userName,
            userReceiverRegNo: widget.calleeDeatails!.userRegNo,
            userReceiverNumber: widget.calleeDeatails!.userPhoneNo,
            textMessage: 'JOIN VIDEO CALL: ${widget.calleeNumber}',
            emojiMessage: "",
            imageMessage: '',
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
          "file_msg": chatModel.fileMessage,
          "voice_record_msg": chatModel.audioMessage,
          "user_location": chatModel.location,
          "contacts": chatModel.contact,
        };
        widget.socket!.emit("send-msg", msg);
        Provider.of<ChatTProvider>(context, listen: false)
            .addmessages(ChatModel.fromMap(msg));
        await context.read<ChatTProvider>().sendMessage(chatModel);
      } else {
        SendChatModel chatModel = SendChatModel(
            userSenderId: userSenderModel.id,
            userSenderName: userSenderModel.userName,
            userSenderNumber: userSenderModel.userPhoneNumber,
            userSenderRegNo: userSenderModel.userRegNo,
            userReceiverId: widget.calleeDeatails!.userId,
            userReceiverName: widget.calleeDeatails!.userName,
            userReceiverRegNo: widget.calleeDeatails!.userRegNo,
            userReceiverNumber: widget.calleeDeatails!.userPhoneNo,
            textMessage: 'JOIN VOICE CALL: ${widget.calleeNumber}',
            emojiMessage: "",
            imageMessage: '',
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
          "file_msg": chatModel.fileMessage,
          "voice_record_msg": chatModel.audioMessage,
          "user_location": chatModel.location,
          "contacts": chatModel.contact,
        };
        widget.socket!.emit("send-msg", msg);
        Provider.of<ChatTProvider>(context, listen: false)
            .addmessages(ChatModel.fromMap(msg));
        await agoraClient.sessionController.value.engine!.disableVideo();
        await context.read<ChatTProvider>().sendMessage(chatModel);
      }

      try {
        HttpsCallable callable =
            FirebaseFunctions.instance.httpsCallable('sendCallNotification');
        final response = await callable.call(<String, dynamic>{
          'callerName': userSenderModel.userName,
          'callerNumber': userSenderModel.userName,
          'uuid': userModel?.userUid,
          'fcm': userModel?.userFcm,
          'isvideo': isvideo
        });
        log('function run${response.data}');
      } catch (err) {
        log(err.toString());
      }
    } else if (callStatus == CallStatus.accepted) {
      if (!isvideo) {
        await agoraClient.sessionController.value.engine!.disableVideo();
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            contentPadding: const EdgeInsets.all(30),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Are you sure?'),
            content: const Text('Do you want to disconnect from the call'),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  await AwesomeNotifications().createNotification(
                    content: NotificationContent(
                      actionType: ActionType.Default,
                      id: createUniqueId(),
                      channelKey: 'call_channel',
                      payload: {
                        "callNumber" : widget.calleeNumber,
                        "isVideo" : widget.isvideo.toString()
                      },
                      title:
                          'Ongoing Call from ${widget.calleeDeatails?.userName} ',
                      notificationLayout: NotificationLayout.Default,
                      color: Colors.teal,
                    ),
                  );
                  Navigator.of(context).pop(true);
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(true);
                  Navigator.of(context).pop(true);
                  await agoraClient.sessionController.value.engine
                      ?.leaveChannel();
                  if (agoraClient
                      .sessionController.value.connectionData!.rtmEnabled) {
                    await agoraClient.sessionController.value.agoraRtmChannel
                        ?.leave();
                    await agoraClient.sessionController.value.agoraRtmClient
                        ?.logout();
                  }
                  // await value.agoraClient?.sessionController.value.engine
                  //     ?.destroy;
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : WillPopScope(
              onWillPop: () => _onWillPop(),
              child: Stack(children: [
                AgoraVideoViewer(
                  client: agoraClient,
                  disabledVideoWidget: Container(
                    color: Colors.black,
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Image.asset(
                        'assets/images/people_logo.png',
                      ),
                    ),
                  ),
                ),
                AgoraVideoButtons(
                  client: agoraClient,
                  enabledButtons: isvideo
                      ? [
                          BuiltInButtons.callEnd,
                          BuiltInButtons.switchCamera,
                          BuiltInButtons.toggleCamera,
                          BuiltInButtons.toggleMic,
                        ]
                      : [
                          BuiltInButtons.callEnd,
                          BuiltInButtons.toggleMic,
                        ],

                  // disconnectButtonChild: IconButton(onPressed: (){Navigator.pop(context);},icon:Icon(Icons.call_end)),),
                )
              ]),
            ),
    );
  }
}
