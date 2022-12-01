import 'package:flutter/material.dart';

import '../../../authentication/model/auth_user_model.dart';
import '../../../shared/constants/color_gradient.dart';

class MatcherContact extends StatefulWidget {
  MatcherContact({Key? key, required this.phoneContact}) : super(key: key);

  List<AuthUserModel> phoneContact = [];

  @override
  State<MatcherContact> createState() => _MatcherContactState();
}

class _MatcherContactState extends State<MatcherContact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact'),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: gradient1),
        ),
      ),
      body: SizedBox(
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: widget.phoneContact.length,
          itemBuilder: (context, index) => Card(
            elevation: 0,
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(widget.phoneContact[index].userImage),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Text(
                        style: const TextStyle(color: Colors.black),
                        widget.phoneContact[index].userName,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.phone),
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.video_call,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
