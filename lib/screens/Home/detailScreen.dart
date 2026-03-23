/* 
  Author - Kayla Thornton
  Purpose - Render details about food spots with their specific reviews
*/
import 'package:flutter/material.dart';
import '../../models/food_model.dart';
import '../../models/review_model.dart';
import '../../database_helper.dart';
import 'reviewScreen.dart';

class DetailScreen extends StatefulWidget {
  // accept and save food spot
  final FoodSpot spot;
  const DetailScreen({super.key, required this.spot});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // store info of corresponding food spot with related reviews
  late FoodSpot spot;  // ← CHANGED: Remove 'final' so we can update it
  List<Review> reviews = [];
  bool isLoading = true;

  // initialize food spot data
  @override
  void initState() {
    super.initState();
    spot = widget.spot;
    loadReviews();
  }

  // get reviews from database for THIS specific food spot
  Future<void> loadReviews() async {
    setState(() => isLoading = true);
    
    try {
      final loadedReviews = await DatabaseHelper.instance.getReviewsForFoodSpot(spot.id!);
      
      //  MOUNTED CHECK: Only update state if widget is still mounted
      if (!mounted) return;
      
      setState(() {
        reviews = loadedReviews;
        isLoading = false;
      });
    } catch (e) {
      //  MOUNTED CHECK: Only update state if widget is still mounted
      if (!mounted) return;
      
      setState(() => isLoading = false);
      print('Error loading reviews: $e');
    }
  }

    // loadReviews();
  }

  // get reviews from database
  // Future<void> loadReviews() async{
    
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Center( // Display the image, cost, and cuisine type as headers
              child: Column(
                children: [
                  Image.network(spot.imageUrl, height: 150, width: double.infinity),
                  Text(spot.name, style: TextStyle( fontSize: 24, fontWeight: FontWeight.w500)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [ 
                      Text(spot.hours, style: TextStyle( fontSize: 18, color: Colors.blueGrey)),
                      Text(spot.cuisine, style: TextStyle( fontSize: 18, color: Colors.blueGrey)),
                  ],)
                ],
              )
            ),

            // Show spot reviews
            Text('Reviews', style: TextStyle( fontSize: 24, fontWeight: FontWeight.w500), textAlign: TextAlign.start,),
            
            ElevatedButton( // go to review page to add new review
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReviewScreen())
                );
               },
               child: Text('Add Review')
            ),
            
            // conditionally render reviews with loading state
            isLoading 
              ? const Expanded(child: Center(child: CircularProgressIndicator(color: Colors.green)))
              : reviews.isEmpty 
                ? const Expanded(child: Center(child: Text('No reviews yet. Be the first to review!')))
                : Expanded(
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
          ],
        )
      )
    );
  }
}

