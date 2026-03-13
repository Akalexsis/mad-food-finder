/*
 * Author - Kayla Thornton
 * Purpose - Allow users to track meal expenses
 */
import 'package:flutter/material.dart';
import '../../models/meal_model.dart';
import '../../ui/mealLogUi.dart';
import '../../data/meal_data.dart'; // DELETE - FOR TESTING ONLY

class BudgetScreen extends StatefulWidget{
  const BudgetScreen({super.key});

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  // BUDGET RELATED VARIABLES
  double budgetProgress = 0.0; // tracks amount spent (for progress bar)
  double amountSpent = 60.0; // tracks amount spent by user
  double monthlyBudget = 500.0; // monthly budget amount set by user
  late final List<MealModel> weekLogs; // store all logs for this week

  // SUMMARY RELATED VARIABLES
  
  // TO-DO - GET THIS WEEK'S MEALS

  // TO-DO - Calculate how much the user has spent this month

  // Update budgetProgress to reflect how much user has spent and how much remains
  void getBudget() {
    setState(() => 
      budgetProgress = amountSpent / monthlyBudget
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // make entire page scrollable
        child: Column(
          children: [
            // Display progress bar of how much user has spent 
            ListTile(
                title: Text('Monthly Spending', style: TextStyle( fontSize: 18 )),
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
                        Text('\$$amountSpent Spent', style: TextStyle( color: Colors.blueGrey)),
                        Text('\$${monthlyBudget - amountSpent} Remaining', style: TextStyle( color: Colors.blueGrey)),
                      ],
                    )
                  ],
                )
              ),

            // SPENDING SUMMARY
            Card(
              child: Column(
                children: [
                  Text('Spending Summary: ', style: TextStyle( fontSize: 24 ),),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Most Visited:'),
                      Text('Moes')
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Most Visited:'),
                      Text('Moes')
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Most Visited:'),
                      Text('Moes')
                    ],
                  ),
                ],
              )
            ),
            
            // Display this week's logs only
            sampleLogs.isEmpty ? Text('No meals tracked for this week') : MealLogUi(mealLogs: sampleLogs, header: "This week's Logs")
          ],
        )
      )
    );
  }
}