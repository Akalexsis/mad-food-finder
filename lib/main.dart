/* 
  Author - Kayla Thornton
  Purpose - Render each screen and display navigation bar
 */
import 'package:flutter/material.dart';
import 'package:mad_food_finder/screens/Profile/profileScreen.dart';
import 'screens/Meals/mealScreen.dart';
import 'screens/Home/foodScreen.dart';
import 'screens/Budget/budgetScreen.dart';
import 'screens/db_test_screen.dart';  
import 'screens/Profile/profileScreen.dart';

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
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Food Finder', textAlign: TextAlign.center,),
            backgroundColor: const Color.fromARGB(255, 142, 201, 110),
            foregroundColor: const Color.fromARGB(255, 246, 248, 212),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.food_bank), text: "Foods"),
                Tab(icon: Icon(Icons.lunch_dining_outlined), text: "Meal Logs"),
                Tab(icon: Icon(Icons.attach_money_rounded), text: "Budget"),
                Tab(icon: Icon(Icons.storage), text: "DB Test"), // New DB Test tab
                Tab(icon: Icon(Icons.safety_check), text: "Profile Test")
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              FoodScreen(),
              MealScreen(),
              BudgetScreen(),
              DatabaseTestScreen(), //  DB test screen 
              ProfileScreen()
            ],
          )
        )
      )
    );
  }
}

