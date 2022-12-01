import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../authentication/provider/auth_provider.dart';
import '../../../shared/constants/color_gradient.dart';
import '../../../shared/constants/url_constants.dart';
import '../../../shared/ui/widgets/custom_app_bar.dart';
import '../../provider/update_profile_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _number = TextEditingController();
  bool _showBottomSheet = false;
  // DateTime? dob;
  String? imagePath;
  bool isNameChanged = false;
  bool isBioChanged = false;
  bool isImageChanged = false;
  bool isNumberChanged = false;
  bool isProcessing = false;
  Future<void> _setProfilePicture(bool isCamera) async {
    ImagePicker picker = ImagePicker();
    XFile? xFile = isCamera
        ? await picker.pickImage(source: ImageSource.camera)
        : await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      imagePath = xFile?.path;
      isImageChanged = true;
    });
  }

  @override
  void initState() {
    _userName.text = context.read<AuthProvider>().authUserModel!.userName;
    _bio.text = context.read<AuthProvider>().authUserModel!.userBio;
    _number.text = context.read<AuthProvider>().authUserModel!.userPhoneNumber;

    super.initState();
  }

  final TextEditingController _newMediaLinkAddressController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomSheet: _showBottomSheet
          ? BottomSheet(
              elevation: 10,
              // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              onClosing: () {},
              builder: (context) {
                return Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromARGB(204, 60, 60, 60),
                            offset: Offset(0, -4),
                            blurRadius: 15)
                      ]),
                  height: 18.h,
                  padding: EdgeInsets.only(top: 2.5.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                            child: Material(
                                elevation: 10,
                                shape: const CircleBorder(),
                                child: Padding(
                                  padding: EdgeInsets.all(10.sp),
                                  child: IconButton(
                                      iconSize: 25.sp,
                                      color: Colors.blueAccent,
                                      onPressed: () {
                                        setState(() {
                                          _showBottomSheet = !_showBottomSheet;
                                        });
                                        _setProfilePicture(true);
                                      },
                                      icon: const Icon(Icons.camera_alt)),
                                )),
                          ),
                          const Text('Camera')
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                            child: Material(
                              elevation: 10,
                              shape: const CircleBorder(),
                              child: Padding(
                                  padding: EdgeInsets.all(10.sp),
                                  child: IconButton(
                                    iconSize: 25.sp,
                                    onPressed: () {
                                      setState(() {
                                        _showBottomSheet = !_showBottomSheet;
                                      });
                                      _setProfilePicture(false);
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
              })
          : null,
      appBar: customAppBar('Profile', backButton: true),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
          child: Consumer<AuthProvider>(builder: (context, value, widget) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _showBottomSheet = !_showBottomSheet;
                      });
                    },
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 30.w,
                          height: 30.w,
                          decoration: BoxDecoration(
                              gradient: gradient1,
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: const [
                                BoxShadow(offset: Offset(2, 2), blurRadius: 10)
                              ]),
                          child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              foregroundImage: imagePath == null
                                  ? NetworkImage(
                                      '$imgUrl/${value.authUserModel!.userImage}')
                                  : FileImage(File(imagePath!))
                                      as ImageProvider,
                              child:
                                  Image.asset('assets/images/set-profile.png')),
                        ),
                        Material(
                            elevation: 8,
                            shape: const CircleBorder(),
                            child: Padding(
                              padding: EdgeInsets.all(10.sp),
                              child: const Icon(Icons.camera_alt_outlined),
                            ))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 2.h,
                  ),
                  child: TextField(
                    readOnly: true,
                    controller: _userName,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2)),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2)),
                      labelText: 'Username:',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Update user name',
                        onPressed: () {
                          showNameDialog();
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 2.h,
                  ),
                  child: TextField(
                    readOnly: true,
                    controller: _bio,
                    decoration: InputDecoration(
                        border: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2)),
                        enabledBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2)),
                        labelText: 'Bio:',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Update user bio',
                          onPressed: () {
                            showBioDialog();
                          },
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 2.h,
                  ),
                  child: TextField(
                    readOnly: true,
                    controller: _number,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2)),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2)),
                      labelText: 'Number:',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Update user bio',
                        onPressed: () {
                          showNumberDialog();
                        },
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            );
          }),
        ),
      ),
    );
  }

  Future<void> showNameDialog() async {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 18.0, right: 18, top: 18),
            child: Text(
              'Enter new name',
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: buildNameFormField(),
          ),
          const SizedBox(height: 8.8),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: TextButton(
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () async {
                      await context.read<UpdateProfileProvider>().updateProfile(
                            context,
                            userId:
                                context.read<AuthProvider>().authUserModel!.id,
                            userName: isNameChanged ? _userName.text : null,
                            userBio: isBioChanged ? _bio.text : null,
                            userNumber: isNumberChanged ? _number.text : null,
                            userImage: isImageChanged ? imagePath : null,
                          );
                      if (isBioChanged) {
                        isBioChanged = false;
                      }
                      if (isImageChanged) {
                        isImageChanged = false;
                      }
                      if (isNameChanged) {
                        isNameChanged = false;
                      }
                      if (isNumberChanged) {
                        isNumberChanged = false;
                      }

                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: TextButton(
                    child: const Text(
                      'Exit',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8.8),
        ],
      ),
    );
  }

  TextField buildNameFormField() {
    return TextField(
      controller: _userName,
      decoration: const InputDecoration(hintText: 'Enter new Username'),
      onChanged: (text) {
        if (!isNameChanged) {
          isNameChanged = true;
        }
      },
    );
  }

  Future<void> showBioDialog() async {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 18.0, right: 18, top: 18),
            child: Text(
              'Enter new bio',
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: buildBioFormField(),
          ),
          const SizedBox(height: 8.8),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: TextButton(
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () async {
                      await context.read<UpdateProfileProvider>().updateProfile(
                            context,
                            userId:
                                context.read<AuthProvider>().authUserModel!.id,
                            userName: isNameChanged ? _userName.text : null,
                            userBio: isBioChanged ? _bio.text : null,
                            userNumber: isNumberChanged ? _number.text : null,
                            userImage: isImageChanged ? imagePath : null,
                          );
                      if (isBioChanged) {
                        isBioChanged = false;
                      }
                      if (isImageChanged) {
                        isImageChanged = false;
                      }
                      if (isNameChanged) {
                        isNameChanged = false;
                      }
                      if (isNumberChanged) {
                        isNumberChanged = false;
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: TextButton(
                    child: const Text(
                      'Exit',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8.8),
        ],
      ),
    );
  }

  TextField buildBioFormField() {
    return TextField(
      controller: _bio,
      decoration: const InputDecoration(hintText: 'Enter new bio'),
      onChanged: (text) {
        if (!isBioChanged) {
          isBioChanged = true;
        }
      },
    );
  }

  Future<void> showNumberDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update bio'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Enter new number'),
                buildnumberFormField(),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Update'),
              onPressed: () async {
                await context.read<UpdateProfileProvider>().updateProfile(
                      context,
                      userId: context.read<AuthProvider>().authUserModel!.id,
                      userName: isNameChanged ? _userName.text : null,
                      userBio: isBioChanged ? _bio.text : null,
                      userNumber: isNumberChanged ? _number.text : null,
                      userImage: isImageChanged ? imagePath : null,
                    );
                if (isBioChanged) {
                  isBioChanged = false;
                }
                if (isImageChanged) {
                  isImageChanged = false;
                }
                if (isNameChanged) {
                  isNameChanged = false;
                }
                if (isNumberChanged) {
                  isNumberChanged = false;
                }
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Exit'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  TextField buildnumberFormField() {
    return TextField(
        controller: _number,
        decoration: const InputDecoration(hintText: 'Enter new number'),
        onChanged: (text) {
          if (!isNumberChanged) {
            isNumberChanged = true;
          }
        });
  }
}
