import 'package:flutter/material.dart';
import 'package:kite/chat/model/group_member_model.dart';
import 'package:kite/chat/provider/group_provider.dart';
import 'package:kite/shared/ui/widgets/custom_dialouge.dart';

import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../authentication/model/auth_user_model.dart';
import '../../../chat/provider/chat_provider.dart';
import '../../../chat/ui/screens/create_new_group_screen.dart';
import '../../../contact/provider/contact_provider.dart';
import '../../../contact/ui/screens/add_new_contact_screen.dart';
import '../../../contact/ui/screens/contacts.dart';
import '../../../settings/ui/screens/qr_scanner_screen.dart';
import '../../../shared/constants/textstyle.dart';
import '../../../shared/constants/url_constants.dart';
import '../../../shared/ui/widgets/custom_app_bar.dart';
import '../../../util/custom_navigation.dart';

class AddGroupMemeberPage extends StatefulWidget {
  const AddGroupMemeberPage({Key? key}) : super(key: key);

  @override
  State<AddGroupMemeberPage> createState() => _AddGroupMemeberPageState();
}

class _AddGroupMemeberPageState extends State<AddGroupMemeberPage> {
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: customAppBar(
        'Add Members',
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              size: 24.sp,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Consumer<ContactProvider>(builder: (context, value, widget) {
        return ListView.builder(
            itemCount: value.finalContacts.length,
            itemBuilder: ((context, index) {
              AuthUserModel userModel = value.finalContacts.elementAt(index);
              return Padding(
                padding: EdgeInsets.only(top: 0.5.h),
                child: ListTile(
                  onTap: () async {
                    showDialog(
                        context: context,
                        builder: (context) =>
                            CustomDialogue(message: 'Please Wait'));
                    await context
                        .read<GroupProvider>()
                        .addGroupMember(userModel);

                    Navigator.pop(context);

                    Navigator.pop(context);
                  },
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
                ),
              );
            }));
      }),
    );
  }
}
