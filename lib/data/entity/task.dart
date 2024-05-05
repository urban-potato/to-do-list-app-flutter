import 'package:hive_flutter/hive_flutter.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  Task({
    required this.name,
    required this.details,
    required this.dateTime,
  });

  @HiveField(0)
  String name;

  @HiveField(1)
  String details;

  @HiveField(2)
  DateTime dateTime;

  @HiveField(3)
  bool isDone = false;
}
