import 'package:hive/hive.dart';

part 'TripsHiveModel.g.dart'; // ✅ Required for code generation

@HiveType(typeId: 0)
class TripsHiveModel extends HiveObject {
  @HiveField(0)
  String prompt;

  @HiveField(1)
  String response;

  @HiveField(2)
  DateTime createdAt;

  TripsHiveModel({
    required this.prompt,
    required this.response,
    required this.createdAt,
  });
}
