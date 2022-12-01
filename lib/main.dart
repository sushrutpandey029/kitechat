import 'dart:developer';

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
  runApp(const KiteApp());
}
