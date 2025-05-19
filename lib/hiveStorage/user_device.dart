import 'package:hive/hive.dart';

part 'user_device.g.dart';

@HiveType(typeId: 0)
class UserDevice {
  @HiveField(0)
  final bool wasIntrodution;


  UserDevice(this.wasIntrodution);

  UserDevice copyWith({
    bool? wasIntrodution,
  }) {
    return UserDevice(
      wasIntrodution ?? this.wasIntrodution,
    );
  }
}