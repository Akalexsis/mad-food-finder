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
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _cuisineController = TextEditingController();
  
  bool _isSubmitting = false;

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
        hours: _hoursController.text.trim(),
        cost: cost,
        cuisine: _cuisineController.text.trim(),
        isFavorite: false
        , // Default not favorite
      );

      // Insert into database
      await DatabaseHelper.instance.insertFoodSpot(foodSpot);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_nameController.text} has been added'),
            backgroundColor: Colors.green,
          ),
        );

        // Reset form
        _resetForm();

        // Navigate back
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding food spot: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  // Clear form after successfully submitting form
  void _resetForm() {
    setState(() {
      _nameController.clear();
      _imageController.clear();
      _hoursController.clear();
      _costController.clear();
      _cuisineController.clear();
    });
    _formKey.currentState?.reset();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageController.dispose();
    _hoursController.dispose();
    _costController.dispose();
    _cuisineController.dispose();
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
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an image URL';
                  }
                  // Basic URL validation
                  if (!value.startsWith('http://') && !value.startsWith('https://')) {
                    return 'Please enter a valid URL (starting with http:// or https://)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Hours field
              const Text('Hours *', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _hoursController,
                decoration: const InputDecoration(
                  labelText: '9:00AM - 5:00PM',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter operating hours';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Cost field
              const Text('Cost *', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _costController,
                decoration: const InputDecoration(
                  labelText: 'Average cost (e.g., 15)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
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

              // Cuisine field
              const Text('Cuisine *', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _cuisineController,
                decoration: const InputDecoration(
                  labelText: 'American, Italian,...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.restaurant_menu),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a cuisine type';
                  }
                  return null;
                },
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