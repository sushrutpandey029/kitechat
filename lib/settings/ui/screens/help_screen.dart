import 'package:flutter/material.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../shared/constants/textstyle.dart';
import '../../../web_search/ui/screen/web_view_screen.dart';
import '../../widget/setting_app_bar.dart';
import 'app_info_screen.dart';
import 'contact_us_screen.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: settingAppBar('Help'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContactUsScreen()),
                );
              },
              title: Text(
                'Contact us',
                style: text1,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WebViewScreen(
                      url: 'https://www.google.com/',
                      name: "Terms and Condition",
                    ),
                  ),
                );
              },
              title: Text(
                'Terms & Privacy Policy',
                style: text1,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AppInfoScreen(),
                  ),
                );
              },
              title: Text(
                'App info',
                style: text1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
