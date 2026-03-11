/* 
  Author - Kayla Thornton
  Purpose - Render list of food spots and route users to Foods screen so they can view more Foods
 */

import 'package:flutter/material.dart';
import '../screens/detailScreen.dart';
import '../data/food_data.dart'; // FOR TESTING ONLY

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  // add database methods here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Finder'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder( // iterate through all food spots to render each as a clickable card
        itemCount: sampleSpots.length,
        itemBuilder: (context, index) {
          final spot = sampleSpots[index];

          return Card(
            shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10.0) ),
            child: Column(
              children: [
                ListTile(
                  title: Image.network(spot.imageUrl),
                  subtitle: Column( // vertically list all spot details
                    children: [
                      Text(spot.name, style: TextStyle( fontSize: 24)),
                      Text(spot.hours, style: TextStyle( color: Colors.blueGrey)),
                      Text('${spot.cost}', style: TextStyle( color: Colors.lightGreen))
                    ],
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.favorite_border),
                  onTap: () { // navigate to details screen when card tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute( builder: (context) => DetailScreen(spot: spot) )
                    );
                  }
                  )
                ]
              )
          );
        }
      )
    );
  }
}

