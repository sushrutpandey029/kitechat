import 'package:flutter/material.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/custom_dialouge.dart';

class ThemesandModesPage extends StatefulWidget {
  const ThemesandModesPage({super.key});

  @override
  State<ThemesandModesPage> createState() => _ThemesandModesPageState();
}

class _ThemesandModesPageState extends State<ThemesandModesPage> {
  @override
  void didChangeDependencies() {
    Future.delayed(
      const Duration(seconds: 1),
      () => showDialog(
          context: context,
          builder: (context) =>
              CustomDialogue(message: 'Feature coming soon!!')),
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Themes and Modes'),
      body: Column(
        children: [],
      ),
    );
  }
}
