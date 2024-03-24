import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habit_tracker/Components/habit_tile.dart';
import 'package:habit_tracker/Data/habit_database.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  TextEditingController newHabit = TextEditingController();

  void addHabit() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextFormField(
                controller: newHabit,
                decoration: InputDecoration(
                  hintText: "Add a Habit",
                  hintStyle:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                  fillColor: Theme.of(context).colorScheme.secondary,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.tertiary)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary)),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      newHabit.clear();
                    },
                    child: const Text("Cancel")),
                TextButton(
                    onPressed: () {
                      Habit newHabitToAdd =
                          Habit(name: newHabit.text, completedDays: []);
                      context
                          .read<HabitDataBase>()
                          .createNewHabit(newHabitToAdd);
                      Navigator.pop(context);
                      newHabit.clear();
                    },
                    child: const Text("Save"))
              ],
            ));
  }

  void editHabit(currentHabit) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextFormField(
                controller: newHabit,
                decoration: InputDecoration(
                  hintText: currentHabit.name,
                  hintStyle:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                  fillColor: Theme.of(context).colorScheme.secondary,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.tertiary)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary)),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      context
                          .read<HabitDataBase>()
                          .deleteHabits(currentHabit.id);
                      Navigator.pop(context);
                      newHabit.clear();
                    },
                    child: const Text("Delete")),
                TextButton(
                    onPressed: () {
                      Habit newHabitToAdd = Habit(
                          name: newHabit.text,
                          completedDays: currentHabit.completedDays);
                      context
                          .read<HabitDataBase>()
                          .updateHabits(currentHabit.id, newHabitToAdd);
                      Navigator.pop(context);
                      newHabit.clear();
                    },
                    child: const Text("Save"))
              ],
            ));
  }

  habitDone(Habit currentHabit) {
    if (currentHabit.completedDays.contains(
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day))) {
      currentHabit.completedDays.remove(
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day));
    } else {
      currentHabit.completedDays.add(
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day));
    }
    context.read<HabitDataBase>().updateHabits(currentHabit.id, currentHabit);
  }

  void selectedDateChange(DateTime dateTimeselected) {
    setState(() {
      selectedDate = dateTimeselected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final habitDatabase = context.watch<HabitDataBase>();
    context.read<HabitDataBase>().readHabits();
    List<Habit> currentHabits = habitDatabase.habitsList;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 80,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text("Habits"),
        actions: [
          IconButton(
              onPressed: () => addHabit(),
              icon: const Icon(
                FontAwesomeIcons.plus,
                size: 20,
              ))
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            availableGestures: AvailableGestures.horizontalSwipe,
            rowHeight: 65,
            startingDayOfWeek: StartingDayOfWeek.monday,
            daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
                weekendStyle: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary)),
            calendarStyle: CalendarStyle(
              weekendTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),
              todayDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle),
              rowDecoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.secondary),
            ),
            calendarFormat: CalendarFormat.week,
            headerVisible: false,
            firstDay: DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            currentDay: selectedDate,
            focusedDay: selectedDate,
            onPageChanged: (focusedDay) {
              selectedDateChange(focusedDay);
            },
            onDaySelected: (dayselected, dayselected2) =>
                selectedDateChange(dayselected),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView.builder(
                  itemCount: currentHabits.length,
                  itemBuilder: (context, index) {
                    DateTime todayForStreak = DateTime.now();
                    int streak = 0;
                    while (true) {
                      if (!currentHabits[index].completedDays.contains(DateTime(
                          todayForStreak.year,
                          todayForStreak.month,
                          todayForStreak.day))) {
                        break;
                      } else {
                        streak += 1;
                        todayForStreak =
                            todayForStreak.subtract(const Duration(days: 1));
                      }
                    }
                    final habitName = currentHabits[index].name;
                    final isHabitDone = currentHabits[index]
                        .completedDays
                        .contains(DateTime(selectedDate.year,
                            selectedDate.month, selectedDate.day));
                    return HabitTile(
                      habitDone: isHabitDone,
                      habitName: habitName,
                      onTap: () => habitDone(currentHabits[index]),
                      editHabit: () => editHabit(currentHabits[index]),
                      streak: streak,
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}
