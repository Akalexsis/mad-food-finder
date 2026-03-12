/*
  Author - Kayla Thornton
  Purpose - Provide users with form to add new review
 */
import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}


// TO-DO - refactor code to accept database objects
class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();

  // add review to database
  void addReview() {

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( 
        child: Column(
          children: [
            Text('Add a Review!', style: TextStyle( fontSize: 24 ) ),
            SizedBox( height: 30),

            
          ]
        )
      )
    );
  }
}