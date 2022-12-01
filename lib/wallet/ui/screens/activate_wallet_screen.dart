import 'package:flutter/material.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../shared/constants/color_gradient.dart';
import '../../../shared/ui/widgets/custom_elevated_button_widget.dart';

class ActivateWalletScreen extends StatefulWidget {
  const ActivateWalletScreen({Key? key}) : super(key: key);

  @override
  State<ActivateWalletScreen> createState() => ActivateWalletScreenState();
}

class ActivateWalletScreenState extends State<ActivateWalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crypto-Wallet By Kite',
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: gradient1),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.sp), border: Border.all()),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.h),
                child: Image.asset('assets/images/crypto-wallet.png'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Wrap(
                  children: [
                    Text(
                      'Use Kite to Sell and Buy Crypto. A Focused digital currency. Activate now.',
                      style: TextStyle(fontSize: 17.sp),
                    ),
                    TextButton(
                        onPressed: () {}, child: const Text('Learn more')),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.h),
                child: CustomElevatedButton(
                    onPressed: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('Activate Account'),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
