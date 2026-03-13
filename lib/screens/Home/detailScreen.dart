/* 
  Author - Kayla Thornton
  Purpose - Render details about food spots
*/
import 'package:flutter/material.dart';
import '../../models/food_model.dart';
import '../../models/review_model.dart';
import 'reviewScreen.dart';

class DetailScreen extends StatefulWidget {
  // accept and save food spot
  final FoodSpot spot;
  const DetailScreen({super.key, required this.spot});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}


// TO-DO - refactor code to accept database objects
class _DetailScreenState extends State<DetailScreen> {
  // store info of corresponding food spot with related reviews
  late final FoodSpot spot;
  List<Review> reviews = [ // FOR TESTING ONLY DELETE WHEN DATABASE INITIALIZED
    Review(
      name: 'Kayla', 
      desc: 'This place is great!', 
      date: 'Mar 16, 2026'
    ),
    Review(
      name: 'Zah', 
      desc: 'Do not listen to Kayla. This place sucks!', 
      date: 'Mar 17, 2026'
    ),
  ];


  // initialize food spot data
  @override
  void initState() {
    super.initState();
    spot = widget.spot;
    // loadReviews();
  }

  // get reviews from database
  // Future<void> loadReviews() async{
    
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Center( // Display the image, cost, and cuisine type as headers
              child: Column(
                children: [
                  Image.network(spot.imageUrl, height: 150, width: double.infinity),
                  Text(spot.name, style: TextStyle( fontSize: 24, fontWeight: FontWeight.w500)),
                  Row(
                    children: [ 
                      Text(spot.hours, style: TextStyle( fontSize: 18, color: Colors.blueGrey)),
                      Text(spot.cuisine, style: TextStyle( fontSize: 18, color: Colors.blueGrey)),
                  ],)
                ],
              )
            ),

            // Show spot reviews
            Text('Reviews', style: TextStyle( fontSize: 24, fontWeight: FontWeight.w500), textAlign: TextAlign.start,),

            // conditionally render reviews
            reviews.isEmpty ? Text('Add a review!') : 
            
            Expanded(
              child: ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];

                  return ListTile(
                    leading: Icon(Icons.person),
                    title: Text(review.name, style: TextStyle( fontSize: 18 )),
                    subtitle: Text(review.desc, style: TextStyle( fontSize: 14, color: Colors.blueGrey )),
                    trailing: Text(review.date, style: TextStyle( fontSize: 12, color: Colors.blueGrey )),
                  );
                },
              ),
            ),

            ElevatedButton( // go to review page to add new review
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReviewScreen())
                );
               },
               child: Text('Add Review')
            ),
          ],
        )
      )
    );
  }
}

