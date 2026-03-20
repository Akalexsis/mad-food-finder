/*
 * Author - Kayla Thornton
 * Purpose - Allow users to track meal expenses
 */
import 'package:flutter/material.dart';
import '../../models/meal_model.dart';
import '../../ui/mealLogUi.dart';
import '../../database_helper.dart';
import '/shared_preferences_helper.dart';

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
      final remaining = monthlyBudget - amountSpent;
    final isOverBudget = remaining < 0;

    return Scaffold(
      body: SingleChildScrollView(
        // make entire page scrollable
       child: Column(
          children: [
            // Progress bar showing monthly remaining based on budget amount specified in rpeferences
            ListTile(
              title: const Text(
                'Monthly Spending',
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Column(
                children: [
                  LinearProgressIndicator(
                    value: budgetProgress,
                    semanticsLabel: 'Spending Summary',
                    color: isOverBudget ? Colors.red : Colors.green,
                    backgroundColor: Colors.blueGrey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${amountSpent.toStringAsFixed(2)} Spent',
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                      Text(
                        isOverBudget
                            ? '\$${remaining.abs().toStringAsFixed(2)} Over Budget'
                            : '\$${remaining.toStringAsFixed(2)} Remaining',
                        style: TextStyle(
                          color: isOverBudget ? Colors.red : Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                  // Show budget total if set
                  if (monthlyBudget > 0)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Budget: \$${monthlyBudget.toStringAsFixed(2)}/mo',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  if (monthlyBudget == 0)
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'No budget set — complete your profile to set one',
                        style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                      ),
                    ),
                ],
              ),
            ),


             // Spending summary card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Spending Summary',
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 12),

                    Builder(
                      builder: (context) {
                        final mostSpent = _getMostSpent();

                        if (mostSpent == null) {
                          return const Text(
                            'No meals logged this month yet.',
                            style: TextStyle(color: Colors.blueGrey),
                          );
                        }

                        final totalAtSpot = _getTotalSpentAt(mostSpent.name);

                        return Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.restaurant,
                                color: Colors.blueGrey,
                                size: 36,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Most Spent',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                Text(
                                  mostSpent.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '\$${totalAtSpot.toStringAsFixed(2)} spent this month',
                                  style: const TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // This month's meal logs
            monthLogs.isEmpty
                ? const Text('No meals tracked for this month')
                : MealLogUi(mealLogs: monthLogs, header: "This Month's Logs"),
          ],
        ),
      ),
    );
  }
}
