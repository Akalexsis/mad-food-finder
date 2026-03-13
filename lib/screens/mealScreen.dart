/*
  Author - Kayla Thornton
  Purpose - Render all meal logs
 */
import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import '../data/meal_data.dart'; // FOR TESTING ONLY
import '../screens/addLogScreen.dart';
import '../ui/mealLogUi.dart';

class MealScreen extends StatefulWidget {
  const MealScreen({super.key});

  @override
  _MealScreenState createState() => _MealScreenState();
}
class _MealScreenState extends State<MealScreen> {
  // TO-DO store meals by week, month, and all past
  late final List<MealModel> weekLogs;
  late final List<MealModel> monthLogs;
  late final List<MealModel> pastLogs;

  void initState(){
    super.initState();
    // call get meals method
  }

  // TO-DO get all meals by week, month, and all past and

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal log', textAlign: TextAlign.center,),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView( // make page scrollable
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              // route to add log screen so users can create new meal log
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute( builder: (context) => AddLogScreen() )
                );
              }, 
              child: Text('New Log')),

            //TO-DO - CHANGE SAMPLE LOGS TO LIST OF LOGS FROM THIS WEEK pass 'weekLogs' to mealLogs 
            sampleLogs.isEmpty ? Text('No logs tracked for this week') : MealLogUi(mealLogs: sampleLogs, header: 'This Week'),

            // TO-DO - GET ALL LOGS FROM THIS MONTH if no logs, display 'no tracked logs' message
            sampleLogs.isEmpty ? Text('No logs tracked for this month') : MealLogUi(mealLogs: sampleLogs, header: 'This Month'),
            
            // TO-DO - GET ALL PAST LOGS if no logs, display 'no tracked logs' message
            sampleLogs.isEmpty ? Text('No past logs tracked') : MealLogUi(mealLogs: sampleLogs, header: 'All Past'),

          ],
        )
      )
    );
  }
}