

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:kite/call/ui/screens/call_page.dart';
import 'package:kite/chat/provider/group_provider.dart';
import 'package:kite/util/custom_navigation.dart';

import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'authentication/provider/auth_provider.dart';
import 'authentication/ui/screens/get_started_screen.dart';
import 'chat/provider/chat_provider.dart';
import 'chat/provider/chat_t_provider.dart';
import 'contact/provider/contact_provider.dart';
import 'database/hive_models/auth_hive_model.dart';
import 'database/hive_models/boxes.dart';
import 'profile/provider/update_profile_provider.dart';
import 'settings/provider/settings_provider.dart';
import 'shared/ui/screens/wrapper.dart';

class KiteApp extends StatefulWidget {
  const KiteApp({Key? key}) : super(key: key);
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<KiteApp> createState() => _KiteAppState();
}

class _KiteAppState extends State<KiteApp> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthProvider()),
          ChangeNotifierProvider(create: (context) => ContactProvider()),
          ChangeNotifierProvider(create: (context) => UpdateProfileProvider()),
          ChangeNotifierProvider(create: (context) => ChatProvider()),
          ChangeNotifierProvider(create: (context) => ChatTProvider()),
          ChangeNotifierProvider(create: (context) => SettingsProvider()),
          ChangeNotifierProvider(create: (context) => GroupProvider()),
        ],
        child: MaterialApp(
          navigatorKey: KiteApp.navigatorKey,
          debugShowCheckedModeBanner: false,
          // theme: ThemeData.dark(),
          home: WidgetTest(),
          //
        ),
      );
    });
  }
}

class WidgetTest extends StatefulWidget {
  const WidgetTest({Key? key}) : super(key: key);

  @override
  State<WidgetTest> createState() => _WidgetTestState();
}

class _WidgetTestState extends State<WidgetTest> {
  final myBox = Boxes.getAuthHive();
  AuthHiveModel? authPh = AuthHiveModel()..pNumber = '';

  @override
  void initState() {
    authPh = myBox.get('authPh');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return authPh == null ? const GetStartedPage() : const Wrapper();
  }
}

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  String calleeNumber = receivedAction.payload!['callNumber']!;
  bool isVideo = receivedAction.payload!['isVideo']! == "true"? true:false;
    // Navigate into pages, avoiding to open the notification details page over another details page already opened
    KiteApp.navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => CallPage(calleeNumber: '', isvideo: true)),
        (route) => route==MaterialPageRoute(
            builder: (context) => Wrapper()),
           );
  }
}
