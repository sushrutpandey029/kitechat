import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../chat/ui/screens/create_new_group_screen.dart';
import '../../../contact/provider/contact_provider.dart';
import '../../../contact/ui/screens/add_new_contact_screen.dart';
import '../../../shared/constants/textstyle.dart';
import '../../../shared/constants/url_constants.dart';
import '../../../shared/ui/widgets/custom_app_bar.dart';
import '../../../shared/ui/widgets/custom_snack_bar.dart';
import '../../../util/custom_navigation.dart';

class CallListPage extends StatefulWidget {
  const CallListPage({Key? key}) : super(key: key);

  @override
  State<CallListPage> createState() => _CallListPageState();
}

class _CallListPageState extends State<CallListPage> {
  // @override
  // void didChangeDependencies() {
  //   Future.delayed(
  //     const Duration(seconds: 1),
  //     () => showDialog(
  //         context: context,
  //         builder: (context) =>
  //             const CustomDialogue(message: 'Feature coming soon!!')),
  //   );
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    final finalContacts = context.read<ContactProvider>().finalContacts;
    finalContacts.sort(
      (a, b) => a.userName.compareTo(b.userName),
    );
    return Scaffold(
      appBar: customAppBar('Calls', actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            size: 24.sp,
          ),
          onPressed: () {
            showCustomSnackBar(context);
          },
        )
      ]),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(2, 5), color: Colors.grey, blurRadius: 20)
                ]),
            child: Column(
              children: [
                // ListTile(
                //   onTap: () {
                //     customNavigator(context, const CreateNewGroupScreen());
                //   },
                //   title: Text(
                //     'New group call',
                //     style: text1,
                //   ),
                //   leading: Icon(
                //     Icons.group_add,
                //     size: 24.sp,
                //     color: Colors.black,
                //   ),
                // ),
                ListTile(
                  onTap: () =>
                      customNavigator(context, const AddNewContactScreen()),
                  title: Text(
                    'New contact',
                    style: text1,
                  ),
                  leading: Icon(
                    Icons.person_add,
                    size: 24.sp,
                    color: Colors.black,
                  ),
                ),
                const Divider(
                  thickness: 3,
                  color: Colors.black,
                  height: 0,
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: finalContacts.length,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: EdgeInsets.only(top: .5.h),
                      child: ListTile(
                        shape: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        leading: finalContacts[index].userImage != null
                            ? CircleAvatar(
                                child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.network(
                                  '$imgUrl/${finalContacts[index].userImage}',
                                  fit: BoxFit.contain,
                                ),
                              ))
                            : const CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                        title: Text(finalContacts[index].userName),
                        // trailing: SizedBox(
                        //   width: 35.w,
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       ElevatedButton(
                        //           style: ElevatedButton.styleFrom(
                        //               elevation: 8,
                        //               shape: const CircleBorder()),
                        //           onPressed: () {
                        //             Provider.of<VideoCallProvider>(context,listen: false).connectCall(context);
                        //             customNavigator(
                        //                 context,
                        //                 CallPage(
                        //                   calleeNumber: finalContacts[index]
                        //                       .userPhoneNumber,
                        //                   hasVideo: false,
                        //                 ));
                        //           },
                        //           child: const Icon(Icons.call)),
                        //       ElevatedButton(
                        //           style: ElevatedButton.styleFrom(
                        //               elevation: 8,
                        //               shape: const CircleBorder()),
                        //           onPressed: () {
                        //             customNavigator(
                        //                 context,
                        //                 CallPage(
                        //                   calleeNumber: finalContacts[index]
                        //                       .userPhoneNumber,
                        //                   hasVideo: true,
                        //                 ));
                        //           },
                        //           child: const Icon(Icons.video_call)),
                        //     ],
                        //   ),
                        // ),
                      ),
                    );
                  })))
        ],
      ),
    );
  }
}
