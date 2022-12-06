import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../chat/provider/chat_provider.dart';
import '../../../chat/provider/chat_t_provider.dart';
import '../../../shared/constants/textstyle.dart';
import '../../../shared/ui/widgets/custom_app_bar.dart';
import '../../provider/contact_provider.dart';

class AddNewContactScreen extends StatefulWidget {
  const AddNewContactScreen({Key? key, this.name, this.number})
      : super(key: key);
  final String? name;
  final String? number;

  @override
  State<AddNewContactScreen> createState() => _AddNewContactScreenState();
}

class _AddNewContactScreenState extends State<AddNewContactScreen> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    nameController.text = widget.name ?? "";
    numberController.text = widget.number ?? "";
    _askPermissions();
  }

  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      const snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      const snackBar =
          SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> saveContactInPhone() async {
    try {
      setState(() {
        isLoading = true;
      });
      print("saving Conatct");
      PermissionStatus permission = await Permission.contacts.status;

      if (permission != PermissionStatus.granted) {
        await Permission.contacts.request();
        PermissionStatus permission = await Permission.contacts.status;

        if (permission == PermissionStatus.granted) {
          Contact newContact = Contact();
          newContact.givenName = nameController.text;
          // newContact.emails = [
          //   Item(label: "email", value: myController3.text)
          // ];
          // newContact.company = myController2.text;
          newContact.phones = [
            Item(label: "mobile", value: numberController.text)
          ];
          // newContact.postalAddresses = [
          //   PostalAddress(region: myController6.text)
          // ];
          await ContactsService.addContact(newContact);
        } else {
          //_handleInvalidPermissions(context);
        }
      } else {
        Contact newContact = Contact();
        newContact.givenName = nameController.text;

        newContact.phones = [
          Item(label: "mobile", value: numberController.text)
        ];

        await ContactsService.addContact(newContact);
      }
      await context.read<ContactProvider>().matchContacts(context);
      final userModel = await context
          .read<ContactProvider>()
          .finalContacts
          .where((element) => element.userPhoneNumber == widget.number)
          .first;
          //todo: pop until reach home
      context
          .read<ChatTProvider>()
          .selectUser(context, 0, true, userModel, isscanned: true);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  // addContact(String fName, String lName, String phone) {}
  //
  // saveContact(Contact _contact) async {
  //   await ContactsService.addContact(_contact);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Add New Contact'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 2.h,
              ),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: ' First Name',
                  suffixIcon: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                ),
                controller: nameController,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 2.h,
              ),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Mobile number',
                  suffixIcon: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                ),
                controller: numberController,
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: const BorderSide(
                      color: Colors.teal,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 12,
                      width: 12,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Submit',
                      style: whiteText1,
                    ),
              onPressed: () {
                saveContactInPhone();
              },
            )
          ],
        ),
      ),
    );
  }
}
