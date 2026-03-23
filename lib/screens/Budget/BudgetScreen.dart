/*
 * Author - Kayla Thornton
 * Purpose - Allow users to track meal expenses
 */
import 'package:flutter/material.dart';
import '../../models/meal_model.dart';
import '../../models/food_model.dart';
import '../../ui/mealLogUi.dart';
import '../../database_helper.dart';
import '/shared_preferences_helper.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  double budgetProgress = 0.0;
  double amountSpent = 0.0;
  double monthlyBudget = 0.0;
  List<MealModel> monthLogs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBudgetData();
  }

  Future<void> _loadBudgetData() async {
    // Load budget from SharedPreferences (set during questionnaire)
    final budgetString = await SharedPreferencesHelper.getMonthlyBudget();
    final parsedBudget = double.tryParse(budgetString) ?? 0.0;

    // Load monthly spending and logs from database
    final spent = await DatabaseHelper.instance.getMonthlySpending();
    final logs = await DatabaseHelper.instance.getMealsThisMonth();

    // MOUNTED CHECK: Only update state if widget is still mounted
    if (!mounted) return;

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

  // Find food spot where most money was spent this month (using foodSpotId)
  Future<Map<String, dynamic>?> _getMostSpentFoodSpot() async {
    if (monthLogs.isEmpty) return null;

    // Group spending by foodSpotId
    final spendingBySpotId = <int, double>{};
    for (final log in monthLogs) {
      if (log.foodSpotId != null) {
        spendingBySpotId[log.foodSpotId!] =
            (spendingBySpotId[log.foodSpotId!] ?? 0.0) + log.cost;
      }
    }

    if (spendingBySpotId.isEmpty) return null;

    // Find the food spot with highest spending
    final topSpotId = spendingBySpotId.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;

    final totalSpent = spendingBySpotId[topSpotId]!;
    final foodSpot = await DatabaseHelper.instance.getFoodSpotsById(topSpotId);

    if (foodSpot == null) return null;

    return {'foodSpot': foodSpot, 'totalSpent': totalSpent};
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
        child: Column(
          children: [
            // Progress bar
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

            // Spending summary card - NOW USING FOOD SPOT DATA
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

                    FutureBuilder<Map<String, dynamic>?>(
                      future: _getMostSpentFoodSpot(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final data = snapshot.data;
                        if (data == null) {
                          return const Text(
                            'No meals logged this month yet.',
                            style: TextStyle(color: Colors.blueGrey),
                          );
                        }

                        final foodSpot = data['foodSpot'] as FoodSpot;
                        final totalSpent = data['totalSpent'] as double;

                        return Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                foodSpot.imageUrl, // ← Actual restaurant logo!
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // Fallback to icon if image fails to load
                                  return Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.restaurant, // ← Generic icon
                                      color: Colors.blueGrey,
                                      size: 36,
                                    ),
                                  ); // Shows icon as backup
                                },
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
                                  foodSpot.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '\$${totalSpent.toStringAsFixed(2)} spent this month',
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