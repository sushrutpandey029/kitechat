import 'package:flutter/material.dart';
import 'package:kite/chat/provider/group_provider.dart';
import 'package:kite/contact/provider/contact_provider.dart';
import 'package:kite/shared/constants/url_constants.dart';

import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../../../call/ui/screens/call_page.dart';
import '../../../shared/constants/color_gradient.dart';
import '../../../shared/constants/textstyle.dart';
import '../../../shared/ui/widgets/custom_snack_bar.dart';
import '../../../util/custom_navigation.dart';
import '../../provider/chat_provider.dart';
import '../../provider/chat_t_provider.dart';
import '../screens/chat_profile_screen.dart';
import '../screens/group_info_screen.dart';

AppBar chatAppBar(BuildContext context, Socket socket, bool isGroupChat) {
  return AppBar(
    title: Consumer<GroupProvider>(builder: (context, state, widget) {
      return Consumer<ChatTProvider>(builder: (context, value, widget) {
        return InkWell(
          onTap: () {
            customNavigator(
              context,
              isGroupChat
                  ? GroupInfoScreen(username: state.selectedGroup!.groupName)
                  : ChatProfileScreen(
                      username: value.selectedUser!.userName,
                    ),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                // foregroundImage: NetworkImage(isGroupChat
                //     ? "$imgUrl/${state.selectedGroup!.groupImage}"
                //     :"$imgUrl/${context
                //         .read<ContactProvider>()
                //         .finalContacts
                //         .where((element) =>
                //             element.id == value.selectedUser!.userId)
                //         .first
                //         .userImage}"),
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
                      isGroupChat
                          ? state.selectedGroup!.groupName
                          : value.selectedUser!.userName,
                      style: whiteText1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    isGroupChat
                        ? "${state.groupMembersList.length} members"
                        : '',
                    style: TextStyle(fontSize: 15.sp),
                  ),
                ],
              ),
            ],
          ),
        );
      });
    }),
    actions: [
      Consumer<ChatTProvider>(builder: (context, value, widget) {
        return IconButton(
            onPressed: () {
              isGroupChat
                  ? showCustomSnackBar(context)
                  : customNavigator(
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
              isGroupChat?
               showCustomSnackBar(context):
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
      PopupMenuButton(
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: 0,
              child: Text('View Contact'),
            ),
            PopupMenuItem(
              value: 1,
              child: Text('Media, links and docs'),
            ),
            PopupMenuItem(
              value: 2,
              child: Text('Search'),
            ),
            PopupMenuItem(
              value: 3,
              child: Text('Mute notification'),
            ),
            PopupMenuItem(
              value: 4,
              child: Text('More'),
            ),
          ];
        },
        child: Icon(Icons.more_vert),
      )
    ],
    flexibleSpace: Container(
      decoration: BoxDecoration(gradient: gradient1),
    ),
  );
}
