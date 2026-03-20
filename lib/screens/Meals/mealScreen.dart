/*
  Author - Kayla Thornton
  Purpose - Render all meal logs
 */
import 'package:flutter/material.dart';
import 'package:mad_food_finder/database_helper.dart';
import '../../models/meal_model.dart';
import '../../data/meal_data.dart'; // FOR TESTING ONLY
import 'addLogScreen.dart';
import '../../ui/mealLogUi.dart';

class MealScreen extends StatefulWidget {
  const MealScreen({super.key});

  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // TO-DO store meals by week, month, and all past
  late final List<MealModel> weekLogs;
  late final List<MealModel> monthLogs;
  late final List<MealModel> pastLogs;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMeals();  // CHANGE THIS LINE
  }

  // ADD THIS METHOD
  Future<void> _loadMeals() async {
    setState(() => _isLoading = true);
    try {
      final week = await _databaseHelper.getMealsThisWeek();
      final month = await _databaseHelper.getMealsThisMonth();
      final past = await _databaseHelper.getAllMeals();
      
      setState(() {
        weekLogs = week;
        monthLogs = month;
        pastLogs = past;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading meals: $e');
      setState(() => _isLoading = false);
    }
  }

  // TO-DO get all meals by week, month, and all past and

@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading  // loading screen check
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView( //makes it scrollable
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