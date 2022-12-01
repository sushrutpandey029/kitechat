import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../authentication/model/auth_user_model.dart';
import '../../provider/chat_provider.dart';
import '../../provider/chat_t_provider.dart';

class ChatListingPage extends StatefulWidget {
  const ChatListingPage({Key? key}) : super(key: key);

  @override
  State<ChatListingPage> createState() => _ChatListingPageState();
}

class _ChatListingPageState extends State<ChatListingPage> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<ChatTProvider>().fetchChatUsers(context);
      },
      child: Consumer<ChatTProvider>(builder: (context, value, widget) {
        return ListView.builder(
          itemCount: value.chatUsersList.length,
          itemBuilder: (context, index) {
            String msgText = value.chatUsersList[index].lastMessage;
            if (msgText == "") {
              msgText = "Sent a File";
            } else {
              String fullMessage =
                  value.chatUsersList.elementAt(index).lastMessage;
              List<String> splitMessage = fullMessage.split("\n");
              msgText =
                  splitMessage.length > 1 ? splitMessage.first : fullMessage;
            }

            return Card(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 4,
              child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onTap: () {
                    Provider.of<ChatTProvider>(context, listen: false)
                        .selectUser(
                            context,
                            index,
                            false,
                            AuthUserModel(
                              id: value.chatUsersList.elementAt(index).userId,
                              userRegNo: value.chatUsersList
                                  .elementAt(index)
                                  .userRegNo,
                              country: '',
                              userPhoneNumber: value.chatUsersList
                                  .elementAt(index)
                                  .userPhoneNo,
                              userImage: '',
                              userName:
                                  value.chatUsersList.elementAt(index).userName,
                              userBio: '',
                              userDob: DateTime.now(),
                              userCreateDateTime: DateTime.now(),
                              userIpAddress: '',
                              userPhoneName: '',
                              userStatus: '',
                              userFcm: '',
                              userUid: '',
                            ));
                    //
                  },
                  contentPadding: EdgeInsets.only(left: 2.w),
                  tileColor: const Color.fromARGB(255, 231, 231, 231),
                  leading: CircleAvatar(
                    radius: 20.sp,
                    child: const Icon(Icons.person),
                  ),
                  title: Text(value.chatUsersList.elementAt(index).userName),
                  subtitle: Text(msgText),
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
                  )),
            );
          },
        );
      }),
    );
  }
}
