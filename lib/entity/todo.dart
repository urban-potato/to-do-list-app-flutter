import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class ToDo extends Equatable {
  const ToDo({
    required this.name,
    required this.details,
    required this.dateTime,
  });

  @HiveField(0)
  final String name;

  @HiveField(1)
  final String details;

  @HiveField(2)
  final DateTime dateTime;

  @HiveField(3)
  final bool done = false;

  @override
  List<Object> get props => [name, details, dateTime];
}
