import 'package:flutter/material.dart';

void customNavigator(BuildContext context, Widget destination) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
}
