/* 
  Author - Kayla Thornton
  Purpose - Render details about food spots with their specific reviews
*/
import 'package:flutter/material.dart';
import '../../models/food_model.dart';
import '../../models/review_model.dart';
import '../../database_helper.dart';
import 'reviewScreen.dart';
import 'editFoodScreen.dart';  // NEW IMPORT
import 'package:url_launcher/url_launcher.dart'; // NEW IMPORT

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
      
      // MOUNTED CHECK: Only update state if widget is still mounted
      if (!mounted) return;
      
      setState(() {
        reviews = loadedReviews;
        isLoading = false;
      });
    } catch (e) {
      // MOUNTED CHECK: Only update state if widget is still mounted
      if (!mounted) return;
      
      setState(() => isLoading = false);
      print('Error loading reviews: $e');
    }
  }

  // ← NEW: Reload the food spot details after editing
  Future<void> reloadSpotDetails() async {
    final updatedSpot = await DatabaseHelper.instance.getFoodSpotsById(spot.id!);
    
    if (!mounted) return;
    
    if (updatedSpot != null) {
      setState(() {
        spot = updatedSpot;
      });
    }
  }

  // Navigate to add review and reload reviews when returning
  Future<void> navigateToAddReview() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewScreen(foodId: spot.id!), // Pass food spot ID
      ),
    );

    // MOUNTED CHECK: Only reload if widget is still mounted after navigation
    if (!mounted) return;

    // If review was added, reload the reviews list
    if (result == true) {
      loadReviews();
    }
  }

  // ← NEW: Navigate to edit screen
  Future<void> navigateToEditScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditFoodScreen(spot: spot),
      ),
    );

    // MOUNTED CHECK: Only reload if widget is still mounted after navigation
    if (!mounted) return;

    // If spot was edited, reload the spot details
    if (result == true) {
      reloadSpotDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        // ← NEW: Add edit button to AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Food Spot',
            onPressed: navigateToEditScreen,
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Center( // Display the image, cost, and cuisine type as headers
              child: Column(
                children: [
                  Image.network(
                    spot.imageUrl, 
                    height: 150, 
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: const Icon(Icons.restaurant, size: 50, color: Colors.grey),
                    ),
                  ),
                  Text(spot.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [ 
                      Text(spot.hours, style: const TextStyle(fontSize: 18, color: Colors.blueGrey)),
                      Text(spot.cuisine, style: const TextStyle(fontSize: 18, color: Colors.blueGrey)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('\$${spot.cost}', style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ← NEW: Show menu URL if available
            if (spot.menuUrl != null && spot.menuUrl!.isNotEmpty)
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          final url = Uri.parse(spot.menuUrl!);
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          } else {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not open menu link')),
            );
          }
        },
        icon: const Icon(Icons.menu_book),
        label: const Text('View Menu'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      ),
    ),
  ),

            // ← NEW: Show allergen warning if any allergens exist
            if (spot.potentialAllergens.isNotEmpty)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  border: Border.all(color: Colors.orange.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Potential Allergens',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 4),
                          Text(spot.potentialAllergens.join(', '),
                              style: const TextStyle(fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 8),

            // Show spot reviews
            const Text('Reviews', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500), textAlign: TextAlign.start),
            
            ElevatedButton( // go to review page to add new review
              onPressed: navigateToAddReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Review'),
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
                          leading: const Icon(Icons.person),
                          title: Text(review.name, style: const TextStyle(fontSize: 18)),
                          subtitle: Text(review.desc, style: const TextStyle(fontSize: 14, color: Colors.blueGrey)),
                          trailing: Text(review.date, style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                        );
                      },
                    ),
                  ),            
          ],
        ),
      ),
    );
  }
}