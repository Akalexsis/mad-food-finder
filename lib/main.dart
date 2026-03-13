/* 
  Author - Kayla Thornton
  Purpose - Render each screen and display navigation bar
 */
import 'package:flutter/material.dart';
import 'screens/Meals/mealScreen.dart';
import 'screens/Home/foodScreen.dart';
import '../screens/Budget/BudgetScreen.dart';

void main() {
  runApp(const FoodFinderApp());
}

// tab navigation for all screens
class FoodFinderApp extends StatelessWidget {
  const FoodFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Finder',
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3, // UPDATE TO 4
        child: Scaffold(
          appBar: AppBar(
            title: Text('Food Finder', textAlign: TextAlign.center,),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.food_bank) , text: "Foods"),
                Tab(icon: Icon(Icons.lunch_dining_outlined),text: "Meal Logs"),
                Tab(icon: Icon(Icons.attach_money_rounded), text: "Budget"),
                // Tab(icon: Icon(Icons.account_circle_rounded), text: "Profile"),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              FoodScreen(),
              MealScreen(),
              BudgetScreen(),
            ],
          )
        )
      )
    );
    
  }
}

