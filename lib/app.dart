import 'package:flutter/material.dart';

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

  @override
  State<KiteApp> createState() => _KiteAppState();
}

class _KiteAppState extends State<KiteApp> {
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
        ],
        child: const MaterialApp(
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
