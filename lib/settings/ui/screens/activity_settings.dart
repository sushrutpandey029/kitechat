import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../authentication/model/auth_user_model.dart';
import '../../../contact/provider/contact_provider.dart';

import '../../../shared/constants/textstyle.dart';
import '../../widget/setting_app_bar.dart';
import 'matched_contact.dart';

class ActivitySettingsPage extends StatefulWidget {
  const ActivitySettingsPage(
      {Key? key, required this.title, required this.heading})
      : super(key: key);
  final String title;
  final String heading;

  @override
  State<ActivitySettingsPage> createState() => _ActivitySettingsPageState();
}

class _ActivitySettingsPageState extends State<ActivitySettingsPage> {
  @override
  void initState() {
    loadDocuments();
    super.initState();
  }

  List<AuthUserModel> phoneContacts = [];

  loadDocuments() async {
    // phoneContacts = await context.read<ContactProvider>().matchContacts();
    await context.read<ContactProvider>().matchContacts(context);
  }

  List listTitles = <String>['My Contacts', 'Everybody', 'Nobody'];
  List radioValues = <PrivacyStatus>[
    PrivacyStatus.myContacts,
    PrivacyStatus.everybody,
    PrivacyStatus.nobody,
  ];
  PrivacyStatus _groupValue = PrivacyStatus.myContacts;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: settingAppBar(widget.title),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Who can see my ${widget.heading}?',
              style: blueText2,
            ),
            for (int index = 0; index < 3; index++)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(listTitles.elementAt(index)),
                trailing: Radio<PrivacyStatus>(
                    value: radioValues.elementAt(index),
                    groupValue: _groupValue,
                    onChanged: (value) {
                      setState(() {
                        if (value != null) {
                          _groupValue = value;
                        }
                      });
                    }),
              ),
            const Divider(
              thickness: 2,
              color: Colors.black,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Only',
                    style: text1,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MatcherContact(
                                    phoneContact: phoneContacts,
                                  )),
                        );
                      },
                      child: const Text('Add User'))
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Never',
                  style: text1,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MatcherContact(
                                  phoneContact: phoneContacts,
                                )),
                      );
                    },
                    child: const Text('Add User'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum PrivacyStatus { myContacts, everybody, nobody }
