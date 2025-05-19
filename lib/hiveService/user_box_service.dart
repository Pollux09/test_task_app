import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_task_app/hiveStorage/user_device.dart';

class UserBoxService {
  
  Box get box => Hive.box("user");

  bool checkWasIntrodution() {
    final values = box.values.toList();

    if (values.isNotEmpty) {
      final UserDevice user = values.first;
      return user.wasIntrodution;
    }
    return false;
  }

  Future<void> addUser() async {
    final values = box.values.toList();

    if (values.isEmpty) {
      final UserDevice user = UserDevice(true);
      await box.add(user);
    }
  }
}

UserBoxService userBoxService = UserBoxService();