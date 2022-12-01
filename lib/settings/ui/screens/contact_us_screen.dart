import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';

import '../../../shared/constants/color_gradient.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final SingleValueDropDownController _cnt = SingleValueDropDownController();
  String reason = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact us'),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: gradient1),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Contact us',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              color: Colors.black12,
              height: 300,
              child: const TextField(
                expands: true,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'How can we help you',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Tell us why are you reaching out',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                    name: 'Kite is not working', value: "Kite is not working"),
                DropDownValueModel(name: 'Other', value: "Other"),
              ],
              onChanged: (value) {
                reason = value.toString();
              },
            ),
          ),
          const SizedBox(
            height: 150,
          ),
          Row(
            children: const <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Choose sending option',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                width: 120,
              ),
              Align(
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
