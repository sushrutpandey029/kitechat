import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../shared/constants/color_gradient.dart';

class PhoneContacts extends StatefulWidget {
  const PhoneContacts({
    Key? key,
    required this.phoneContacts,
  }) : super(key: key);

  final List<Contact> phoneContacts;

  @override
  State<PhoneContacts> createState() => _PhoneContactsState();
}

class _PhoneContactsState extends State<PhoneContacts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invite a friend"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
            },
          )
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: gradient1),
        ),
      ),
      body: SizedBox(
        width: 390,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: widget.phoneContacts.length,
          itemBuilder: (context, index) => Card(
            elevation: 0,
            child: GestureDetector(
              onTap: () {
                _textMe(widget.phoneContacts[index].phones!.first.value!);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CircleAvatar(
                    child: Text(widget.phoneContacts[index].initials()),
                  ),
                  SizedBox(
                    width: 280,
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Text(
                        widget.phoneContacts[index].displayName ?? "",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _textMe(String number) async {
    // Android
    String uri =
        'sms:$number?body=Lets chat on kite! its a fast, simple, and secured app we can use to message and call each other for free get it on (URL) ';
    if (await canLaunchUrlString(uri)) {
      await launchUrlString(uri);
    } else {
      // iOS
      const uri = 'sms:0039-222-060-888?body=hello%20there';
      if (await canLaunchUrlString(uri)) {
        await launchUrlString(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }
}
