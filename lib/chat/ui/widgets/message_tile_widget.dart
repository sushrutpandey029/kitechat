import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kite/chat/provider/chat_t_provider.dart';
import 'package:kite/chat/ui/widgets/voice_msg.dart';
import 'package:provider/provider.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../call/ui/screens/call_page.dart';
import '../../../database/repository/message_hive_repo.dart';
import '../../../shared/constants/url_constants.dart';
import '../screens/forward_chat_screen.dart';
import 'image_view.dart';

class MessageTileWidget extends StatefulWidget {
  const MessageTileWidget({
    Key? key,
    required this.type,
    required this.isByUser,
    required this.message,
    required this.time,
    required this.isContinue,
    required this.recievernumber,
    required this.chatid,
  }) : super(key: key);
  final String message;
  final String time;
  final bool isByUser;
  final bool isContinue;
  final String type;
  final String recievernumber;
  final int chatid;

  @override
  State<MessageTileWidget> createState() => _MessageTileWidgetState();
}

class _MessageTileWidgetState extends State<MessageTileWidget> {
  Widget showMessage(BuildContext context, String type, String message) {
    if (type == "image") {
      return _displayImage(context, message);
      // return Text("Hello");
    } else if (type == "audio") {
      // return Text(audioMsgUrl);
      return PlayVoiceMsg(audioUrl: "$audioMsgUrl/$message", time: widget.time);
      // return PlayAudioFromFile(audioMsgUrl: '$audioMsgUrl/$message');
    } else if (type == "contact") {
      return Text(
        'contact - $message',
        style: const TextStyle(color: Colors.red),
      );
    } else if (type == "location") {
      final url =
          Uri.parse('https://www.google.com/maps/search/?api=1&query=$message');
      return GestureDetector(
          onTap: () async {
            if (!await launchUrl(url)) {
              throw 'Could not launch $url';
            }
          },
          child: Row(
            children: const [
              Icon(Icons.location_on),
              SizedBox(
                width: 5,
              ),
              Text('Location \n Tap to get the location!'),
            ],
          ));
    } else if (type == "file") {
      return Text("Document - $message");
    } else {
      int length = message.split("\n").length;
      if (length > 10) {
        List<String> splitText = message.split("\n");
        String shrinkText = "";
        for (int i = 0; i <= 9; i++) {
          shrinkText += splitText[i];
          if (i != splitText.length - 1) {
            shrinkText += "\n";
          }
        }
        return TextRenderWidget(
            fullText: message, shrinkText: shrinkText.trim());
      } else {
        if (message.contains('JOIN VIDEO CALL:') ||
            message.contains('JOIN VOICE CALL:')) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              widget.isByUser
                  ? Text('You called \n${widget.recievernumber}')
                  : Text(message.split(': ').first),
              const SizedBox(
                width: 5,
              ),
              widget.isByUser
                  ? const SizedBox()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 8,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          backgroundColor: Colors.green),
                      onPressed: () async {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => CallPage(
                                  calleeNumber: widget.recievernumber,
                                  callStatus: CallStatus.accepted,
                                  isvideo: message.contains('JOIN VIDEO CALL:'),
                                )));
                        await context
                            .read<ChatTProvider>()
                            .deleteMessage(widget.chatid);
                      },
                      child: const Text('Join'))
            ],
          );
        }
        // } else if (message.contains('JOIN VOICE CALL:')) {
        //   return Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       widget.isByUser
        //           ? Text('You voice called \n${widget.recievernumber}')
        //           : Text(message.split(': ').first),
        //       widget.isByUser
        //           ? const SizedBox()
        //           : ElevatedButton(
        //               style: ElevatedButton.styleFrom(
        //                   elevation: 8,
        //                   padding: const EdgeInsets.symmetric(
        //                       horizontal: 10, vertical: 6),
        //                   backgroundColor: Colors.green),
        //               onPressed: joined
        //                   ? null
        //                   : () {
        //                       setState(() {
        //                         joined = true;
        //                       });
        //                       Navigator.of(context).push(
        //                         CupertinoPageRoute(
        //                           builder: (context) => CallPage(
        //                             calleeNumber: widget.recievernumber,
        //                             callStatus: CallStatus.accepted,
        //                             roomId: message.split(' ').last,
        //                             hasVideo: false,
        //                           ),
        //                         ),
        //                       );
        //                     },
        //               child: const Text('Join'),
        //             ),
        //     ],
        //   );
        // }
        return Text(message);
      }
    }
  }

  GestureDetector _displayImage(BuildContext context, String message) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          fullImageView(message),
        );
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14.sp),
            child: Image.network(
              '$imgMsgUrl/$message',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: Text(
              widget.time,
              style: TextStyle(fontSize: 14.sp, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  MaterialPageRoute<dynamic> fullImageView(String message) {
    return MaterialPageRoute(
      builder: (context) => ImageView(
        imgUrl: '$imgMsgUrl/$message',
        isSendImage: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: widget.isContinue ? 0.5.h : 1.5.h,
          bottom: 0.5.h,
          left: 1.w,
          right: 1.w),
      child: GestureDetector(
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
                content: Wrap(
              children: [
                if (widget.isByUser)
                  ListTile(
                    onTap: () async {
                      await context
                          .read<ChatTProvider>()
                          .deleteMessage(widget.chatid);
                      Navigator.of(context).pop();
                    },
                    leading: const Icon(Icons.delete),
                    title: const Text('Delete Message'),
                  ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ForwardChatScreen(
                          message: widget.message, type: widget.type),
                    ));
                  },
                  leading: const Icon(Icons.forward),
                  title: const Text('Forward message'),
                )
              ],
            )),
          );
        },
        child: Row(
          mainAxisAlignment:
              widget.isByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (widget.isByUser)
              SizedBox(
                width: 18.w,
              ),
            Flexible(
              child: Material(
                elevation: 3,
                color: widget.isByUser
                    ? Colors.lightBlueAccent
                    : const Color.fromARGB(255, 236, 235, 235),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.sp)),
                child: Padding(
                  padding: widget.type == "image"
                      ? const EdgeInsets.all(4)
                      : EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  child: widget.type == "text"
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: showMessage(
                                  context, widget.type, widget.message),
                            ),
                            // Text(message, style: TextStyle(fontSize: 16.sp))),
                            SizedBox(
                              width: 2.w,
                            ),
                            Text(
                              widget.time,
                              style: TextStyle(fontSize: 14.sp),
                            )
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: showMessage(
                                  context, widget.type, widget.message),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            if (!widget.isByUser)
              SizedBox(
                width: 18.w,
              ),
          ],
        ),
      ),
    );
  }
}

class TextRenderWidget extends StatefulWidget {
  const TextRenderWidget(
      {super.key, required this.fullText, required this.shrinkText});
  final String fullText;
  final String shrinkText;

  @override
  State<TextRenderWidget> createState() => _TextRenderWidgetState();
}

class _TextRenderWidgetState extends State<TextRenderWidget> {
  String toRenderText = '';

  @override
  void initState() {
    super.initState();
    toRenderText = widget.shrinkText;
  }

  void shrink() {
    toRenderText = widget.shrinkText;
  }

  void grow() {
    toRenderText = widget.fullText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(toRenderText),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: GestureDetector(
              onTap: () {
                setState(() {
                  if (toRenderText == widget.fullText) {
                    shrink();
                  } else {
                    grow();
                  }
                });
              },
              child: Text(
                toRenderText == widget.fullText ? "Show less" : "Show more",
                style: TextStyle(color: Colors.blue[700]),
              )),
        ),
      ],
    );
  }
}
