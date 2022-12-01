import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../authentication/model/auth_user_model.dart';
import '../../../chat/provider/chat_provider.dart';
import '../../../chat/provider/chat_t_provider.dart';
import '../../../chat/ui/screens/create_new_group_screen.dart';
import '../../../settings/ui/screens/qr_scanner_screen.dart';
import '../../../shared/constants/textstyle.dart';
import '../../../shared/constants/url_constants.dart';
import '../../../shared/ui/widgets/custom_app_bar.dart';
import '../../../util/custom_navigation.dart';
import '../../provider/contact_provider.dart';
import 'add_new_contact_screen.dart';
import 'contacts.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({Key? key}) : super(key: key);

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  @override
  Widget build(BuildContext context) {
    final nonRegContacts = context.read<ContactProvider>().nonRegContacts;
    return Scaffold(
      appBar: customAppBar(
        'Contacts',
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const QrScannerScreen(),
                ));
              },
              icon: Icon(
                Icons.qr_code,
                size: 24.sp,
              )),
          IconButton(
            icon: Icon(
              Icons.search,
              size: 24.sp,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                // boxShadow: const [
                //   BoxShadow(
                //       offset: Offset(2, 5), color: Colors.grey, blurRadius: 20)
                // ]
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      customNavigator(context, const CreateNewGroupScreen());
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Icon(
                                Icons.group,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 44.0),
                              child: Text("New group"),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      customNavigator(context, const AddNewContactScreen());
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Icon(
                                Icons.person_add_alt,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 44.0),
                              child: Text("New contact"),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      customNavigator(
                        context,
                        PhoneContacts(
                          phoneContacts: nonRegContacts,
                        ),
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 44.0),
                              child: Text("Invite"),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.help,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 44.0),
                            child: Text("Contact us"),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 100.w,
                    color: Colors.grey.shade300,
                    padding: EdgeInsets.only(left: 2.w, top: 2.w, bottom: 2.w),
                    child: Text(
                      'People on kite',
                      style: text2,
                    ),
                  )
                ],
              ),
            ),
            Consumer<ContactProvider>(builder: (context, value, widget) {
              value.finalContacts.sort(
                (a, b) => a.userName.compareTo(b.userName),
              );
              return Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: value.finalContacts.length,
                      itemBuilder: ((context, index) {
                        AuthUserModel userModel =
                            value.finalContacts.elementAt(index);
                        return Padding(
                          padding: EdgeInsets.only(top: 0.5.h),
                          child: ListTile(
                            onTap: () {
                              context
                                  .read<ChatTProvider>()
                                  .selectUser(context, 0, true, userModel);
                            },
                            // shape: const UnderlineInputBorder(
                            //     borderSide: BorderSide(color: Colors.grey)),
                            leading: userModel.userImage != null
                                ? CircleAvatar(
                                    child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.network(
                                      '$imgUrl/${userModel.userImage}',
                                      fit: BoxFit.contain,
                                    ),
                                  ))
                                : const CircleAvatar(
                                    child: Icon(Icons.person),
                                  ),
                            title: Text(userModel.userName),
                            // trailing: SizedBox(
                            //   width: 35.w,
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Material(
                            //         shape: const CircleBorder(),
                            //         elevation: 10,
                            //         child: CircleAvatar(
                            //           child: IconButton(
                            //               onPressed: () {},
                            //               icon: const Icon(Icons.edit)),
                            //         ),
                            //       ),
                            //       Material(
                            //         shape: const CircleBorder(),
                            //         elevation: 10,
                            //         child: CircleAvatar(
                            //           child: IconButton(
                            //               onPressed: () {
                            //                 customNavigator(
                            //                     context,
                            //                     CallPage(
                            //                       calleeNumber:
                            //                           userModel.userPhoneNumber,

                            //                     ));
                            //               },
                            //               icon: const Icon(Icons.call)),
                            //         ),
                            //       ),
                            //       Material(
                            //         shape: const CircleBorder(),
                            //         elevation: 10,
                            //         child: CircleAvatar(
                            //           child: IconButton(
                            //               onPressed: () {
                            //                 customNavigator(
                            //                     context,
                            //                     CallPage(
                            //                       calleeNumber:
                            //                           userModel.userPhoneNumber,
                            //                       hasVideo: true,
                            //                     ));
                            //               },
                            //               icon: const Icon(Icons.video_call)),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ),
                        );
                      })),
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
