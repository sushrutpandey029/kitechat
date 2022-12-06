import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'database/hive_models/auth_hive_model.dart';
import 'database/hive_models/message_hive_model.dart';

Future<void> backgroundMessageHandler(RemoteMessage event) async {
  Map message = event.toMap();
  log('BackgroudMesage=>${message['data'].toString()}');
  var payload = message['data'];
  var callerName = payload['callerName'] as String;
  var uuid = payload['uuid'] as String;

  // AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //       criticalAlert: true,
  //       autoDismissible: false,
  //       id: 10,
  //       channelKey: 'basic_channel',
  //       title: '$callerName is calling',
  //     ),
  //     actionButtons: [
  //       NotificationActionButton(
  //           key: 'decline',
  //           label: 'Reject',
  //           isDangerousOption: true,
  //           enabled: true,
  //           buttonType: ActionButtonType.Default),
  //       NotificationActionButton(
  //           key: 'accept',
  //           label: 'Accept',
  //           isDangerousOption: true,
  //           enabled: true,
  //           buttonType: ActionButtonType.Default),
  //     ]);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(
    MessageHiveModelAdapter(),
  );
  Hive.registerAdapter(
    AuthHiveModelAdapter(),
  );
  await Hive.openBox<AuthHiveModel>('Auth');
  await Hive.openBox<MessageHiveModel>('Messages');
  await Firebase.initializeApp();
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
          channelGroupKey: 'call_channel_group',
          channelKey: 'call_channel',
          channelName: 'Call notifications',
          channelDescription: 'Notification channel for call tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
          locked: true
        )
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);
  runApp(const KiteApp());
}
