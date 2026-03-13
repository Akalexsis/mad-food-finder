/* 
  Author - Kayla Thornton
  Purpose - Render list of food spots and route users to Foods screen so they can view more Foods
 */
import 'package:flutter/material.dart';
import 'detailScreen.dart';
import 'addFoodScreen.dart';
import '../../data/food_data.dart'; // FOR TESTING ONLY

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  // add database methods here

  // get entries by filter

  void _updateFavorite() {
    // update favoite for food spot
    print('is favorite');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // FILTERS
          Row(
            children: [
              Text('Filters'),
              // dropdown options by cuisine, favorite, and maybe hours
              ElevatedButton(
                onPressed: () { Navigator.push(context, MaterialPageRoute( builder: (context) => AddFoodScreen() )); } , 
                child: Text('Add Food Spot')
              )
            ],
          ),

          // Render each food spot as a clickable card 
          Expanded(
            child: ListView.builder(
              itemCount: sampleSpots.length,
              itemBuilder: (context, index) {
                final spot = sampleSpots[index];

                return Card(
                  child: ListTile(
                    title: Image.network(spot.imageUrl, height: 100, width: double.infinity),
                    subtitle: Column( // vertically list all spot details
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(spot.name, style: TextStyle( fontSize: 24 )),
                        Text(spot.hours, style: TextStyle( color: Colors.blueGrey )),
                        Text('\$${spot.cost}', style: TextStyle( color: Colors.lightGreen ))
                      ],
                    ),
                    isThreeLine: true,
                    trailing: ElevatedButton(
                      onPressed: () { _updateFavorite(); }, 
                      child: spot.isFavorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border)
                    ),
                    onTap: () { // navigate to details screen when card tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute( builder: (context) => DetailScreen(spot: spot) )
                      );
                    }
                  )
                );
              }
            )
          )
        ],
      )
    );
  }
}

