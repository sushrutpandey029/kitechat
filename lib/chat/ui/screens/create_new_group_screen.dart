import 'package:flutter/material.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../shared/constants/textstyle.dart';
import '../../../shared/ui/widgets/custom_app_bar.dart';
import '../../../shared/ui/widgets/custom_dialouge.dart';

class CreateNewGroupScreen extends StatefulWidget {
  const CreateNewGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateNewGroupScreen> createState() => CreateNewGroupScreenState();
}

class CreateNewGroupScreenState extends State<CreateNewGroupScreen> {
  @override
  void didChangeDependencies() {
    Future.delayed(
      const Duration(seconds: 1),
      () => showDialog(
          context: context,
          builder: (context) =>
              const CustomDialogue(message: 'Feature coming soon!!')),
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Create New Group'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        child: Column(
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.grey,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: const CircleBorder(),
                    elevation: 10,
                    padding: EdgeInsets.all(18.sp)),
                onPressed: () {},
                child: const Icon(Icons.camera_alt)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Upload Picture',
                style: boldText2,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 4.h,
              ),
              child: const TextField(
                decoration: InputDecoration(
                  labelText: 'Group Name',
                  suffixIcon: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                ),
              ),
            ),
            Text(
              'Participants 3',
              style: boldText2,
            ),
            Flexible(
              child: Row(
                children: [
                  Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: ((context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  const CircleAvatar(
                                    child: Icon(Icons.person),
                                  ),
                                  Text('User $index')
                                ],
                              ),
                            );
                          }))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: const [
                        CircleAvatar(
                          child: Icon(Icons.add),
                        ),
                        Text('Add More')
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
