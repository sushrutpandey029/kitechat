import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../shared/constants/textstyle.dart';
import '../../../shared/ui/widgets/custom_elevated_button_widget.dart';
import 'get_mobile_no_screen.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({Key? key}) : super(key: key);

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background-line.png'),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 40.w,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Center(
                      child: Material(
                        shape: const CircleBorder(),
                        elevation: 15,
                        child: CircleAvatar(
                          radius: 30.sp,
                          backgroundColor:
                              const Color.fromARGB(255, 217, 238, 255),
                        ),
                      ),
                    ),
                    Center(
                      child: Image.asset('assets/images/male.png'),
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: 40.w,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Center(
                      child: Material(
                        shape: const CircleBorder(),
                        elevation: 15,
                        child: CircleAvatar(
                          radius: 32.sp,
                          backgroundColor:
                              const Color.fromARGB(255, 253, 255, 157),
                        ),
                      ),
                    ),
                    Center(
                      child: Image.asset('assets/images/female.png'),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.w, bottom: 10.h),
              child: Material(
                elevation: 20,
                color: const Color.fromARGB(255, 162, 213, 255),
                shape: const CircleBorder(),
                child: Padding(
                  padding: EdgeInsets.all(22.sp),
                  child: Image.asset('assets/images/location.png',
                      width: 6.w, fit: BoxFit.fill),
                ),
              ),
            ),
            Container(
              width: 100.w,
              height: 35.h,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(8.w)),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0.5.w, -0.8.h),
                        color: const Color.fromARGB(255, 134, 134, 134),
                        blurRadius: 2.5.h,
                        spreadRadius: 1),
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Text(
                      'Redefining Communication',
                      style: boldText1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Text(
                      'with',
                      style: boldText1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Text(
                      'KITE',
                      style: heading1,
                    ),
                  ),
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const GetMobileNoPage()));
                    },
                    width: 70.w,
                    child: Text(
                      'Get Started',
                      style: TextStyle(fontSize: 20.sp),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
