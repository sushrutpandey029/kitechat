import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../provider/contact_provider.dart';

class NonRegContacts extends StatefulWidget {
  const NonRegContacts({Key? key}) : super(key: key);

  @override
  State<NonRegContacts> createState() => _NonRegContactsState();
}

class _NonRegContactsState extends State<NonRegContacts> {
  @override
  void initState() {
    context.read<ContactProvider>().getNonRegContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: makeBody(),
    );
  }

  makeBody() {
    return SingleChildScrollView(
      child: Consumer<ContactProvider>(builder: (context, value, widget) {
        value.nonRegContacts.sort(
          (a, b) => a.phones!.first.value!.compareTo(b.phones!.first.value!),
        );
        return value.isLoading
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: value.nonRegContacts.length,
                      itemBuilder: ((context, index) {
                        Contact userModel =
                            value.nonRegContacts.elementAt(index);
                        return Padding(
                          padding: EdgeInsets.only(top: 0.5.h),
                          child: ListTile(
                            // shape: const UnderlineInputBorder(
                            //     borderSide: BorderSide(color: Colors.grey)),
                            leading: const CircleAvatar(
                              child:
                                  // userModel.userImage != null
                                  //     ? Image.asset(userModel.userImage)
                                  // :
                                  Icon(Icons.person),
                            ),
                            title: Text(userModel.displayName!),
                            trailing: SizedBox(
                              width: 35.w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Material(
                                    shape: const CircleBorder(),
                                    elevation: 10,
                                    child: CircleAvatar(
                                      child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.edit)),
                                    ),
                                  ),
                                  Material(
                                    shape: const CircleBorder(),
                                    elevation: 10,
                                    child: CircleAvatar(
                                      child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.call)),
                                    ),
                                  ),
                                  Material(
                                    shape: const CircleBorder(),
                                    elevation: 10,
                                    child: CircleAvatar(
                                      child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.video_call)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })),
                ],
              );
      }),
    );
  }
}
