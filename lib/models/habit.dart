import 'package:isar/isar.dart';

part 'habit.g.dart';

@collection
class Habit{
  Id id = Isar.autoIncrement;
  final String name;
  final List<DateTime> completedDays;

  Habit({required this.name, required this.completedDays});
}