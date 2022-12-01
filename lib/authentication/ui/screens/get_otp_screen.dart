import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../shared/constants/textstyle.dart';
import '../../provider/auth_provider.dart';

class GetOtpPage extends StatefulWidget {
  const GetOtpPage({Key? key}) : super(key: key);

  @override
  State<GetOtpPage> createState() => _GetOtpPageState();
}

class _GetOtpPageState extends State<GetOtpPage> {
  String _otp = '';
  int secondsRemaining = 30;
  bool enableResend = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  void _resendCode() {
    //other code here
    setState(() {
      secondsRemaining = 30;
      enableResend = false;
    });
  }

  @override
  dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.h,
                ),
                child: Text(
                  'Enter the code',
                  style: boldHeading2,
                ),
              ),
              Text(
                "We've texted you a verification code",
                style: text1,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 6.h,
                ),
                child: OtpTextField(
                  fieldWidth: 10.w,
                  numberOfFields: 6,
                  enabledBorderColor: Colors.black,
                  borderColor: const Color(0xFF512DA8),
                  //set to true to show as box or false to show as dash
                  showFieldAsBox: true,
                  margin: const EdgeInsets.only(right: 8.0),
                  //runs when a code is typed in
                  onCodeChanged: (String code) {
                    //handle validation or checks here
                    _otp = code;
                  },
                  //runs when every textfield is filled
                  onSubmit: (String verificationCode) {
                    _otp = verificationCode;
                    context.read<AuthProvider>().authenticate(_otp, context);
                  }, // end onSubmit
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      TextButton(
                        onPressed: enableResend ? _resendCode : null,
                        child: const Text('Resend Code'),
                      ),
                      Text(
                        'after $secondsRemaining seconds',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 10),
                      ),
                    ],
                  ),
                  // TextButton(
                  //   onPressed: () {},
                  //   child: const Text(
                  //     'Resend code?',
                  //     style: TextStyle(color: Colors.red),
                  //   ),
                  // ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Call me instead',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              const Spacer(
                flex: 1,
              ),
              if (context.watch<AuthProvider>().isLoading)
                const CircularProgressIndicator(),
              const Spacer(
                flex: 2,
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(vertical: 8.h),
              //   child: CustomElevatedButton(
              //     onPressed: _otp.length != 6
              //         ? null
              //         : () {
              //             customNavigator(context, const SetProfilePage());
              //           },
              //     width: 70.w,
              //     child: Text(
              //       'Continue',
              //       style: text1,
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
