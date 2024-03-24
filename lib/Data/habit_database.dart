import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDataBase extends ChangeNotifier {
  static late Isar isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([HabitSchema], directory: dir.path);
  }

  final List<Habit> habitsList = [];

  Future<void> createNewHabit(Habit newHabit) async {
    await isar.writeTxn(() => isar.habits.put(newHabit));

    // re-read database
    await readHabits();
  }

  Future<void> readHabits() async {
    List<Habit> fetchedHabits = await isar.habits.where().findAll();
    habitsList.clear();
    habitsList.addAll(fetchedHabits);
    notifyListeners();
  }

  Future<void> updateHabits(int id, Habit updatedHabit) async {
    updatedHabit.id = id;
    await isar.writeTxn(() => isar.habits.put(updatedHabit));
    await readHabits();
  }

  Future<void> deleteHabits(int id) async {
    await isar.writeTxn(() => isar.habits.delete(id));
    await readHabits();
  }
}
