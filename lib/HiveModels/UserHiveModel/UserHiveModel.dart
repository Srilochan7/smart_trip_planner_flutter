import 'package:hive/hive.dart';

part 'UserHiveModel.g.dart';

@HiveType(typeId: 0)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  String data; // Whatever you want to store

  UserHiveModel({required this.data});
}
