/*
 * Author - Kayla Thornton
 * Purpose - Edit existing food spot details
 */
import 'package:flutter/material.dart';
import '../../models/food_model.dart';
import '../../database_helper.dart';

class EditFoodScreen extends StatefulWidget {
  final FoodSpot spot;
  
  const EditFoodScreen({super.key, required this.spot});

  @override
  _EditFoodScreenState createState() => _EditFoodScreenState();
}

class _EditFoodScreenState extends State<EditFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _nameController;
  late final TextEditingController _imageController;
  late final TextEditingController _costController;
  late final TextEditingController _menuUrlController;
  
  final List<String> _selectedAllergens = [];
  
  final List<String> _allergenOptions = [
    'Dairy', 'Eggs', 'Fish', 'Shellfish', 'Tree Nuts', 
    'Peanuts', 'Wheat', 'Gluten', 'Soy'
  ];

  // : Cuisine dropdown options
  final List<String> _cuisineOptions = [
    'American', 'Italian', 'Mexican', 'Asian', 'Chinese', 'Japanese',
    'Mediterranean', 'Fast Food', 'Seafood', 'Vegan / Plant-based', 'Cafe', 'Other'
  ];
  String? _selectedCuisine;

  // Time dropdown options
  final List<String> _timeOptions = [
    '12:00 AM', '1:00 AM', '2:00 AM', '3:00 AM', '4:00 AM', '5:00 AM',
    '6:00 AM', '7:00 AM', '8:00 AM', '9:00 AM', '10:00 AM', '11:00 AM',
    '12:00 PM', '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM',
    '6:00 PM', '7:00 PM', '8:00 PM', '9:00 PM', '10:00 PM', '11:00 PM',
  ];
  String? _openingTime;
  String? _closingTime;

  //Smart allergen defaults by cuisine
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

  @override
  void initState() {
    super.initState();
    
    // Pre-fill text fields
    _nameController = TextEditingController(text: widget.spot.name);
    _imageController = TextEditingController(text: widget.spot.imageUrl);
    _costController = TextEditingController(text: widget.spot.cost.toString());
    _menuUrlController = TextEditingController(text: widget.spot.menuUrl ?? '');
    
    // Pre-fill cuisine
    _selectedCuisine = widget.spot.cuisine;
    
    // ← NEW: Parse existing hours into opening/closing times
    _parseHours(widget.spot.hours);
    
    // Pre-fill allergens
    _selectedAllergens.addAll(widget.spot.potentialAllergens);
  }

  //  Parse "6:00am - 12:00am" into opening/closing times
  void _parseHours(String hours) {
    final parts = hours.split(' - ');
    if (parts.length == 2) {
      _openingTime = _formatTime(parts[0].trim());
      _closingTime = _formatTime(parts[1].trim());
    }
  }

  // Convert "6:00am" to "6:00 AM" (match dropdown format)
  String _formatTime(String time) {
    // Replace lowercase am/pm with uppercase AM/PM
    time = time.replaceAll('am', ' AM').replaceAll('pm', ' PM');
    
    // Ensure format is "H:MM AM" not "H:MMAM"
    if (!time.contains(' ')) {
      if (time.contains('AM')) {
        time = time.replaceAll('AM', ' AM');
      } else if (time.contains('PM')) {
        time = time.replaceAll('PM', ' PM');
      }
    }
    
    return time;
  }

  // Get hours string for database
  String _getHoursString() {
    if (_openingTime == null || _closingTime == null) {
      return 'Hours not specified';
    }
    return '$_openingTime - $_closingTime';
  }

  // ← NEW: Auto-populate allergens when cuisine changes
  void _onCuisineChanged(String? cuisine) {
    setState(() {
      _selectedCuisine = cuisine;
      
      // Show dialog asking if user wants to update allergens
      if (cuisine != null && _cuisineAllergens.containsKey(cuisine)) {
        _showAllergenUpdateDialog(cuisine);
      }
    });
  }

  // Ask user if they want to update allergens
  Future<void> _showAllergenUpdateDialog(String cuisine) async {
    final shouldUpdate = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Allergens?'),
        content: Text(
          'Would you like to update the allergens to match typical $cuisine cuisine allergens?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep Current'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Update'),
          ),
        ],
      ),
    );

    if (shouldUpdate == true) {
      setState(() {
        _selectedAllergens.clear();
        _selectedAllergens.addAll(_cuisineAllergens[cuisine]!);
      });
    }
  }

  void _validateForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCuisine == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a cuisine type')),
      );
      return;
    }

    if (_openingTime == null || _closingTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select opening and closing times')),
      );
      return;
    }

    _updateFoodSpot();
  }

  Future<void> _updateFoodSpot() async {
    final updatedSpot = widget.spot.copyWith(
      name: _nameController.text,
      imageUrl: _imageController.text,
      hours: _getHoursString(),
      cost: int.parse(_costController.text),
      cuisine: _selectedCuisine!,
      menuUrl: _menuUrlController.text.isNotEmpty ? _menuUrlController.text : null,
      potentialAllergens: _selectedAllergens,
    );

    await DatabaseHelper.instance.updateFoodSpot(updatedSpot);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_nameController.text} has been updated'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, true);
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
        title: const Text('Edit Food Spot'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              const Text('Name *', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
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

              // Image URL
              const Text('Image URL *', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              //Cuisine dropdown (same style as AddFoodScreen)
              const Text('Cuisine *', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
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
                onChanged: _onCuisineChanged,
                validator: (value) {
                  if (value == null) {
                    return 'Please select a cuisine type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Hours dropdowns (same style as AddFoodScreen)
              const Text('Hours *', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
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
              
              // Show formatted hours preview
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

              // Cost
              const Text('Cost *', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _costController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Average cost',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                  prefixText: '\$ ',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a cost';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Menu URL
              const Text('Menu URL (Optional)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _menuUrlController,
                decoration: const InputDecoration(
                  labelText: 'https://restaurant.com/menu',
                  border: OutlineInputBorder(),
                  hintText: 'Leave empty if no online menu',
                  prefixIcon: Icon(Icons.menu_book),
                ),
              ),
              const SizedBox(height: 20),

              // Potential Allergens
              const Text('Potential Allergens', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
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
              const SizedBox(height: 30),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _validateForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Save Changes', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}