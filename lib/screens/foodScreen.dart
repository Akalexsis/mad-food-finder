/* 
  Author - Kayla Thornton
  Purpose - Render list of food spots and route users to Foods screen so they can view more Foods
 */

import 'package:flutter/material.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  _FoodScreenState createState() => _FoodScreenState();
}
class _FoodScreenState extends State<FoodScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: const Text("Foods screen")
      )
    );
  }
}

