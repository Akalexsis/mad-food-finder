/*
  Author - Kayla Thornton
  Purpose - Render all meal logs
 */
import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import '../data/meal_data.dart';

class MealScreen extends StatefulWidget {
  const MealScreen({super.key});

  @override
  _MealScreenState createState() => _MealScreenState();
}
class _MealScreenState extends State<MealScreen> {
  // store meals by week, month, and all past
  late final List<MealModel> weekMeals;
  late final List<MealModel> monthMeals;
  late final List<MealModel> pastMeals;

  void initState(){
    super.initState();
    // call get meals method
  }

  // get all meals by week, month, and all past

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal log', textAlign: TextAlign.center,),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
            // conditionally render meal logs TO-DO - CHANGE SAMPLE LOGS TO LIST OF MEAL LOGS
            sampleLogs.isEmpty ? Text('No logs for this time') : 
            
            Expanded( // render each log with it's name, desc, and date
              child: ListView.builder(
                itemCount: sampleLogs.length,
                itemBuilder: (context, index) {
                  final log = sampleLogs[index];

                  return ListTile(
                    title: Text(log.name, style: TextStyle( fontSize: 18 )),
                    subtitle: Text(log.desc, style: TextStyle( fontSize: 14, color: Colors.blueGrey )),
                    trailing: Text(log.date, style: TextStyle( fontSize: 12, color: Colors.blueGrey )),
                  );
                },
              ),
            ),
        ],
      )
    );
  }
}