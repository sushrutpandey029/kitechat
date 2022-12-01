import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:kite/settings/provider/settings_provider.dart';
import 'package:provider/provider.dart';

import '../../../authentication/provider/auth_provider.dart';
import '../../../shared/constants/color_gradient.dart';

class DelMyAccountPage extends StatefulWidget {
  const DelMyAccountPage({Key? key, required this.number}) : super(key: key);

  final String number;

  @override
  State<DelMyAccountPage> createState() => _DelMyAccountPageState();
}

class _DelMyAccountPageState extends State<DelMyAccountPage> {
  final SingleValueDropDownController _cnt = SingleValueDropDownController();

  String reason = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delete my account"),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: gradient1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'We hate to see you leave! tell us why you are deleting your account',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: DropDownTextField(
                    // initialValue: "name4",
                    controller: _cnt,
                    clearOption: false,
                    validator: (value) {
                      if (value == null) {
                        return "Required field";
                      } else {
                        return null;
                      }
                    },

                    dropDownItemCount: 6,
                    dropDownList: const [
                      DropDownValueModel(
                          name: 'I am changing my device',
                          value: "I am changing my device"),
                      DropDownValueModel(
                        name: 'I am changing my phone number',
                        value: "I am changing my phone number",
                      ),
                      DropDownValueModel(
                          name: 'i am deleting my account temporarily',
                          value: "i am deleting my account temporarily"),
                      DropDownValueModel(
                        name: 'Kite is missing a future',
                        value: "Kite is missing a future",
                      ),
                      DropDownValueModel(
                          name: 'Kite is not working',
                          value: "Kite is not working"),
                      DropDownValueModel(name: 'Other', value: "Other"),
                    ],
                    onChanged: (value) {
                      reason = value.toString();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    // controller: _optionalReason,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2)),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2)),
                      labelText: 'how can we improve ourselves (optional)',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Update user name',
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // foreground
              ),
              onPressed: () {
                context.read<SettingsProvider>().dellAccountReason(
                      context,
                      userId: context.read<AuthProvider>().authUserModel!.id,
                      userName:
                          context.read<AuthProvider>().authUserModel!.userName,
                      userRegNo:
                          context.read<AuthProvider>().authUserModel!.userRegNo,
                      userNumber: widget.number,
                      delReasons: reason,
                    );
              },
              child: const SizedBox(
                height: 40,
                width: 80,
                child: Center(
                  child: Text('Delete'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
