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

  // convert to list for code readability
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


  // clear form after successfully submitting form
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
      appBar: AppBar(),
      body: Column(
        children: [
          Text(
            'Add Food Spot',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),

          // accept all input
          Text(
            'Name',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.start,
          ),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Resturant name'),
          ),
          SizedBox(height: 20),

          Text(
            'Image',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.start,
          ),
          TextField(
            controller: _imageController,
            decoration: InputDecoration(labelText: 'Image URL'),
          ),

          Text(
            'Hours',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.start,
          ),
          TextField(
            controller: _hoursController,
            decoration: InputDecoration(labelText: '9:00AM - 5:00PM'),
          ),
          SizedBox(height: 20),

          Text(
            'Cost',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.start,
          ),
          TextField(
            controller: _costController,
            decoration: InputDecoration(labelText: 'Agerage cost'),
          ),
          SizedBox(height: 20),

          Text(
            'Cuisine',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.start,
          ),
          TextField(
            controller: _cuisineController,
            decoration: InputDecoration(labelText: 'American, Italian,...'),
          ),
          SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              _addFoodSpot();
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
