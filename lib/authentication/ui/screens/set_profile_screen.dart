import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../profile/provider/update_profile_provider.dart';
import '../../../shared/constants/color_gradient.dart';
import '../../../shared/constants/textstyle.dart';
import '../../../shared/constants/url_constants.dart';
import '../../../shared/ui/screens/wrapper.dart';
import '../../../shared/ui/widgets/custom_elevated_button_widget.dart';
import '../../provider/auth_provider.dart';

class SetProfilePage extends StatefulWidget {
  const SetProfilePage({Key? key}) : super(key: key);

  @override
  State<SetProfilePage> createState() => _SetProfilePageState();
}

class _SetProfilePageState extends State<SetProfilePage> {
  String _dob = 'DOB:';
  String _name = '';
  String _bio = '';
  DateTime? dob;
  String? imagePath;
  bool _showBottomSheet = false;
  String? token;
  String? uuid;
  final _form = GlobalKey<FormState>();

  Future<void> _setProfilePicture(bool isCamera) async {
    ImagePicker picker = ImagePicker();
    XFile? xFile = isCamera
        ? await picker.pickImage(source: ImageSource.camera)
        : await picker.pickImage(source: ImageSource.gallery);
    imagePath = xFile?.path;
    setState(() {});
  }

  @override
  void initState() {
    initialise();
    super.initState();
  }

  initialise() async {
    firebaseCloudMessagingListeners();
    uuid = await _getId();
  }

  void firebaseCloudMessagingListeners() async {
    token = await FirebaseMessaging.instance.getToken();
    setState(() {});
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: _showBottomSheet
          ? BottomSheet(
              elevation: 10,
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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Consumer<AuthProvider>(builder: (context, value, widget) {
          if (value.authUserModel != null) {
            _dob = value.authUserModel!.userDob.toString();
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            child: Form(
              key: _form,
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 25.w),
                      Text(
                        'Set Profile',
                        style: boldHeading2,
                      ),
                      SizedBox(width: 15.w),
                      GestureDetector(
                        onTap: () => Navigator.of(context)
                            .pushReplacement(MaterialPageRoute(
                          builder: (context) => const Wrapper(),
                        )),
                        child: Text(
                          'Skip',
                          style: text2,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 6.h, bottom: 2.h),
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
                            decoration: BoxDecoration(
                                gradient: gradient1,
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: const [
                                  BoxShadow(
                                      offset: Offset(2, 2), blurRadius: 10)
                                ]),
                            child: imagePath != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.file(
                                      File(imagePath!),
                                      fit: BoxFit.cover,
                                      height: 15.h,
                                    ))
                                : value.authUserModel != null
                                    ? value.authUserModel!.userImage != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image.network(
                                              '$imgUrl/${value.authUserModel!.userImage}',
                                              fit: BoxFit.cover,
                                              height: 15.h,
                                            ))
                                        : Image.asset(
                                            'assets/images/set-profile.png')
                                    : Image.asset(
                                        'assets/images/set-profile.png'),
                          ),
                          Material(
                              elevation: 10,
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
                    child: TextFormField(
                      initialValue: value.authUserModel != null
                          ? value.authUserModel?.userName ?? _name
                          : _name,
                      // controller: _name,
                      decoration: const InputDecoration(
                        labelText: 'Username:',
                        suffixIcon: Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                        border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _name = newValue!;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 2.h,
                    ),
                    child: TextFormField(
                      initialValue: value.authUserModel != null
                          ? value.authUserModel?.userBio ?? _bio
                          : _bio,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your bio';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _bio = newValue!;
                      },
                      // controller: _bio,
                      decoration: const InputDecoration(
                        labelText: 'Bio:',
                        suffixIcon: Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                        border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2)),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 1.h,
                    ),
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(width: 2))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(value.authUserModel != null
                            ? value.authUserModel?.userDob != null
                                ? DateFormat('dd-MM-yyyy')
                                    .format(value.authUserModel!.userDob)
                                : _dob
                            : _dob),
                        IconButton(
                            color: Colors.black,
                            onPressed: () async {
                              dob = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate:
                                      DateTime(DateTime.now().year - 100),
                                  lastDate: DateTime.now());
                              if (dob != null) {
                                _dob = "${dob!.day}/${dob!.month}/${dob!.year}";
                                setState(() {});
                              }
                            },
                            icon: const Icon(Icons.edit))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  const Text(
                      'Your Details are end-to-end encrypted. Any updates and changes will be visible to your contacts. Know more.'),
                  context.watch<UpdateProfileProvider>().isLoading
                      ? Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            LinearProgressIndicator(
                              minHeight: .7.h,
                            ),
                          ],
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(vertical: 3.h),
                          child: CustomElevatedButton(
                            onPressed: () async {
                              bool isValid = _form.currentState!.validate();
                              if (!isValid) {
                                return;
                              }
                              if (_dob == null &&
                                  value.authUserModel?.userDob == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Please enter your DOB')));
                                return;
                              }
                              if (imagePath == null &&
                                  value.authUserModel?.userImage == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Please enter a picture')));
                                return;
                              }
                              if (token == null) {
                                return;
                              }
                              _form.currentState!.save();
                              if (value.authUserModel != null) {
                                if (value.authUserModel?.userBio != null ||
                                    value.authUserModel?.userName != null ||
                                    value.authUserModel?.userDob != null) {
                                  await context
                                      .read<UpdateProfileProvider>()
                                      .updateProfile(
                                        context,
                                        userId: value.authUserModel!.id,
                                        isFirst: true,
                                        userName: _name,
                                        userBio: _bio,
                                        userImage: imagePath,
                                        uuid: uuid,
                                        fcm: token,
                                        // userNumber: value
                                        // .authUserModel!.userPhoneNumber,
                                      );
                                }
                              } else {
                                context
                                    .read<AuthProvider>()
                                    .joinUserModel
                                    .userName = _name;
                                context
                                    .read<AuthProvider>()
                                    .joinUserModel
                                    .userBio = _bio;
                                if (dob != null) {
                                  context
                                      .read<AuthProvider>()
                                      .joinUserModel
                                      .userDob = dob!;
                                }
                                context
                                    .read<AuthProvider>()
                                    .joinUserModel
                                    .userImage = imagePath!;
                                context
                                    .read<AuthProvider>()
                                    .joinUserModel
                                    .userUid = uuid!;
                                context
                                    .read<AuthProvider>()
                                    .joinUserModel
                                    .userFcm = token!;
                                context.read<AuthProvider>().joinUser(context);
                              }

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const Wrapper(),
                                ),
                              );
                            },
                            width: 70.w,
                            child: Text(
                              'Save',
                              style: text1,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
