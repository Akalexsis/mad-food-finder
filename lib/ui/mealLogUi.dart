/*
  Author - Kayla Thornton
  Purpose - Make reusable UI component to render logs based on date
 */
import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import '../screens/Meals/mealDetailsScreen.dart';

class MealLogUi extends StatelessWidget {
  final List<MealModel> mealLogs;
  final String header;
  const MealLogUi({super.key, required this.mealLogs, required this.header});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(header, style: TextStyle( fontSize: 18 ), textAlign: TextAlign.start),
        
        ListView.builder(
          itemCount: mealLogs.length,
          shrinkWrap: true, // only take up as much space as needed
          physics: const NeverScrollableScrollPhysics(), // disable scrolling
          
          itemBuilder: (context, index) {
          final log = mealLogs[index];

          return ListTile(
              title: Text(log.name, style: TextStyle( fontSize: 18 )),
              subtitle: Text(log.date, style: TextStyle( fontSize: 12, color: Colors.blueGrey )) ,
              trailing: Text('\$${log.cost}', style: TextStyle( fontSize: 14, color: Colors.lightGreen )),
              onTap: () {
                Navigator.push( 
                  context, 
                  MaterialPageRoute(builder: (context) => MealDetailScreen(log: log)) // navigate to log specific details screen
                );
              },
              );
            },
          ),
        ]
      );
  }
}