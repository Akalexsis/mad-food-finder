/*
 * Author - Kayla Thornton
 * Purpose - Allow users to track meal expenses
 */
import 'package:flutter/material.dart';
import '../../models/meal_model.dart';
import '../../ui/mealLogUi.dart';
import '../../database_helper.dart';
import '/shared_preference_helper.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  // BUDGET RELATED VARIABLES
  double budgetProgress = 0.0;
  double amountSpent = 0.0;
  double monthlyBudget = 0.0;
  List<MealModel> monthLogs = [];
  bool isLoading = true;

  // SUMMARY RELATED VARIABLES
  Future<void> _loadBudgetData() async {
    // Load budget from SharedPreferences (set during questionnaire)
    final budgetString = await SharedPreferencesHelper.getMonthlyBudget();
    final parsedBudget = double.tryParse(budgetString) ?? 0.0;

    // Load monthly spending and logs from database
    final spent = await DatabaseHelper.instance.getMonthlySpending();
    final logs = await DatabaseHelper.instance.getMealsThisMonth();

    setState(() {
      monthlyBudget = parsedBudget;
      amountSpent = spent;
      monthLogs = logs;
      budgetProgress = monthlyBudget > 0
          ? (amountSpent / monthlyBudget).clamp(0.0, 1.0)
          : 0.0;
      isLoading = false;
    });
  }

  // Find restaurant where most money was spent this month
  MealModel? _getMostSpent() {
    if (monthLogs.isEmpty) return null;

    final spendingByName = <String, double>{};
    for (final log in monthLogs) {
      spendingByName[log.name] = (spendingByName[log.name] ?? 0.0) + log.cost;
    }

    final mostSpentName = spendingByName.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;

    return monthLogs.firstWhere((log) => log.name == mostSpentName);
  }

  double _getTotalSpentAt(String name) {
    return monthLogs
        .where((log) => log.name == name)
        .fold(0.0, (sum, log) => sum + log.cost);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.green)),
      );
    }
    return Scaffold(
      body: SingleChildScrollView(
        // make entire page scrollable
        child: Column(
          children: [
            // Display progress bar of how much user has spent
            ListTile(
              title: Text('Monthly Spending', style: TextStyle(fontSize: 18)),
              subtitle: Column(
                children: [
                  LinearProgressIndicator(
                    value: budgetProgress,
                    semanticsLabel: 'Spending Summary',
                    color: Colors.green,
                    backgroundColor: Colors.blueGrey,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$$amountSpent Spent',
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                      Text(
                        '\$${monthlyBudget - amountSpent} Remaining',
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // SPENDING SUMMARY
            Card(
              child: Column(
                children: [
                  Text('Spending Summary: ', style: TextStyle(fontSize: 24)),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Most Visited:'), Text('Moes')],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Most Visited:'), Text('Moes')],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [Text('Most Visited:'), Text('Moes')],
                  ),
                ],
              ),
            ),

            // Display this week's logs only
            sampleLogs.isEmpty
                ? Text('No meals tracked for this week')
                : MealLogUi(mealLogs: sampleLogs, header: "This week's Logs"),
          ],
        ),
      ),
    );
  }
}
