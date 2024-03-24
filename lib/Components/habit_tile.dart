import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HabitTile extends StatelessWidget {
  
  final String habitName;
  final bool habitDone;
  final int streak;
  final void Function()? onTap;
  final void Function()? editHabit;

  const HabitTile({super.key,required this.habitDone,required this.habitName,required this.onTap,required this.streak,required this.editHabit});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
              onLongPress: editHabit,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10,left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                    habitDone? FontAwesomeIcons.circleCheck : FontAwesomeIcons.circle ,size: 50,color: habitDone? Colors.green: Theme.of(context).colorScheme.primary),
                    onPressed: onTap,),
                    const SizedBox(width: 15,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(habitName,style: const TextStyle(fontSize: 18),),
                        Text('Streak : $streak Done',style: TextStyle(color: Theme.of(context).colorScheme.primary),)
                      ],
                    )
                ],
              ),
            ),
             Divider(
              color: Theme.of(context)
                  .colorScheme
                  .secondary, // Customize the color of the divider line
              thickness: 0.5, // Set the thickness of the divider line // Set the vertical height of the divider line // Set the right padding of the divider line
            )
          ],
        ),
      ),
    );
  }
}