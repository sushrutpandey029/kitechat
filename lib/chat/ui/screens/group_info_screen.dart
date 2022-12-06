import 'package:flutter/material.dart';
import 'package:kite/chat/provider/group_provider.dart';
import 'package:kite/chat/ui/screens/add_group_member_screen.dart';
import 'package:kite/shared/constants/url_constants.dart';
import 'package:kite/shared/ui/widgets/custom_snack_bar.dart';
import 'package:provider/provider.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../shared/constants/textstyle.dart';
import '../../../shared/ui/widgets/custom_dialouge.dart';

class GroupInfoScreen extends StatefulWidget {
  final String username;
  const GroupInfoScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GroupProvider>(builder: (context, value, widget) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        // backgroundColor:  Color.fromARGB(255, 204, 204, 204),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 5),
                        blurRadius: 5,
                        color: Color.fromARGB(255, 162, 162, 162),
                      )
                    ]),
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Image.network(
                      // "$imgUrl/${value.selectedGroup!.groupImage}",
                      'https://helpx.adobe.com/content/dam/help/en/photoshop/using/convert-color-image-black-white/jcr_content/main-pars/before_and_after/image-before/Landscape-Color.jpg',
                      height: 32.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      headers: {"Connection": "Keep-Alive"},
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        value.selectedGroup!.groupName,
                        style: heading3,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 6.w,
                ),
                child: SwitchListTile(
                    title: const Text('Notification Sound'),
                    value: false,
                    onChanged: (value) {}),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          iconSize: 26.sp,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.message,
                            color: Colors.blueAccent,
                          )),
                      IconButton(
                          iconSize: 26.sp,
                          onPressed: () {
                             showCustomSnackBar(context);
                          },
                          icon: const Icon(
                            Icons.call,
                            color: Colors.blueAccent,
                          )),
                      IconButton(
                          iconSize: 28.sp,
                          onPressed: () {
                             showCustomSnackBar(context);
                          },
                          icon: const Icon(
                            Icons.video_call,
                            color: Colors.blueAccent,
                          )),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(color: Colors.black, thickness: 0.3.h),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Text(
                  'Participants ${value.groupMembersList.length}',
                  style: boldText2,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: SizedBox(
                  height: 11.h,
                  child: Row(
                    children: [
                      Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: value.groupMembersList.length,
                              itemBuilder: ((context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      const CircleAvatar(
                                        child: Icon(Icons.person),
                                      ),
                                      Text(value.groupMembersList
                                          .elementAt(index)
                                          .userName)
                                    ],
                                  ),
                                );
                              }))),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddGroupMemeberPage()));
                              },
                              child: Icon(Icons.add),
                            ),
                            Text('Add More')
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Divider(color: Colors.black, thickness: 0.3.h),
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 8.w),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       const Text('Shared files'),
              //       TextButton(
              //           onPressed: () {}, child: const Text('View more')),
              //     ],
              //   ),
              // ),
              // SizedBox(
              //   height: 12.h,
              //   child: ListView.builder(
              //       scrollDirection: Axis.horizontal,
              //       itemCount: 6,
              //       itemBuilder: (context, index) {
              //         return Card(
              //             child: FlutterLogo(
              //           size: 40.sp,
              //         ));
              //       }),
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(color: Colors.black, thickness: 0.3.h),
              ),
              TextButton(
                  onPressed: () {
                    showCustomSnackBar(context);
                  },
                  child: Text('Delete Chats')),
              TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: () {
                    showCustomSnackBar(context);
                  },
                  child: Text('Leave the Group')),
            ],
          ),
        ),
      );
    });
  }
}
