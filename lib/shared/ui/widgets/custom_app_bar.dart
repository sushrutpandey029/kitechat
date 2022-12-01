import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../constants/color_gradient.dart';
import '../../constants/textstyle.dart';

AppBar customAppBar(
  String title, {
  bool backButton = false,
  List<Widget>? actions,
}) {
  if (backButton) {
    actions?.add(Builder(builder: (context) {
      return IconButton(
          iconSize: 24.sp,
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
          icon: const Icon(Icons.menu));
    }));
  }
  return AppBar(
    title: Text(
      title,
      style: heading2,
    ),
    automaticallyImplyLeading: backButton,
    actions: actions,
    flexibleSpace: Container(
      decoration: BoxDecoration(gradient: gradient1),
    ),
  );
}
