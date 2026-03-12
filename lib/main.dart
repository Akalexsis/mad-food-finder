/* 
  Author - Kayla Thornton
  Purpose - Render each screen and display navigation bar
 */
import 'package:flutter/material.dart';
import 'screens/foodScreen.dart';

void main() {
  runApp(const FoodFinderApp());
}

// tab navigation for all screens
class FoodFinderApp extends StatelessWidget {
  const FoodFinderApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                Tab(text: "Meals"),
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
    );
    
  }
}

