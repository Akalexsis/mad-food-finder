/* 
  Author - Kayla Thornton
  Purpose - Render details about food spots
*/
import 'package:flutter/material.dart';
import '../models/food_spot.dart';

class DetailScreen extends StatefulWidget {
  // accept and save food spot
  final FoodSpot spot;
  const DetailScreen({super.key, required this.spot});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text('Food Finder'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: const Text("Details screen")
      )
    );
  }
}

