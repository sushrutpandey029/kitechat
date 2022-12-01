import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../../../call/ui/screens/call_page.dart';
import '../../../shared/constants/color_gradient.dart';
import '../../../shared/constants/textstyle.dart';
import '../../../util/custom_navigation.dart';
import '../../provider/chat_provider.dart';
import '../../provider/chat_t_provider.dart';
import '../screens/chat_profile_screen.dart';

AppBar chatAppBar(BuildContext context, Socket socket) {
  return AppBar(
    title: Consumer<ChatTProvider>(builder: (context, value, widget) {
      return InkWell(
        onTap: () {
          customNavigator(
            context,
            ChatProfileScreen(
              username: value.selectedUser!.userName,
            ),
          );
        },
        child: Row(
          children: [
            const CircleAvatar(
              child: Icon(Icons.person),
            ),
            SizedBox(
              width: 4.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 25.w,
                  child: Text(
                    value.selectedUser!.userName,
                    style: whiteText1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'Online..',
                  style: TextStyle(fontSize: 15.sp),
                ),
              ],
            ),
          ],
        ),
      );
    }),
    actions: [
      Consumer<ChatTProvider>(builder: (context, value, widget) {
        return IconButton(
            onPressed: () {
              customNavigator(
                  context,
                  CallPage(
                    calleeDeatails: value.selectedUser!,
                    calleeNumber: value.selectedUser!.userPhoneNo,
                    isvideo: true,
                    socket: socket,
                  ));
            },
            icon: const Icon(Icons.video_call));
      }),
      Consumer<ChatTProvider>(builder: (context, value, widget) {
        return IconButton(
            onPressed: () {
              customNavigator(
                  context,
                  CallPage(
                    calleeDeatails: value.selectedUser!,
                    calleeNumber: value.selectedUser!.userPhoneNo,
                    isvideo: false,
                    socket: socket,
                  ));
            },
            icon: const Icon(Icons.phone));
      }),
      IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
    ],
    flexibleSpace: Container(
      decoration: BoxDecoration(gradient: gradient1),
    ),
  );
}
