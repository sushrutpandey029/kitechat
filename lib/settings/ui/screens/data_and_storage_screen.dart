import 'package:flutter/material.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../shared/constants/textstyle.dart';
import '../../../shared/ui/widgets/custom_dialouge.dart';
import '../../widget/setting_app_bar.dart';

class DataStoragePage extends StatefulWidget {
  const DataStoragePage({Key? key}) : super(key: key);

  @override
  State<DataStoragePage> createState() => _DataStoragePageState();
}

class _DataStoragePageState extends State<DataStoragePage> {
  @override
  void didChangeDependencies() {
    Future.delayed(
      const Duration(seconds: 1),
      () => showDialog(
          context: context,
          builder: (context) => CustomDialogue(
                message: 'Feature coming soon!!',
                onTap: () {
                  Navigator.pop(context);
                },
              )),
    );
    super.didChangeDependencies();
  }

  List titles = <String>[
    'When using mobile data',
    'When connected to Wi-Fi',
    'When roaming'
  ];
  List switchValues = <bool>[false, false, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: settingAppBar(
        'Data and Storage',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Manage Storage', style: blueText1),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: Text(
                  'Storage used',
                  style: text1,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: const [
                      Text('7.7 GB'),
                      Text('Used'),
                    ],
                  ),
                  Column(
                    children: const [
                      Text('7 GB'),
                      Text('Free'),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: Stack(
                  children: [
                    Container(
                      height: 4.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20.sp)),
                    ),
                    Container(
                      height: 4.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(20.sp)),
                    ),
                    Container(
                      height: 4.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(20.sp)),
                    ),
                    Container(
                      height: 4.h,
                      width: 30.w,
                      decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.circular(20.sp)),
                    ),
                    Container(
                      height: 4.h,
                      width: 15.w,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(20.sp)),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                      const Text('Photos')
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.yellow,
                        ),
                      ),
                      const Text('Videos')
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                      const Text('Audio')
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const Text('Documents')
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: const Divider(
                  color: Colors.black,
                  thickness: 2,
                ),
              ),
              Text(
                'Automatic media download',
                style: blueText1,
              ),
              for (int index = 0; index < 3; index++)
                SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(titles.elementAt(index)),
                    subtitle: const Text('Photos, Videos, Audio & Files'),
                    value: switchValues.elementAt(index),
                    onChanged: (value) {
                      setState(() {
                        switchValues[index] = value;
                      });
                    }),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: const Divider(
                  color: Colors.black,
                  thickness: 2,
                ),
              ),
              Text(
                'Media Quality',
                style: blueText1,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: Text(
                  'Sending media quality',
                  style: text1,
                ),
              ),
              const Text(
                'Standard',
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: const Divider(
                  color: Colors.black,
                  thickness: 2,
                ),
              ),
              Text(
                'Calls',
                style: blueText1,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: Text(
                  'Use less data for calls',
                  style: text1,
                ),
              ),
              const Text(
                'Mobile Data',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
