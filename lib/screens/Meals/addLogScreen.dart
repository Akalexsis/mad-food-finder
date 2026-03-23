/*
 * Author - Kayla Thornton
 * Purpose - Form for users to fill out to create a new meal log with food spot selection
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/database_helper.dart';
import '/models/meal_model.dart';
import '/models/food_model.dart';
import 'package:intl/intl.dart';

class AddLogScreen extends StatefulWidget {
  const AddLogScreen({super.key});

  @override
  _AddLogScreenState createState() => _AddLogScreenState();
}

class _AddLogScreenState extends State<AddLogScreen> {
  // Controllers for form inputs
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  // NEW: Controllers for quick add food spot
  final TextEditingController _newSpotNameController = TextEditingController();

  // Cuisine options
  final List<String> _cuisineOptions = [
    'American', 'Italian', 'Mexican', 'Asian',
    'Mediterranean', 'Fast Food', 'Seafood', 'Vegan / Plant-based', 'Cafe', 'Other'
  ];
  String? _newSpotCuisine; // Selected cuisine for quick add

  // Form validation key
  final _formKey = GlobalKey<FormState>();

  // Selected date
  DateTime? _selectedDate;

  // NEW: Food spot selection
  List<FoodSpot> _foodSpots = [];
  FoodSpot? _selectedFoodSpot;
  bool _isLoadingSpots = true;
  bool _showQuickAdd = false; // Toggle for quick add form

  @override
  void initState() {
    super.initState();
    // Set today's date as default
    _selectedDate = DateTime.now();
    _dateController.text = _formatDate(_selectedDate!);

    // Load food spots from database
    _loadFoodSpots();
  }

  // Load all food spots for dropdown
  Future<void> _loadFoodSpots() async {
    setState(() => _isLoadingSpots = true);

    try {
      final spots = await DatabaseHelper.instance.getAllFoodSpots();
      
      //  MOUNTED CHECK: Only update state if widget is still mounted
      if (!mounted) return;
      
      setState(() {
        _foodSpots = spots;
        _isLoadingSpots = false;
      });
    } catch (e) {
      //  MOUNTED CHECK: Only update state if widget is still mounted
      if (!mounted) return;
      
      setState(() => _isLoadingSpots = false);
      print('Error loading food spots: $e');
    }
  }

  // Quick add a new food spot
  Future<void> _quickAddFoodSpot() async {
    if (_newSpotNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a restaurant name')),
      );
      return;
    }

    if (_newSpotCuisine == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a cuisine type')),
      );
      return;
    }

    try {
      // Create new food spot with minimal info
      final newSpot = FoodSpot(
        name: _newSpotNameController.text.trim(),
        cuisine: _newSpotCuisine!,
        imageUrl: 'https://via.placeholder.com/150', // Default placeholder
        hours: 'Not specified',
        cost: 15, // Default average cost
        isFavorite: false,
      );

      // Insert into database
      await DatabaseHelper.instance.insertFoodSpot(newSpot);

      // Reload food spots
      await _loadFoodSpots();

      // MOUNTED CHECK: Only update state and show snackbar if widget is still mounted
      if (!mounted) return;

      // Select the newly added spot
      setState(() {
        _selectedFoodSpot = _foodSpots.firstWhere(
          (spot) => spot.name == newSpot.name,
        );
        _showQuickAdd = false;
        _newSpotNameController.clear();
        _newSpotCuisine = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${newSpot.name} added!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      //  MOUNTED CHECK: Only show snackbar if widget is still mounted
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding food spot: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Format date to match "Mar 16, 2026" format
  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  // Show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  // Validate form inputs
  bool _validateForm() {
    if (_selectedFoodSpot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a restaurant')),
      );
      return false;
    }

    if (_formKey.currentState?.validate() ?? false) {
      return true;
    }
    return false;
  }

  // Add new meal log to database
  Future<void> _addLogSpot() async {
    if (!_validateForm()) {
      return;
    }

    try {
      // Parse cost
      double cost = double.tryParse(_costController.text) ?? 0.0;

      // Create new meal model
      final newMeal = MealModel(
        name: _selectedFoodSpot!.name, // Use selected food spot name
        desc: _descController.text.trim(),
        date: _dateController.text,
        cost: cost,
        foodSpotId: _selectedFoodSpot!.id, // Link to food spot
      );

      // Insert into database
      await DatabaseHelper.instance.insertMeal(newMeal);

      //  MOUNTED CHECK: Only show snackbar and navigate if widget is still mounted
      if (!mounted) return;

      // Show confirmation
      final confirm = SnackBar(
        content: Text('Meal log for ${_selectedFoodSpot!.name} added!'),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(confirm);

      // Return true to indicate success and go back
      Navigator.pop(context, true);
    } catch (e) {
      //  MOUNTED CHECK: Only show error snackbar if widget is still mounted
      if (!mounted) return;
      
      // Show error message
      final errorSnackbar = SnackBar(
        content: Text('Error adding log: $e'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(errorSnackbar);
      print('Error adding meal log: $e');
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    _dateController.dispose();
    _costController.dispose();
    _newSpotNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Meal Log'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create a New Meal Log',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),

                // Food Spot Selection
                Text(
                  'Restaurant',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),

                if (_isLoadingSpots)
                  Center(child: CircularProgressIndicator())
                else if (_showQuickAdd)
                  // Quick Add Form
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add New Restaurant',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          
                          // Restaurant Name
                          TextField(
                            controller: _newSpotNameController,
                            decoration: InputDecoration(
                              labelText: 'Restaurant Name*',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.restaurant),
                            ),
                          ),
                          SizedBox(height: 10),
                          
                          // Cuisine Dropdown
                          DropdownButtonFormField<String>(
                            initialValue: _newSpotCuisine,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.restaurant_menu),
                              labelText: 'Cuisine Type*',
                              hintText: 'Select cuisine type',
                            ),
                            items: _cuisineOptions.map((String cuisine) {
                              return DropdownMenuItem<String>(
                                value: cuisine,
                                child: Text(cuisine),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _newSpotCuisine = newValue;
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          
                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _quickAddFoodSpot,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text('Add Restaurant'),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      _showQuickAdd = false;
                                      _newSpotNameController.clear();
                                      _newSpotCuisine = null;
                                    });
                                  },
                                  child: Text('Cancel'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  // Dropdown for existing food spots
                  Column(
                    children: [
                      DropdownButtonFormField<FoodSpot>(
                        initialValue: _selectedFoodSpot,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Select a restaurant',
                        ),
                        items: _foodSpots.map((spot) {
                          return DropdownMenuItem<FoodSpot>(
                            value: spot,
                            child: Text(spot.name),
                          );
                        }).toList(),
                        onChanged: (FoodSpot? newValue) {
                          setState(() {
                            _selectedFoodSpot = newValue;
                          });
                        },
                      ),
                      SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _showQuickAdd = true;
                            });
                          },
                          icon: Icon(Icons.add),
                          label: Text('Add New Restaurant'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),

                SizedBox(height: 20),

                // Description field
                Text(
                  'Description',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'What did you order?',
                    hintText: 'I ordered a cheeseburger and fries...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Date field
                Text(
                  'Date',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Select Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => _selectDate(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a date';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Cost field
                Text(
                  'Cost',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _costController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'How much did you spend?',
                    hintText: '15.99',
                    border: OutlineInputBorder(),
                    prefixText: '\$ ',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a cost';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _addLogSpot,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Submit', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}