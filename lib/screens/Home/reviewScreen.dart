/*
  Author - Kayla Thornton
  Purpose - Provide users with form to add new review
 */
import 'package:flutter/material.dart';
import '../../models/review_model.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}


// TO-DO - refactor code to accept database objects
class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();

  // add review to database navigate back to previous page
  void addReview() {
    // add review to database

    const reviewMsg = SnackBar( content: Text( 'Your review has been added!' ) );
    ScaffoldMessenger.of(context).showSnackBar(reviewMsg);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a Review!', textAlign: TextAlign.center,),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center( 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Review Name'),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Review Name'
              ),
            ),
            SizedBox( height: 15 ),

            Text('Description'),
            TextField(
              controller: _reviewController,
              decoration: InputDecoration(
                labelText: 'Add your review ...'
              ),
            ),
            SizedBox( height: 15 ),

            ElevatedButton(
              onPressed: () { addReview(); }, 
              child: Text('Add Review')
            )
          ]
        )
      )
    );
  }
}