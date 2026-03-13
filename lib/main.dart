/* 
  Author - Kayla Thornton
  Purpose - Render each screen and display navigation bar
 */
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'screens/Meals/mealScreen.dart';
import 'screens/Home/foodScreen.dart';
=======
import '../screens/Budget/BudgetScreen.dart';
>>>>>>> 7679864f392e6fd19f3652f7277865c492b19cef

void main() {
  runApp(const FoodFinderApp());
}

// tab navigation for all screens
class FoodFinderApp extends StatelessWidget {
  const FoodFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
      title: 'Food Finder',
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2, // UPDATE TO 4
        child: Scaffold(
          appBar: AppBar(
            title: Text('Food Finder', textAlign: TextAlign.center,),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            bottom: const TabBar(
              tabs: [
                Tab(text: "Home"),
                Tab(text: "Meal Logs"),
                // Tab(text: "Budget"),
                // Tab(text: "Profile"),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              FoodScreen(),
              MealScreen()
            ],
          )
        )
      )
=======
      title: 'Flutter Demo',
      home: BudgetScreen(),
>>>>>>> 7679864f392e6fd19f3652f7277865c492b19cef
    );
    
  }
}

