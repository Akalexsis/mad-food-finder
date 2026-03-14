import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/food_model.dart';
import '../models/review_model.dart';

class DatabaseTestScreen extends StatefulWidget {
  const DatabaseTestScreen({super.key});

  @override
  _DatabaseTestScreenState createState() => _DatabaseTestScreenState();
}

class _DatabaseTestScreenState extends State<DatabaseTestScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  String _testResults = 'Test results will appear here...\n\n';
  bool _isRunning = false;

  // Add test result to display
  void _addResult(String message) {
    setState(() {
      _testResults += '$message\n';
    });
  }

  // Clear results
  void _clearResults() {
    setState(() {
      _testResults = 'Test results cleared.\n\n';
    });
  }

  // TEST 1: Insert Food Spots
  Future<void> _testInsertFoodSpots() async {
    setState(() {
      _isRunning = true;
    });

    _addResult('=== TEST: Insert Food Spots ===');
    
    try {
      // Insert 3 test food spots
      final spot1 = FoodSpot(
        name: 'Pizza Palace',
        imageUrl: 'https://via.placeholder.com/150',
        hours: '11:00AM - 10:00PM',
        cost: 2,
        cuisine: 'Italian',
      );

      final spot2 = FoodSpot(
        name: 'Burger Barn',
        imageUrl: 'https://via.placeholder.com/150',
        hours: '10:00AM - 11:00PM',
        cost: 3,
        cuisine: 'American',
      );

      final spot3 = FoodSpot(
        name: 'Sushi Station',
        imageUrl: 'https://via.placeholder.com/150',
        hours: '12:00PM - 9:00PM',
        cost: 4,
        cuisine: 'Japanese',
      );

      final id1 = await _dbHelper.insertFoodSpot(spot1);
      _addResult('✓ Inserted ${spot1.name} with ID: $id1');

      final id2 = await _dbHelper.insertFoodSpot(spot2);
      _addResult('✓ Inserted ${spot2.name} with ID: $id2');

      final id3 = await _dbHelper.insertFoodSpot(spot3);
      _addResult('✓ Inserted ${spot3.name} with ID: $id3');

      _addResult('SUCCESS: All food spots inserted!\n');
    } catch (e) {
      _addResult('ERROR: $e\n');
    }

    setState(() {
      _isRunning = false;
    });
  }

  // TEST 2: Get All Food Spots
  Future<void> _testGetAllFoodSpots() async {
    setState(() {
      _isRunning = true;
    });

    _addResult('=== TEST: Get All Food Spots ===');
    
    try {
      final spots = await _dbHelper.getAllFoodSpots();
      _addResult('Found ${spots.length} food spots:');
      
      for (var spot in spots) {
        _addResult('  - ${spot.name} (ID: ${spot.id}, Cuisine: ${spot.cuisine})');
      }
      
      _addResult('SUCCESS: Retrieved all food spots!\n');
    } catch (e) {
      _addResult('ERROR: $e\n');
    }

    setState(() {
      _isRunning = false;
    });
  }

  // TEST 3: Update Food Spot (Toggle Favorite)
  Future<void> _testToggleFavorite() async {
    setState(() {
      _isRunning = true;
    });

    _addResult('=== TEST: Toggle Favorite ===');
    
    try {
      final spots = await _dbHelper.getAllFoodSpots();
      
      if (spots.isEmpty) {
        _addResult('No food spots to test. Insert some first!\n');
        setState(() {
          _isRunning = false;
        });
        return;
      }

      final testSpot = spots.first;
      _addResult('Testing with: ${testSpot.name}');
      _addResult('Current favorite status: ${testSpot.isFavorite}');

      // Toggle favorite
      await _dbHelper.toggleFavorite(testSpot.id!, !testSpot.isFavorite);
      _addResult('✓ Toggled favorite status');

      // Get updated spot
      final updated = await _dbHelper.getFoodSpotsById(testSpot.id!);
      _addResult('New favorite status: ${updated?.isFavorite}');
      
      _addResult('SUCCESS: Favorite toggled!\n');
    } catch (e) {
      _addResult('ERROR: $e\n');
    }

    setState(() {
      _isRunning = false;
    });
  }

  // TEST 4: Get Favorites Only
  Future<void> _testGetFavorites() async {
    setState(() {
      _isRunning = true;
    });

    _addResult('=== TEST: Get Favorites ===');
    
    try {
      final favorites = await _dbHelper.getFavorites();
      _addResult('Found ${favorites.length} favorite food spots:');
      
      for (var spot in favorites) {
        _addResult('  - ${spot.name} ⭐');
      }
      
      _addResult('SUCCESS: Retrieved favorites!\n');
    } catch (e) {
      _addResult('ERROR: $e\n');
    }

    setState(() {
      _isRunning = false;
    });
  }

  // TEST 5: Insert Reviews
  Future<void> _testInsertReviews() async {
    setState(() {
      _isRunning = true;
    });

    _addResult('=== TEST: Insert Reviews ===');
    
    try {
      final spots = await _dbHelper.getAllFoodSpots();
      
      if (spots.isEmpty) {
        _addResult('No food spots to add reviews to. Insert food spots first!\n');
        setState(() {
          _isRunning = false;
        });
        return;
      }

      // Add reviews to first food spot
      final testSpot = spots.first;
      _addResult('Adding reviews to: ${testSpot.name}');

      final review1 = Review(
        name: 'John Doe',
        desc: 'Great food and service!',
        date: '2024-03-01',
        foodId: testSpot.id,
      );

      final review2 = Review(
        name: 'Jane Smith',
        desc: 'Best pizza in town!',
        date: '2024-03-05',
        foodId: testSpot.id,
      );

      final id1 = await _dbHelper.insertReview(review1);
      _addResult('✓ Inserted review from ${review1.name} (ID: $id1)');

      final id2 = await _dbHelper.insertReview(review2);
      _addResult('✓ Inserted review from ${review2.name} (ID: $id2)');

      _addResult('SUCCESS: Reviews inserted!\n');
    } catch (e) {
      _addResult('ERROR: $e\n');
    }

    setState(() {
      _isRunning = false;
    });
  }

  // TEST 6: Get Reviews for Food Spot
  Future<void> _testGetReviews() async {
    setState(() {
      _isRunning = true;
    });

    _addResult('=== TEST: Get Reviews for Food Spot ===');
    
    try {
      final spots = await _dbHelper.getAllFoodSpots();
      
      if (spots.isEmpty) {
        _addResult('No food spots to get reviews for!\n');
        setState(() {
          _isRunning = false;
        });
        return;
      }

      final testSpot = spots.first;
      _addResult('Getting reviews for: ${testSpot.name}');

      final reviews = await _dbHelper.getReviewsForFoodSpot(testSpot.id!);
      _addResult('Found ${reviews.length} reviews:');
      
      for (var review in reviews) {
        _addResult('  - ${review.name}: "${review.desc}" (${review.date})');
      }
      
      _addResult('SUCCESS: Retrieved reviews!\n');
    } catch (e) {
      _addResult('ERROR: $e\n');
    }

    setState(() {
      _isRunning = false;
    });
  }

  // TEST 7: Delete Food Spot (cascades to reviews)
  Future<void> _testDeleteFoodSpot() async {
    setState(() {
      _isRunning = true;
    });

    _addResult('=== TEST: Delete Food Spot ===');
    
    try {
      final spots = await _dbHelper.getAllFoodSpots();
      
      if (spots.isEmpty) {
        _addResult('No food spots to delete!\n');
        setState(() {
          _isRunning = false;
        });
        return;
      }

      // Delete the last spot
      final spotToDelete = spots.last;
      _addResult('Deleting: ${spotToDelete.name} (ID: ${spotToDelete.id})');

      await _dbHelper.deleteFoodSpot(spotToDelete.id!);
      _addResult('✓ Food spot deleted');

      // Verify deletion
      final remaining = await _dbHelper.getAllFoodSpots();
      _addResult('Remaining food spots: ${remaining.length}');
      
      _addResult('SUCCESS: Food spot deleted!\n');
    } catch (e) {
      _addResult('ERROR: $e\n');
    }

    setState(() {
      _isRunning = false;
    });
  }

  // RUN ALL TESTS
  Future<void> _runAllTests() async {
    _clearResults();
    _addResult('🚀 RUNNING ALL TESTS...\n');
    
    await _testInsertFoodSpots();
    await Future.delayed(Duration(milliseconds: 500));
    
    await _testGetAllFoodSpots();
    await Future.delayed(Duration(milliseconds: 500));
    
    await _testToggleFavorite();
    await Future.delayed(Duration(milliseconds: 500));
    
    await _testGetFavorites();
    await Future.delayed(Duration(milliseconds: 500));
    
    await _testInsertReviews();
    await Future.delayed(Duration(milliseconds: 500));
    
    await _testGetReviews();
    await Future.delayed(Duration(milliseconds: 500));
    
    await _testDeleteFoodSpot();
    
    _addResult('\n✅ ALL TESTS COMPLETED!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Database Test Screen'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Test Buttons
          Container(
            padding: EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? null : _testInsertFoodSpots,
                  child: Text('1. Insert Food Spots'),
                ),
                ElevatedButton(
                  onPressed: _isRunning ? null : _testGetAllFoodSpots,
                  child: Text('2. Get All Spots'),
                ),
                ElevatedButton(
                  onPressed: _isRunning ? null : _testToggleFavorite,
                  child: Text('3. Toggle Favorite'),
                ),
                ElevatedButton(
                  onPressed: _isRunning ? null : _testGetFavorites,
                  child: Text('4. Get Favorites'),
                ),
                ElevatedButton(
                  onPressed: _isRunning ? null : _testInsertReviews,
                  child: Text('5. Insert Reviews'),
                ),
                ElevatedButton(
                  onPressed: _isRunning ? null : _testGetReviews,
                  child: Text('6. Get Reviews'),
                ),
                ElevatedButton(
                  onPressed: _isRunning ? null : _testDeleteFoodSpot,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('7. Delete Spot'),
                ),
              ],
            ),
          ),
          
          Divider(thickness: 2),
          
          // Action Buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _isRunning ? null : _runAllTests,
                  icon: Icon(Icons.play_arrow),
                  label: Text('Run All Tests'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                ElevatedButton.icon(
                  onPressed: _clearResults,
                  icon: Icon(Icons.clear),
                  label: Text('Clear Results'),
                ),
              ],
            ),
          ),
          
          Divider(thickness: 2),
          
          // Results Display
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              color: Colors.grey[100],
              child: SingleChildScrollView(
                child: Text(
                  _testResults,
                  style: TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}