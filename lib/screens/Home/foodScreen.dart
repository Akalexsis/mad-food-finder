/* 
  Author - Kayla Thornton
  Purpose - Render list of food spots and route users to Foods screen so they can view more Foods
 */
import 'package:flutter/material.dart';
import 'detailScreen.dart';
import 'addFoodScreen.dart';
import '../../models/food_model.dart';
import '/database_helper.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  String _selectedCuisine = 'All';
  bool _favoritesOnly = false;
  String _selectedHours = 'All';
  List<FoodSpot> _allSpots = [];
  bool _isLoading = true;

  final List<String> _cuisineOptions = [
    'All',
    'American',
    'Italian',
    'Mexican',
    'Asian',
    'Mediterranean',
    'Fast Food',
    'Seafood',
    'Vegan / Plant-based',
    'Cafe',
  ];

  final List<String> _hoursOptions = ['All', 'Open Early', 'Open Late'];

  @override
  void initState() {
    super.initState();
    _loadSpots();
  }

  // get entries by filter

  Future<void> _loadSpots() async {
    final spots = await DatabaseHelper.instance.getAllFoodSpots();
    setState(() {
      _allSpots = spots;
      _isLoading = false;
    });
  }

  Future<void> _updateFavorite(FoodSpot spot) async {
    await DatabaseHelper.instance.toggleFavorite(spot.id!, !spot.isFavorite);
    await _loadSpots();
  }

  //filtering logic
  List<FoodSpot> get _filteredSpots {
    return _allSpots.where((spot) {
      if (_selectedCuisine != 'All' && spot.cuisine != _selectedCuisine) return false;
      if (_favoritesOnly && !spot.isFavorite) return false;

      if (_selectedHours == 'Open Early') {
        final opensAt = spot.hours.split(' ').first;
        final hour = int.tryParse(opensAt.replaceAll(RegExp(r'[^0-9]'), '').substring(0, opensAt.contains(':') ? opensAt.indexOf(':') : opensAt.length)) ?? 99;
        final isAm = opensAt.contains('am');
        if (!(isAm && hour <= 7)) return false;
      }

      if (_selectedHours == 'Open Late') {
        final parts = spot.hours.split(' - ');
        if (parts.length < 2) return false;
        final closesAt = parts[1].trim();
        final isPm = closesAt.contains('pm');
        final hour = int.tryParse(closesAt.replaceAll(RegExp(r'[^0-9:]'), '').split(':').first) ?? 0;
        if (!(isPm && (hour == 12 || hour >= 11))) return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.green)),
      );
    }

    final spots = _filteredSpots;

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // FILTERS
          Row(
            children: [
              Text('Filters'),
              // dropdown options by cuisine, favorite, and maybe hours
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddFoodScreen()),
                  );
                },
                child: Text('Add Food Spot'),
              ),
            ],
          ),

          // FOOD SPOT LIST: Render each food spot as a clickable card
          Expanded(
            child: ListView.builder(
              itemCount: spots.length,
              itemBuilder: (context, index) {
                final spot = spots[index];

                return Card(
                  child: ListTile(
                    title: Image.network(
                      spot.imageUrl,
                      height: 100,
                      width: double.infinity,
                    ),
                    subtitle: Column(
                      // vertically list all spot details
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(spot.name, style: TextStyle(fontSize: 24)),
                        Text(
                          spot.hours,
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                        Text(
                          '\$${spot.cost}',
                          style: TextStyle(color: Colors.lightGreen),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      onPressed: () => _updateFavorite(spot),
                      icon: spot.isFavorite
                          ? const Icon(Icons.favorite, color: Colors.red)
                          : const Icon(Icons.favorite_border),
                    ),
                    onTap: () {
                      // navigate to details screen when card tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(spot: spot),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
