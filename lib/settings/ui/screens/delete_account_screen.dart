import 'package:flutter/material.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../shared/constants/textstyle.dart';
import '../../../util/custom_navigation.dart';
import '../../widget/setting_app_bar.dart';
import 'change_number_screen.dart';
import 'dell_my_acc_page.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({Key? key}) : super(key: key);

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final TextEditingController _reason = TextEditingController();
  final TextEditingController _number = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: settingAppBar('Delete Account'),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 6.w,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(20.sp),
                  child: Image.asset('assets/images/delete-account.png',
                      height: 8.h, fit: BoxFit.cover),
                ),
              ),
              Text('Deleting your account will:', style: heading3),
              Padding(
                padding: EdgeInsets.all(5.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 6.w, top: 1.h),
                      child: const Text('Delete all your messages history'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 6.w, top: 1.h),
                      child: const Text('Remove you from all kite group'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 6.w, top: 1.h),
                      child: const Text('Delete all shared media'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: const Divider(thickness: 2, color: Colors.black),
              ),
              Text(
                'Change number instead?',
                style: heading3,
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.h, left: 4.w),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 8,
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.sp))),
                    onPressed: () {
                      customNavigator(context, const ChangeNumberPage());
                    },
                    child: const Text('Change number')),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: const Divider(thickness: 2, color: Colors.black),
              ),
              Text(
                'Enter your mobile number',
                style: text1,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                child: TextField(
                  controller: TextEditingController(text: 'India'),
                  decoration: InputDecoration(
                    labelText: 'Country',
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 18),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.sp)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.sp)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                child: TextField(
                  controller: _number,
                  decoration: InputDecoration(
                    labelText: 'Phone no.',
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 18),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.sp)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.sp)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 8,
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.only(left: 6.w, right: 6.w),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.sp))),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DelMyAccountPage(
                              number: _number.text,
                            ),
                          ),
                        );
                      },
                      child: const Text('Delete')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
