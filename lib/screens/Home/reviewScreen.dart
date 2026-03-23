/*
  Author - Kayla Thornton
  Purpose - Provide users with form to add new review for a specific food spot
 */
import 'package:flutter/material.dart';
import '../../models/review_model.dart';
import '../../database_helper.dart';

class ReviewScreen extends StatefulWidget {
  final int foodId; // ADDED: to link review to specific food spot
  
  const ReviewScreen({super.key, required this.foodId});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();

  // add review to database and navigate back to previous page
  Future<void> addReview() async {
    // Validate input
    if (_nameController.text.trim().isEmpty || _reviewController.text.trim().isEmpty) {
      const errorMsg = SnackBar(content: Text('Please fill in all fields'));
      ScaffoldMessenger.of(context).showSnackBar(errorMsg);
      return;
    }

    // Create review object with current date
    final review = Review(
      name: _nameController.text.trim(),
      desc: _reviewController.text.trim(),
      date: _formatDate(DateTime.now()),
      foodId: widget.foodId, // Link to specific food spot
    );

    // Save to database
    try {
      await DatabaseHelper.instance.insertReview(review);
      
      // MOUNTED CHECK: Only show snackbar and navigate if widget is still mounted
      if (!mounted) return;
      
      const reviewMsg = SnackBar(content: Text('Your review has been added!'));
      ScaffoldMessenger.of(context).showSnackBar(reviewMsg);
      
      Navigator.pop(context, true); // Pass true to indicate review was added
    } catch (e) {
      // MOUNTED CHECK: Only show error snackbar if widget is still mounted
      if (!mounted) return;
      
      final errorMsg = SnackBar(content: Text('Error adding review: $e'));
      ScaffoldMessenger.of(context).showSnackBar(errorMsg);
    }
  }

  // Format date as "Mar 16, 2026"
  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Review!', textAlign: TextAlign.center),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your Name', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Your Review', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _reviewController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Share your experience...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: addReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text('Submit Review', style: TextStyle(fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}