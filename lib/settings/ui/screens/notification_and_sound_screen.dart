import 'package:flutter/material.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:vibration/vibration.dart';

import '../../../shared/constants/color_gradient.dart';
import '../../../shared/constants/textstyle.dart';
import '../../../shared/ui/widgets/custom_dialouge.dart';

class NotificationSoundsPage extends StatefulWidget {
  const NotificationSoundsPage({Key? key}) : super(key: key);

  @override
  State<NotificationSoundsPage> createState() => _NotificationSoundsPageState();
}

class _NotificationSoundsPageState extends State<NotificationSoundsPage> {
  // @override
  // void didChangeDependencies() {
  //   Future.delayed(
  //     const Duration(seconds: 1),
  //     () => showDialog(
  //         context: context,
  //         builder: (context) =>
  //             const CustomDialogue(message: 'Feature coming soon!!')),
  //   );
  //   super.didChangeDependencies();
  // }

  List<String> titles = <String>[
    'Notification sound',
    'Vibrate',
    'Popup notification',
    'Notification sound',
    'Vibrate',
    'Popup notification',
    'Ringtone sound',
    'Vibration',
    'Ring and vibrate'
  ];
  List<bool> listValue = <bool>[
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  void reset(List list) {
    for (int i = 0; i < list.length; i++) {
      if (list.elementAt(i) == true) {
        list[i] = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification and Sounds'),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: gradient1),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chat notification',
              style: blueText1,
            ),
            for (int index = 0; index < 3; index++)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(titles.elementAt(index)),
                value: listValue.elementAt(index),
                onChanged: (value) async {
                  setState(() {
                    listValue[index] = value;
                  });
                  if (titles.elementAt(index) == 'Vibrate') {
                    if (await Vibration.hasVibrator() ?? false) {
                      Vibration.vibrate();
                    }
                  }
                },
              ),
            const Divider(
              color: Colors.black,
              thickness: 1,
            ),
            Text(
              'Group notification',
              style: blueText1,
            ),
            for (int index = 3; index < 6; index++)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(titles.elementAt(index)),
                value: listValue.elementAt(index),
                onChanged: (value) {
                  setState(() {
                    listValue[index] = value;
                  });
                },
              ),
            const Divider(
              color: Colors.black,
              thickness: 1,
            ),
            Text(
              'Audio and Video Call notification',
              style: blueText1,
            ),
            for (int index = 6; index < 9; index++)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(titles.elementAt(index)),
                value: listValue.elementAt(index),
                onChanged: (value) {
                  setState(() {
                    listValue[index] = value;
                  });
                },
              ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                reset(listValue);
                setState(() {});
              },
              child: const Text(
                'Reset notification',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
