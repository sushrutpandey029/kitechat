import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../authentication/model/auth_user_model.dart';
import '../../authentication/provider/auth_provider.dart';
import '../repository/contact_repo.dart';

class ContactProvider extends ChangeNotifier {
  final ContactRepo _contactRepo = ContactRepo();
  bool isLoading = false;
  List<Contact> phoneContact = [];
  List<AuthUserModel> regContacts = [];
  List<AuthUserModel> finalContacts = [];
  List<Contact> nonRegContacts = [];

  Future<void> getPhoneContacts() async {
    await _askPermissions();
    phoneContact = await ContactsService.getContacts();

    // for (var element in phoneContact) {
    //   print("Contact from phone");
    //   if (element.phones!.isNotEmpty) {
    //     print(element.phones!.first.value!.replaceAll(' ', ''));
    //   }
    // }
  }

  Future<void> getRegContacts() async {
    regContacts = await _contactRepo.getContacts();
    // print(regContacts);
    // for (var element in regContacts) {
    //   print("Contact from database");
    // }
  }

  Future<void> matchContacts(BuildContext context) async {
    isLoading = true;
    finalContacts = [];
    await getPhoneContacts();
    await getRegContacts();
    for (var contact in phoneContact) {
      finalContacts.addAll(regContacts.where((element) {
        if (contact.phones!.isNotEmpty) {
          return contact.phones!.first.value!.replaceAll(' ', '') ==
              element.userPhoneNumber;
        } else {
          return false;
        }
      }));
    }
    finalContacts.removeWhere(
      (element) =>
          element.userPhoneNumber ==
          context.read<AuthProvider>().authUserModel!.userPhoneNumber,
    );
    isLoading = false;
    notifyListeners();
  }

  Future<void> getNonRegContacts() async {
    isLoading = true;
    await getPhoneContacts();
    nonRegContacts.addAll(phoneContact);
    await getRegContacts();
    for (var regContact in regContacts) {
      nonRegContacts.removeWhere(
        (element) =>
            regContact.userPhoneNumber ==
            element.phones!.first.value!.replaceAll(' ', ''),
      );
    }
    isLoading = false;
    notifyListeners();
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
      // final snackBar = SnackBar(content: Text('Access to contact data denied'));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      // final snackBar =
      // SnackBar(content: Text('Contact data not available on device'));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
