/* 
  Author - Kayla Thornton
  Purpose - Render each screen and display navigation bar
 */
import 'package:flutter/material.dart';
<<<<<<< HEAD
import '../screens/mealScreen.dart';
=======
import 'screens/foodScreen.dart';
>>>>>>> 9513c6f7ea20119a2db1510c7772047638c2229e

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
      title: 'Flutter Demo',
      home: MealScreen(),
=======
      title: 'Food Finder',
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 1, // UPDATE TO 4
        child: Scaffold(
          appBar: AppBar(
            title: Text('Food Finder', textAlign: TextAlign.center,),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            bottom: const TabBar(
              tabs: [
                Tab(text: "Home"),
                // Tab(text: "Meals"),
                // Tab(text: "Budget"),
                // Tab(text: "Profile"),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              FoodScreen(),
            ],
          )
        )
      )
>>>>>>> 9513c6f7ea20119a2db1510c7772047638c2229e
    );
    
  }
}

