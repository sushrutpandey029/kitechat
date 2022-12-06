import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomDialogue extends StatelessWidget {
  CustomDialogue({Key? key, required this.message, this.onTap})
      : super(key: key);

  final String message;
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.sp)),
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
            onPressed: () {
              if (onTap != null) {
                print('go back');
                onTap!();
              }
              // Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'))
      ],
    );
  }
}
