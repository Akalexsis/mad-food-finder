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
  // ── Filter state ──────────────────────────────────────────────────────────
  String _selectedCuisine = 'All';
  bool _favoritesOnly = false;
  String _selectedHours = 'All';
  List<FoodSpot> _allSpots = [];
  bool _isLoading = true;

  final List<String> _cuisineOptions = [
    'All', 'American', 'Italian', 'Mexican', 'Asian',
    'Mediterranean', 'Fast Food', 'Seafood', 'Vegan / Plant-based', 'Cafe',
  ];

  final List<String> _hoursOptions = ['All', 'Open Early', 'Open Late'];

  @override
  void initState() {
    super.initState();
    _loadSpots();
  }

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
        crossAxisAlignment: CrossAxisAlignment.start, //CHANGED FROM MainAxisSize: MAS.min
        children: [

          // ── Filter chips ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [

                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      label: const Text('Favorites'),
                      selected: _favoritesOnly,
                      onSelected: (val) => setState(() => _favoritesOnly = val),
                      selectedColor: Colors.green.shade100,
                      checkmarkColor: Colors.green.shade800,
                      avatar: const Icon(Icons.favorite, size: 16, color: Colors.red),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: DropdownButton<String>(
                      value: _selectedCuisine,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.restaurant_menu, size: 18),
                      items: _cuisineOptions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (val) => setState(() => _selectedCuisine = val!),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: DropdownButton<String>(
                      value: _selectedHours,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.access_time, size: 18),
                      items: _hoursOptions.map((h) => DropdownMenuItem(value: h, child: Text(h))).toList(),
                      onChanged: (val) => setState(() => _selectedHours = val!),
                    ),
                  ),

                ],
              ),
            ),
          ),

          // ── Results count ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '${spots.length} spot${spots.length == 1 ? '' : 's'}',
              style: const TextStyle(color: Colors.blueGrey, fontSize: 12),
            ),
          ),

          // ── Food spot list ────────────────────────────────────────────────
          Expanded(
            child: spots.isEmpty
                ? const Center(
                    child: Text('No spots match your filters.',
                        style: TextStyle(color: Colors.blueGrey)),
                  )
                : ListView.builder(
                    itemCount: spots.length,
                    itemBuilder: (context, index) {
                      final spot = spots[index];
                      return Card(
                        child: ListTile(
                          title: Image.network(
                            spot.imageUrl,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 100,
                              color: Colors.grey[200],
                              child: const Icon(Icons.restaurant, size: 50, color: Colors.grey),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(spot.name, style: const TextStyle(fontSize: 24)),
                              Text(spot.hours, style: const TextStyle(color: Colors.blueGrey)),
                              Text('\$${spot.cost}', style: const TextStyle(color: Colors.lightGreen)),
                              Text(spot.cuisine, style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DetailScreen(spot: spot)),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddFoodScreen()),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Spot'),
      ),
    );
  }
}