import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kite/shared/ui/widgets/custom_snack_bar.dart';
import 'package:provider/provider.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../authentication/provider/auth_provider.dart';
import '../../../call/ui/screens/call_list.dart';
import '../../../chat/provider/chat_provider.dart';
import '../../../chat/provider/chat_t_provider.dart';
import '../../../chat/provider/group_provider.dart';
import '../../../chat/ui/screens/chat_listing_screen.dart';
import '../../../contact/provider/contact_provider.dart';
import '../../../contact/ui/screens/contact_list.dart';
import '../../../database/hive_models/auth_hive_model.dart';
import '../../../database/hive_models/boxes.dart';
import '../../../settings/ui/screens/setting_screen.dart';
import '../../../util/custom_navigation.dart';
import '../../../web_search/ui/screen/web_search_screen.dart';
import '../../constants/color_gradient.dart';
import '../../constants/url_constants.dart';
import '../widgets/app_drawer.dart';
import '../widgets/custom_app_bar.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> with WidgetsBindingObserver {
  final myBox = Boxes.getAuthHive();
  AuthHiveModel? authPh = AuthHiveModel()..pNumber = '';
  String? userId;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    context.read<ContactProvider>().matchContacts(context).then((value) async {
      await context.read<ContactProvider>().getNonRegContacts();
    });

    authPh = myBox.get('authPh');
    context
        .read<AuthProvider>()
        .getUser(authPh!.pNumber)
        .then((value) => context.read<ChatTProvider>().fetchChatUsers(context))
        .then((value) => context.read<GroupProvider>().getGroupById(
            context.read<AuthProvider>().authUserModel!.id, context));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setonline();
    } else {
      setoffline();
    }
  }

  void setonline() async {
    String url = '$baseUrl/Kiteapi_controller/update_user_online';
    userId = context.read<AuthProvider>().authUserModel!.id;
    try {
      Response response = await Dio()
          .post(url, data: {"user_id": userId!, "user_status": 'online'});
      log(response.toString());
      print('status online');
    } on DioError {
      rethrow;
    }
  }

  void setoffline() async {
    String url = '$baseUrl/Kiteapi_controller/update_user_offline';
    userId = context.read<AuthProvider>().authUserModel!.id;
    try {
      Response response = await Dio()
          .post(url, data: {"user_id": userId!, "user_status": 'offline'});
      log(response.toString());
      print('status offline');
    } on DioError {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SizedBox(height: 85.h, child: const AppDrawer()),
      appBar: customAppBar(
        'KITE',
        backButton: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              size: 24.sp,
            ),
            onPressed: () {
              showCustomSnackBar(context);
            },
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Material(
          elevation: 10,
          color: Theme.of(context).scaffoldBackgroundColor,
          shape: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FloatingActionButton(
              elevation: 10,
              onPressed: () {
                customNavigator(context, const ContactListPage());
              },
              child: Icon(
                Icons.add,
                size: 30.sp,
              ),
            ),
          )),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.transparent,
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 7.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(6.h)),
              gradient: gradient1,
              boxShadow: [
                BoxShadow(
                    color: const Color.fromARGB(204, 60, 60, 60),
                    offset: Offset(0, -1.h),
                    blurRadius: 20)
              ]),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            IconButton(
                iconSize: 28.sp,
                onPressed: () {
                  customNavigator(context, const WebSearchPage());
                },
                icon: Image.asset(
                  'assets/images/web-search.png',
                  fit: BoxFit.cover,
                )),
            IconButton(
                iconSize: 24.sp,
                onPressed: () {
                  customNavigator(context, const CallListPage());
                },
                icon: const Icon(Icons.call)),
            SizedBox(
              width: 10.w,
            ),
            IconButton(
                iconSize: 26.sp,
                onPressed: () {},
                icon: Image.asset(
                  'assets/images/message.png',
                  fit: BoxFit.cover,
                )),
            IconButton(
                iconSize: 24.sp,
                onPressed: () {
                  customNavigator(context, const SettingPage());
                },
                icon: const Icon(Icons.settings)),
          ]),
        ),
      ),
      body: context.watch<ChatTProvider>().isLoading
          ? const Center(child: CircularProgressIndicator())
          : const ChatListingPage(),
    );
  }
}
