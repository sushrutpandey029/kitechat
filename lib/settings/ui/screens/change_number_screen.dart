import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../shared/constants/textstyle.dart';
import '../../widget/setting_app_bar.dart';

class ChangeNumberPage extends StatefulWidget {
  const ChangeNumberPage({Key? key}) : super(key: key);

  @override
  State<ChangeNumberPage> createState() => _ChangeNumberPageState();
}

class _ChangeNumberPageState extends State<ChangeNumberPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: settingAppBar('Change Number'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Image.asset('assets/images/change-mobile.png'),
            ),
            const Text(
              'Before proceeding, make sure you receive SMS or calls on the new number you are going to change into.',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              'Enter your old mobile number with country code:',
              style: boldText2,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
              child: TextField(
                controller: TextEditingController(text: '+91  9876543210'),
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
            SizedBox(
              height: 2.h,
            ),
            Text(
              'Enter your old mobile number with country code:',
              style: boldText2,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
              child: TextField(
                controller: TextEditingController(text: '+91  9876543210'),
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
                padding: EdgeInsets.only(top: 12.h),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 8,
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.only(left: 6.w, right: 6.w),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.sp))),
                  onPressed: () {},
                  child: const Text('Next'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
