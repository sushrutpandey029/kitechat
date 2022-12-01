import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:convert';

import 'package:flutter/rendering.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../authentication/model/auth_user_model.dart';
import '../../../authentication/provider/auth_provider.dart';
import '../../../shared/constants/color_gradient.dart';
import '../../../shared/constants/textstyle.dart';
import '../../../util/custom_navigation.dart';
import 'qr_scanner_screen.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({Key? key}) : super(key: key);

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  final GlobalKey _globalKey = GlobalKey();

  Future<Uint8List?> _capturePng() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData!.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      print(pngBytes);
      print(bs64);
      setState(() {});
      return pngBytes;
    } catch (e) {
      print(e);
      return null;
    }
  }

  _incrementCounter() async {
    var imageUint8List = await _capturePng();
    await WcFlutterShare.share(
        sharePopupTitle: 'share',
        fileName: 'share.png',
        mimeType: 'image/png',
        text: 'Scan this Qr to join me on kite',
        bytesOfFile: imageUint8List);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AuthUserModel userModel =
        Provider.of<AuthProvider>(context, listen: false).authUserModel!;
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR code"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.qr_code_scanner,
              color: Colors.white,
            ),
            onPressed: () {
              customNavigator(
                context,
                const QrScannerScreen(),
              ); // do something
            },
          )
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: gradient1),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 226, 226, 226),
                    borderRadius: BorderRadius.circular(10.sp)),
                child: RepaintBoundary(
                  key: _globalKey,
                  child: Container(
                    color: Colors.lightBlueAccent,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, top: 20, bottom: 30),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: 300,
                            height: 390,
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 1.h,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 1.h),
                                  child: Material(
                                    elevation: 20,
                                    color: const Color.fromARGB(
                                        255, 162, 213, 255),
                                    shape: const CircleBorder(),
                                    child: Padding(
                                      padding: EdgeInsets.all(18.sp),
                                      child: Text(
                                        userModel.userName[0],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.sp),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  userModel.userName,
                                  style: text1,
                                ),
                                const Text(
                                  "kite contact",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                QrImage(
                                  size: 225,
                                  backgroundColor: Colors.white,
                                  data:
                                      '${userModel.userName} . ${userModel.userPhoneNumber}',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          const FittedBox(
                            child: Text(
                              "Scan this QR code using Kite camera to get my number",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white70),
                            ),
                          ),
                          // const Text(
                          //   "",
                          //   style: TextStyle(
                          //       fontSize: 15,
                          //       fontWeight: FontWeight.w300,
                          //       color: Colors.white70),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: FittedBox(
                child: Text(
                  'This QR code is private. Your friends can add you by scanning it through thier camera to the Kite as a contact',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.content_copy,
                  ),
                  color: Colors.blue,
                ),
                IconButton(
                  onPressed: () async {
                    await _incrementCounter();
                  },
                  icon: const Icon(
                    Icons.share,
                  ),
                  color: Colors.blue,
                ),
              ],
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     customNavigator(context, const QrScannerScreen());
            //   },
            //   child: const Text('QR Scanner'),
            // ),
          ],
        ),
      ),
    );
  }
}
