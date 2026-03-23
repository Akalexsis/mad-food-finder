/*
  Author - Kayla Thornton
  Purpose - Render all meal logs
 */
import 'package:flutter/material.dart';
import '/models/meal_model.dart';
import '/database_helper.dart';
import '../Meals/addLogScreen.dart';
import '/ui/mealLogUi.dart';

class MealScreen extends StatefulWidget {
  const MealScreen({super.key});

  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  
  List<MealModel> weekLogs = [];
  List<MealModel> monthLogs = [];
  List<MealModel> pastLogs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    setState(() => _isLoading = true);
    
    try {
      final week = await _dbHelper.getMealsThisWeek();
      final month = await _dbHelper.getMealsThisMonth();
      final past = await _dbHelper.getAllMeals();
      
      //  MOUNTED CHECK: Only update state if widget is still mounted
      if (!mounted) return;
      
      setState(() {
        weekLogs = week;
        monthLogs = month;
        pastLogs = past;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading meals: $e');
      
      // MOUNTED CHECK: Only update state if widget is still mounted
      if (!mounted) return;
      
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
          : RefreshIndicator(
              onRefresh: _loadMeals,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddLogScreen()),
                          );
                          
                          //  MOUNTED CHECK: Only reload if widget is still mounted after navigation
                          if (!mounted) return;
                          
                          _loadMeals(); // refresh after returning from add screen
                        },
                        child: Text('New Log'),
                      ),
                    ),
                    weekLogs.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('No logs tracked for this week'),
                          )
                        : MealLogUi(mealLogs: weekLogs, header: 'This Week'),
                    monthLogs.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('No logs tracked for this month'),
                          )
                        : MealLogUi(mealLogs: monthLogs, header: 'This Month'),
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