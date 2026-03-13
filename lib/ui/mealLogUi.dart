/*
  Author - Kayla Thornton
  Purpose - Make reusable UI component to render logs based on date
 */

import 'package:flutter/material.dart';
import '../models/meal_model.dart';

class MealLogUi extends StatelessWidget {
  final List<MealModel> mealLogs;
  const MealLogUi({super.key, required this.mealLogs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      ListView.builder( // render each log with its name, desc, and date
        itemCount: mealLogs.length,
        itemBuilder: (context, index) {
        final log = mealLogs[index]; // log at current index

          return ListTile(
            title: Text(log.name, style: TextStyle( fontSize: 18 )),
            subtitle: Text(log.desc, style: TextStyle( fontSize: 14, color: Colors.blueGrey )),
            trailing: Text(log.date, style: TextStyle( fontSize: 12, color: Colors.blueGrey )),
          );
        },
      ),
    );
  }
}