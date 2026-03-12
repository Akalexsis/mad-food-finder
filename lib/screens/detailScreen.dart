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


// TO-DO - refactor code to accept database objects
class _DetailScreenState extends State<DetailScreen> {
  // accept information from food spot
  // final FoodSpot spot;
  String reviews = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Center( // Display the image, cost, and cuisine type as headers
              child: Column(
                children: [
                  Image.network(widget.spot.imageUrl, height: 150, width: double.infinity),
                  Text(widget.spot.name, style: TextStyle( fontSize: 24, fontWeight: FontWeight.w500)),
                  Row(
                    children: [ 
                      Text(widget.spot.hours, style: TextStyle( fontSize: 18, color: Colors.blueGrey)),
                      SizedBox( height: 150 ),
                      Text(widget.spot.cuisine, style: TextStyle( fontSize: 18, color: Colors.blueGrey)),
                  ],)
                ],
              )
            ),

            // Show spot reviews
            Text('Reviews', style: TextStyle( fontSize: 24, fontWeight: FontWeight.w500)),
            Text( reviews.isEmpty ? 'Add a review!' : reviews )
          ],
        )
      )
    );
  }
}

