import 'package:hive_flutter/hive_flutter.dart';

import 'auth_hive_model.dart';

class Boxes {
  static Box<AuthHiveModel> getAuthHive() => Hive.box<AuthHiveModel>('Auth');
}
