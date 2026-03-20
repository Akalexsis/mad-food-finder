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

  List<MealModel> weekLogs = [];    // CHANGED: removed late final
  List<MealModel> monthLogs = [];   // CHANGED: removed late final
  List<MealModel> pastLogs = [];    // CHANGED: removed late final
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Log', textAlign: TextAlign.center),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(                              // CHANGE 5: Added RefreshIndicator
              onRefresh: _loadMeals,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),  // CHANGE 5: Added physics
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(                                // CHANGE 6: Added Padding
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {               // CHANGE 6: Made async
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddLogScreen()),
                          );
                          _loadMeals();                     // CHANGE 6: Refresh after adding
                        },
                        child: Text('New Log'),
                      ),
                    ),

                    // CHANGE 7: Replace sampleLogs with weekLogs
                    weekLogs.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('No logs tracked for this week'),
                          )
                        : MealLogUi(mealLogs: weekLogs, header: 'This Week'),

                    // CHANGE 7: Replace sampleLogs with monthLogs
                    monthLogs.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('No logs tracked for this month'),
                          )
                        : MealLogUi(mealLogs: monthLogs, header: 'This Month'),

                    // CHANGE 7: Replace sampleLogs with pastLogs
                    pastLogs.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('No past logs tracked'),
                          )
                        : MealLogUi(mealLogs: pastLogs, header: 'All Past'),
                  ],
                ),
              ),
            ),
    );
  }
}