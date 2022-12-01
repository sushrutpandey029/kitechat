import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../shared/constants/textstyle.dart';
import '../../../shared/ui/widgets/custom_elevated_button_widget.dart';
import '../../provider/auth_provider.dart';

class GetMobileNoPage extends StatefulWidget {
  const GetMobileNoPage({Key? key}) : super(key: key);

  @override
  State<GetMobileNoPage> createState() => _GetMobileNoPageState();
}

class _GetMobileNoPageState extends State<GetMobileNoPage> {
  Country _country = Country.parse('india');
  final TextEditingController _phoneNumber = TextEditingController();

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
                  'Enter your mobile number',
                  style: boldHeading2,
                ),
              ),
              Text(
                'You will receive a verification code on your entered mobile number.',
                style: text1,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.h,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        showCountryPicker(
                            context: context,
                            onSelect: (country) {
                              setState(() {
                                _country = country;
                              });
                            });
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_drop_down,
                            size: 24.sp,
                          ),
                          Material(
                              elevation: 10,
                              shape: const CircleBorder(),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _country.flagEmoji,
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    SizedBox(
                      width: 55.w,
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        style: boldText1,
                        // textAlign: TextAlign.center,
                        controller: _phoneNumber,
                        decoration: InputDecoration(

                            // contentPadding: EdgeInsets.only(left:20.w),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(right: 4.w),
                              child: Text(
                                '  + ${_country.phoneCode}',
                                style: boldText1,
                              ),
                            ),
                            prefixIconConstraints:
                                const BoxConstraints(minWidth: 0, minHeight: 0),
                            hintText: '0000000000',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100))),
                      ),
                    ),
                  ],
                ),
              ),
              CustomElevatedButton(
                onPressed: () async {
                  context.read<AuthProvider>().joinUserModel.country =
                      _country.name;

                  context.read<AuthProvider>().sendOtp(
                      '+${_country.phoneCode}${_phoneNumber.text}', context);
                },
                width: 70.w,
                child: Text(
                  'Continue',
                  style: text1,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
