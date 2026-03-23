/*
 * Author - Kayla Thornton
 * Purpose - form for users to fill out to create a new food spot
 */
import 'package:flutter/material.dart';
import '/database_helper.dart';
import '/models/food_model.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _menuUrlController = TextEditingController();  // ← NEW
  
  // Cuisine options
  final List<String> _cuisineOptions = [
    'American', 'Italian', 'Mexican', 'Asian', 'Chinese', 'Japanese',
    'Mediterranean', 'Fast Food', 'Seafood', 'Vegan / Plant-based', 'Cafe', 'Other'
  ];
  String? _selectedCuisine;
  
  // Hours options (common restaurant hours)
  final List<String> _timeOptions = [
    '12:00 AM', '1:00 AM', '2:00 AM', '3:00 AM', '4:00 AM', '5:00 AM',
    '6:00 AM', '7:00 AM', '8:00 AM', '9:00 AM', '10:00 AM', '11:00 AM',
    '12:00 PM', '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM',
    '6:00 PM', '7:00 PM', '8:00 PM', '9:00 PM', '10:00 PM', '11:00 PM',
  ];
  
  String? _openingTime;
  String? _closingTime;
  
  // ← NEW: Allergen tracking
  final List<String> _selectedAllergens = [];
  
  final List<String> _allergenOptions = [
    'Dairy', 'Eggs', 'Fish', 'Shellfish', 'Tree Nuts', 
    'Peanuts', 'Wheat', 'Gluten', 'Soy'
  ];
  
  // ← NEW: Smart allergen defaults by cuisine
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
    'Other': [],
  };
  
  bool _isSubmitting = false;

  // ← NEW: Auto-populate allergens when cuisine changes
  void _onCuisineChanged(String? cuisine) {
    setState(() {
      _selectedCuisine = cuisine;
      
      // Auto-populate allergens based on cuisine
      _selectedAllergens.clear();
      if (cuisine != null && _cuisineAllergens.containsKey(cuisine)) {
        _selectedAllergens.addAll(_cuisineAllergens[cuisine]!);
      }
    });
  }

  // Get hours string for database
  String _getHoursString() {
    if (_openingTime == null || _closingTime == null) {
      return 'Hours not specified';
    }
    return '$_openingTime - $_closingTime';
  }

  // Validate form inputs
  bool _validateForm() {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields correctly'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    
    if (_selectedCuisine == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a cuisine type'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    
    if (_openingTime == null || _closingTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select opening and closing times'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    
    return true;
  }

  // Add new food spot to database and clear form
  Future<void> _addFoodSpot() async {
    if (!_validateForm()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Parse cost as integer
      int cost = int.tryParse(_costController.text) ?? 0;
      
      // Create FoodSpot object
      final foodSpot = FoodSpot(
        name: _nameController.text.trim(),
        imageUrl: _imageController.text.trim(),
        hours: _getHoursString(),
        cost: cost,
        cuisine: _selectedCuisine!,
        isFavorite: false,
        potentialAllergens: _selectedAllergens,  // ← NEW
        menuUrl: _menuUrlController.text.trim().isNotEmpty 
            ? _menuUrlController.text.trim() 
            : null,  // ← NEW
      );

      // Insert into database
      await DatabaseHelper.instance.insertFoodSpot(foodSpot);

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_nameController.text} has been added'),
          backgroundColor: Colors.green,
        ),
      );

      // Reset form
      _resetForm();

      // Navigate back
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding food spot: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });
    }
  }

  // Clear form after successfully submitting form
  void _resetForm() {
    setState(() {
      _nameController.clear();
      _imageController.clear();
      _costController.clear();
      _menuUrlController.clear();
      _selectedCuisine = null;
      _openingTime = null;
      _closingTime = null;
      _selectedAllergens.clear();
    });
    _formKey.currentState?.reset();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageController.dispose();
    _costController.dispose();
    _menuUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Food Spot'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Food Spot',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Name field
              const Text('Name *', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Restaurant name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.restaurant),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a restaurant name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Image URL field
              const Text('Image *', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  hintText: 'https://example.com/logo.png',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an image URL';
                  }
                  if (!value.startsWith('http://') && !value.startsWith('https://')) {
                    return 'Please enter a valid URL (starting with http:// or https://)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Cuisine dropdown
              const Text('Cuisine *', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCuisine,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.restaurant_menu),
                  hintText: 'Select cuisine type',
                ),
                items: _cuisineOptions.map((String cuisine) {
                  return DropdownMenuItem<String>(
                    value: cuisine,
                    child: Text(cuisine),
                  );
                }).toList(),
                onChanged: _onCuisineChanged,  // ← CHANGED: Use new method
                validator: (value) {
                  if (value == null) {
                    return 'Please select a cuisine type';
                  }
                  return null;
                },
              ),
              
              // ← NEW: Show info banner when cuisine is selected
              if (_selectedCuisine != null && _selectedCuisine != 'Other')
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    border: Border.all(color: Colors.blue.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'We\'ve pre-selected common allergens for $_selectedCuisine cuisine. You can add or remove allergens below.',
                          style: TextStyle(fontSize: 12, color: Colors.blue.shade800),
                        ),
                      ),
                    ],
                  ),
                ),
              
              const SizedBox(height: 20),

              // Hours dropdowns
              const Text('Hours *', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _openingTime,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Opening',
                        prefixIcon: Icon(Icons.wb_sunny, color: Colors.orange),
                      ),
                      items: _timeOptions.map((String time) {
                        return DropdownMenuItem<String>(
                          value: time,
                          child: Text(time),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _openingTime = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Select time';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('-', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _closingTime,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Closing',
                        prefixIcon: Icon(Icons.nightlight_round, color: Colors.indigo),
                      ),
                      items: _timeOptions.map((String time) {
                        return DropdownMenuItem<String>(
                          value: time,
                          child: Text(time),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _closingTime = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Select time';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              if (_openingTime != null && _closingTime != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: Text(
                      'Hours: ${_getHoursString()}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // Cost field
              const Text('Average Cost *', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _costController,
                decoration: const InputDecoration(
                  labelText: 'Average cost per meal',
                  hintText: '15',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                  prefixText: '\$ ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an average cost';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // ← NEW: Menu URL field
              const Text('Menu URL (Optional)', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _menuUrlController,
                decoration: const InputDecoration(
                  labelText: 'Online menu link',
                  hintText: 'https://restaurant.com/menu',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.menu_book),
                ),
              ),
              const SizedBox(height: 20),

              // ← NEW: Allergen selection
              const Text('Potential Allergens (Optional)', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              const Text(
                'Select all allergens that may be present at this restaurant',
                style: TextStyle(fontSize: 12, color: Colors.blueGrey),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _allergenOptions.map((allergen) {
                  return FilterChip(
                    label: Text(allergen),
                    selected: _selectedAllergens.contains(allergen),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedAllergens.add(allergen);
                        } else {
                          _selectedAllergens.remove(allergen);
                        }
                      });
                    },
                    selectedColor: Colors.orange.shade100,
                    checkmarkColor: Colors.orange.shade700,
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _addFoodSpot,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Submit',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}