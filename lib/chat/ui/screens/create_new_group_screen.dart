import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kite/chat/model/add_group_model.dart';
import 'package:kite/chat/provider/group_provider.dart';
import 'package:provider/provider.dart';

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
  TextEditingController _groupName = TextEditingController();
  TextEditingController _groupDescription = TextEditingController();
  String? imagePath;
  Future<void> _setProfilePicture(bool isCamera) async {
    ImagePicker picker = ImagePicker();
    XFile? xFile = isCamera
        ? await picker.pickImage(source: ImageSource.camera)
        : await picker.pickImage(source: ImageSource.gallery);
    imagePath = xFile?.path;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Create New Group'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Consumer<GroupProvider>(
            builder: (context,value,widget) {
              return Column(
                children: [
                  imagePath == null
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.grey,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              shape: const CircleBorder(),
                              elevation: 10,
                              padding: EdgeInsets.all(18.sp)),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => BottomSheet(
                                    elevation: 10,
                                    onClosing: () {},
                                    builder: (context) {
                                      return Container(
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            boxShadow: const [
                                              BoxShadow(
                                                  color:
                                                      Color.fromARGB(204, 60, 60, 60),
                                                  offset: Offset(0, -4),
                                                  blurRadius: 15)
                                            ]),
                                        height: 18.h,
                                        padding: EdgeInsets.only(top: 2.5.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 1.h),
                                                  child: Material(
                                                      elevation: 10,
                                                      shape: const CircleBorder(),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(10.sp),
                                                        child: IconButton(
                                                            iconSize: 25.sp,
                                                            color: Colors.blueAccent,
                                                            onPressed: () async {
                                                              await _setProfilePicture(
                                                                  true);
                                                              Navigator.pop(context);
                                                            },
                                                            icon: const Icon(
                                                                Icons.camera_alt)),
                                                      )),
                                                ),
                                                const Text('Camera')
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 1.h),
                                                  child: Material(
                                                    elevation: 10,
                                                    shape: const CircleBorder(),
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.all(10.sp),
                                                        child: IconButton(
                                                          iconSize: 25.sp,
                                                          onPressed: () async {
                                                            await _setProfilePicture(
                                                                false);
                                                            Navigator.pop(context);
                                                          },
                                                          icon: Image.asset(
                                                              'assets/images/gallery.png'),
                                                        )),
                                                  ),
                                                ),
                                                const Text('Gallery')
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }));
                          },
                          child: const Icon(Icons.camera_alt))
                      : CircleAvatar(
                          radius: 28.sp,
                          foregroundImage: FileImage(File(imagePath!)),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Upload Picture',
                      style: boldText2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 2.h,
                    ),
                    child: TextField(
                      controller: _groupName,
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
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 2.h,
                    ),
                    child: TextField(
                      controller: _groupDescription,
                      decoration: InputDecoration(
                        labelText: 'Group Description',
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
                  // Text(
                  //   'Participants 3',
                  //   style: boldText2,
                  // ),
                  // SizedBox(
                  //   height: 20.h,
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //           child: ListView.builder(
                  //             shrinkWrap: true,
                  //               scrollDirection: Axis.horizontal,
                  //               itemCount: 3,
                  //               itemBuilder: ((context, index) {
                  //                 return Padding(
                  //                   padding: const EdgeInsets.all(8.0),
                  //                   child: Column(
                  //                     children: [
                  //                       const CircleAvatar(
                  //                         child: Icon(Icons.person),
                  //                       ),
                  //                       Text('User $index')
                  //                     ],
                  //                   ),
                  //                 );
                  //               }))),
                  //       Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Column(
                  //           children: const [
                  //             CircleAvatar(
                  //               child: Icon(Icons.add),
                  //             ),
                  //             Text('Add More')
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  
                  value.isCreating?
                  CircularProgressIndicator()
                  :
                  ElevatedButton(
                      onPressed: () {
                        if (imagePath == null) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Please Select a picture')));
                          return;
                        } else {
                          value.createGroup(
                              AddGroupModel(
                                  userId: '',
                                  userRegNo: '',
                                  userName: '',
                                  userNumber: '',
                                  groupName: _groupName.text,
                                  groupImage: imagePath!,
                                  groupDescription: _groupDescription.text),
                              context);
                        }
                      },
                      child: Text('Create Group'))
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
