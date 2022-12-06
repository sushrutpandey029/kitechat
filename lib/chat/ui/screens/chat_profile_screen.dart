import 'package:flutter/material.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../shared/constants/textstyle.dart';
import '../../../shared/ui/widgets/custom_dialouge.dart';
import '../../../shared/ui/widgets/custom_snack_bar.dart';

class ChatProfileScreen extends StatefulWidget {
  final String username;
  const ChatProfileScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<ChatProfileScreen> createState() => _ChatProfileScreenState();
}

class _ChatProfileScreenState extends State<ChatProfileScreen> {
  @override
  void didChangeDependencies() {
    Future.delayed(
      const Duration(seconds: 1),
      () => showDialog(
          context: context,
          builder: (context) =>
               CustomDialogue(message: 'Feature coming soon!!')),
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor:  Color.fromARGB(255, 204, 204, 204),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.blue,
      ),
      body: Column(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 28.sp,
                  child: Icon(
                    Icons.person,
                    size: 38.sp,
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  widget.username,
                  style: heading3,
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
              ],
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
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
            child: Column(
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
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                //   child: const Text(
                //     "Can't talk Kite only",
                //     textAlign: TextAlign.left,
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 8.w),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       const Text('Shared files'),
          //       TextButton(onPressed: () {}, child: const Text('View more')),
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
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.red,
                  backgroundColor: Colors.transparent,
                  elevation: 0),
              onPressed: () {
                 showCustomSnackBar(context);
              },
              icon: const Icon(Icons.report),
              label: const Text('Block')),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.red,
                  backgroundColor: Colors.transparent,
                  elevation: 0),
              onPressed: () {
                 showCustomSnackBar(context);
              },
              icon: const Icon(Icons.thumb_down),
              label: const Text('Report'))
        ],
      ),
    );
  }
}
