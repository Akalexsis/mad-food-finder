/*
 * Author - Kayla Thornton
 * Purpose - form for users to fill out to create a new food spot
 */
import 'package:flutter/material.dart';


class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Add Food Spot')
    );
  }
}