import 'package:flutter/material.dart';
import 'package:habit_tracker/Data/habit_database.dart';
import 'package:habit_tracker/Pages/home_page.dart';
import 'package:habit_tracker/Themes/dark_mode.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HabitDataBase.initialize();
    runApp(ChangeNotifierProvider(
    create: (context) => HabitDataBase(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: darkMode,
    );
  }
}
