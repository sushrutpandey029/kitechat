import 'package:dio/dio.dart';

import '../../authentication/model/auth_user_model.dart';
import '../../shared/constants/url_constants.dart';

class ContactRepo {
  final String _kiteApi = '$baseUrl/Kiteapi_controller';

  Future<List<AuthUserModel>> getContacts() async {
    String url = '$_kiteApi/join_user_list';
    try {
      List<AuthUserModel> list = [];

      Response response = await Dio().post(url);

      // print(response.data["data"][0]);
      for (Map<String, dynamic> contact in response.data["Alluser"]) {
        list.add(AuthUserModel.fromMap(contact));
      }
      return list;
    } on DioError {
      rethrow;
    }
  }
}
