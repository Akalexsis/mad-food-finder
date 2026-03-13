/*
  Author - Kayla Thornton
  Purpose - Render all meal logs
 */
import 'package:flutter/material.dart';
import '../models/meal_model.dart';

class MealScreen extends StatefulWidget {
  const MealScreen({super.key});

  @override
  _MealScreenState createState() => _MealScreenState();
}
class _MealScreenState extends State<MealScreen> {
  // store meals by week, month, and all past
  late final List<MealModel> weekMeals;
  late final List<MealModel> monthMeals;
  late final List<MealModel> pastMeals;

  void initState(){
    super.initState();
    // call get meals method
  }

  // get all meals by week, month, and all past

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal log', textAlign: TextAlign.center,),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [],
      )
    );
  }
}