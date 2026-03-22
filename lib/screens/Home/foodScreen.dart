import 'package:flutter/material.dart';
import 'detailScreen.dart';
import 'addFoodScreen.dart';
import '../../models/food_model.dart';
import '/database_helper.dart';
import '/shared_preferences_helper.dart';

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
  String _selectedBudget = 'All';

  final List<String> _budgetOptions = [
    'All',
    'Inexpensive',
    'Middle Ground',
    'Expensive',
  ];

  // ── User preferences from SharedPreferences ──────────────────────────────
  List<String> _userCuisines = [];
  List<String> _userAllergies = [];
  List<String> _userDietaryRestrictions = [];
  String _userBudget = '';

  // ── Filter toggles ────────────────────────────────────────────────────────
  bool _useMyPreferences = false;
  bool _hideAllergens = false;

  // ← NEW: Smart allergen mapping by cuisine (ONLY ADDITION)
  final Map<String, List<String>> _cuisineAllergens = {
    'American': ['Dairy', 'Eggs', 'Gluten', 'Soy'],
    'Italian': ['Dairy', 'Gluten', 'Eggs'],
    'Mexican': ['Dairy', 'Gluten'],
    'Asian': ['Soy', 'Fish', 'Shellfish', 'Peanuts'],
    'Chinese': ['Soy', 'Shellfish', 'Peanuts', 'Gluten'],
    'Japanese': ['Soy', 'Fish', 'Shellfish', 'Gluten'],
    'Mediterranean': ['Dairy', 'Gluten', 'Tree Nuts'],
    'Fast Food': ['Dairy', 'Eggs', 'Gluten', 'Soy'],
    'Seafood': ['Fish', 'Shellfish'],
    'Vegan / Plant-based': ['Tree Nuts', 'Soy', 'Gluten'],
    'Cafe': ['Dairy', 'Eggs', 'Gluten', 'Tree Nuts'],
  };

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
    _loadUserPreferences();
    _loadSpots();
  }

  Future<void> _loadUserPreferences() async {
    final cuisines = await SharedPreferencesHelper.getCuisinePreferences();
    final allergies = await SharedPreferencesHelper.getAllergies();
    final dietary = await SharedPreferencesHelper.getDietaryRestrictions();
    final budget = await SharedPreferencesHelper.getMonthlyBudget();

    if (!mounted) return;

    setState(() {
      _userCuisines = cuisines;
      _userAllergies = allergies;
      _userDietaryRestrictions = dietary;
      _userBudget = budget;
    });
  }

  Future<void> _loadSpots() async {
    final spots = await DatabaseHelper.instance.getAllFoodSpots();

    if (!mounted) return;

    setState(() {
      _allSpots = spots;
      _isLoading = false;
    });
  }

  Future<void> _updateFavorite(FoodSpot spot) async {
    await DatabaseHelper.instance.toggleFavorite(spot.id!, !spot.isFavorite);

    if (!mounted) return;

    await _loadSpots();
  }

  Future<void> _navigateToAddFood() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddFoodScreen()),
    );

    if (!mounted) return;

    if (result == true) {
      _loadSpots();
    }
  }

  // ← NEW: Smart allergen detection method (ONLY ADDITION)
  bool _spotContainsAllergens(FoodSpot spot) {
    // Check explicitly marked allergens on the spot
    for (var userAllergen in _userAllergies) {
      if (spot.potentialAllergens.contains(userAllergen)) {
        return true; // Spot explicitly has this allergen
      }
    }

    // Check cuisine-based allergens (smart defaults)
    final cuisineAllergens = _cuisineAllergens[spot.cuisine] ?? [];
    for (var userAllergen in _userAllergies) {
      if (cuisineAllergens.contains(userAllergen)) {
        return true; // Cuisine typically contains this allergen
      }
    }

    return false; // Safe to show
  }

  // ← UPDATED: Enhanced filtering with smart allergen detection
  List<FoodSpot> get _filteredSpots {
    return _allSpots.where((spot) {
      // Basic filters
      if (_selectedCuisine != 'All' && spot.cuisine != _selectedCuisine)
        return false;
      if (_favoritesOnly && !spot.isFavorite) return false;

      // Filter by user's preferred cuisines
      if (_useMyPreferences && _userCuisines.isNotEmpty) {
        if (!_userCuisines.contains(spot.cuisine)) return false;
      }

      // ← UPDATED: Smart allergen filtering (ONLY CHANGE HERE)
      if (_hideAllergens && _userAllergies.isNotEmpty) {
        if (_spotContainsAllergens(spot)) {
          return false; // Hide this spot - contains user's allergens
        }
      }

      // Hours filters
      if (_selectedHours == 'Open Early') {
        final opensAt = spot.hours.split(' ').first;
        final hour =
            int.tryParse(
              opensAt
                  .replaceAll(RegExp(r'[^0-9]'), '')
                  .substring(
                    0,
                    opensAt.contains(':')
                        ? opensAt.indexOf(':')
                        : opensAt.length,
                  ),
            ) ??
            99;
        final isAm = opensAt.contains('am');
        if (!(isAm && hour <= 7)) return false;
      }

      if (_selectedHours == 'Open Late') {
  final parts = spot.hours.split(' - ');
  if (parts.length < 2) return false;
  final closesAt = parts[1].trim().toLowerCase();
  
  // Check for 24-hour spots
  if (closesAt.contains('24') || closesAt.contains('midnight')) {
    return true; // Always show 24-hour spots
  }
  
  final isPm = closesAt.contains('pm');
  final isAm = closesAt.contains('am');
  final hour =
      int.tryParse(
        closesAt.replaceAll(RegExp(r'[^0-9:]'), '').split(':').first,
      ) ??
      0;
  
  // "Open Late" means:
  // - Closes at 10 PM or later (10pm, 11pm, 12am/midnight)
  // - OR closes between 12 AM - 3 AM (midnight to early morning)
  if (isPm && hour >= 10) return true;  // 10pm, 11pm
  if (isAm && hour <= 3) return true;   // 12am, 1am, 2am, 3am (midnight to 3am)
  if (isAm && hour == 12) return true;  // 12am specifically (midnight)
  
  return false;
}

      // Budget filters

if (_selectedBudget != 'All') {
  if (_selectedBudget == 'Inexpensive' && spot.cost > 15) {
    return false;
  }
  if (_selectedBudget == 'Middle Ground' && (spot.cost <= 15 || spot.cost > 25)) {
    return false;
  }
  if (_selectedBudget == 'Expensive' && spot.cost <= 25) {
    return false;
  }
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Filter chips (HORIZONTALLY SCROLLABLE) ────────────────────────
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // Favorites filter
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: const Text('Favorites'),
                    selected: _favoritesOnly,
                    onSelected: (val) => setState(() => _favoritesOnly = val),
                    selectedColor: Colors.green.shade100,
                    checkmarkColor: Colors.green.shade800,
                    avatar: const Icon(
                      Icons.favorite,
                      size: 16,
                      color: Colors.red,
                    ),
                  ),
                ),

                // My Preferences filter
                if (_userCuisines.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      label: const Text('My Cuisines'),
                      selected: _useMyPreferences,
                      onSelected: (val) =>
                          setState(() => _useMyPreferences = val),
                      selectedColor: Colors.blue.shade100,
                      checkmarkColor: Colors.blue.shade800,
                      avatar: const Icon(Icons.restaurant_menu, size: 16),
                    ),
                  ),

                // Hide allergens filter
                if (_userAllergies.isNotEmpty &&
                    !_userAllergies.contains('None'))
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      label: const Text('Hide Allergens'),
                      selected: _hideAllergens,
                      onSelected: (val) => setState(() => _hideAllergens = val),
                      selectedColor: Colors.orange.shade100,
                      checkmarkColor: Colors.orange.shade800,
                      avatar: const Icon(
                        Icons.warning_amber_rounded,
                        size: 16,
                        color: Colors.orange,
                      ),
                    ),
                  ),

                // Cuisine dropdown
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedCuisine,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.restaurant_menu, size: 18),
                      items: _cuisineOptions
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedCuisine = val!),
                    ),
                  ),
                ),

                // Hours dropdown
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedHours,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.access_time, size: 18),
                      items: _hoursOptions
                          .map(
                            (h) => DropdownMenuItem(value: h, child: Text(h)),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => _selectedHours = val!),
                    ),
                  ),
                ),

                // Budget dropdown
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedBudget,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.attach_money, size: 18),
                      items: _budgetOptions
                          .map(
                            (b) => DropdownMenuItem(value: b, child: Text(b)),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedBudget = val!),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Active filters summary ─────────────────────────────────────────
          if (_useMyPreferences || _hideAllergens)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              color: Colors.blue.shade50,
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 16, color: Colors.blue),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _buildActiveFiltersText(),
                      style: const TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),

          // ── Results count ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              '${spots.length} spot${spots.length == 1 ? '' : 's'}',
              style: const TextStyle(color: Colors.blueGrey, fontSize: 12),
            ),
          ),

          // ── Food spot list ────────────────────────────────────────────────
          Expanded(
            child: spots.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No spots match your filters.',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedCuisine = 'All';
                              _favoritesOnly = false;
                              _selectedHours = 'All';
                              _selectedBudget = 'All';
                              _useMyPreferences = false;
                              _hideAllergens = false;
                            });
                          },
                          child: const Text('Clear all filters'),
                        ),
                      ],
                    ),
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
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  height: 100,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.restaurant,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                spot.name,
                                style: const TextStyle(fontSize: 24),
                              ),
                              Text(
                                spot.hours,
                                style: const TextStyle(color: Colors.blueGrey),
                              ),
                              Text(
                                '\$${spot.cost}',
                                style: const TextStyle(
                                  color: Colors.lightGreen,
                                ),
                              ),
                              Text(
                                spot.cuisine,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.blueGrey,
                                ),
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

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddFood(),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Spot'),
      ),
    );
  }

  String _buildActiveFiltersText() {
    List<String> active = [];

    if (_useMyPreferences) {
      active.add('Showing ${_userCuisines.join(', ')} cuisines');
    }

    if (_hideAllergens) {
      active.add('Hiding allergens: ${_userAllergies.join(', ')}');
    }

    return active.join(' • ');
  }
}