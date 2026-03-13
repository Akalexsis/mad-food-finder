/*
 * Author - Kayla Thornton
 * Purpose - form for users to fill out to create a new food spot
 */
import 'package:flutter/material.dart';


class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  // convert to list for code readability
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _cuisineController = TextEditingController();

  // ensure inputs of correct form and fields aren't empty
  void _validateForm() {
    print('added spot');
  }

  // add new food spot to database and clear form
  void _addFoodSpot() {
    _validateForm();

    // read the current name from the controller
    String name = _nameController.text;

    final confirm = SnackBar(content: Text('$name has been added'));
    ScaffoldMessenger.of(context).showSnackBar(confirm);

    // reset form
    _resetForm();

    // navigate to previous screen
    Navigator.pop(context);
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
      body: Column( children: [
        Text('Add Food Spot', style: TextStyle( fontSize: 24 ), textAlign: TextAlign.center ),

        // accept all input
        Text('Name', style: TextStyle( fontSize: 18 ), textAlign: TextAlign.start),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Resturant name'
          ),
        ),
        SizedBox(height: 20,),

        Text('Image', style: TextStyle( fontSize: 18 ), textAlign: TextAlign.start),
        TextField(
          controller: _imageController,
          decoration: InputDecoration(
            labelText: 'Image URL'
          ),
        ),

        Text('Hours', style: TextStyle( fontSize: 18 ), textAlign: TextAlign.start),
        TextField(
          controller: _hoursController,
          decoration: InputDecoration(
            labelText: '9:00AM - 5:00PM'
          ),
        ),
        SizedBox(height: 20,),
        
        Text('Cost', style: TextStyle( fontSize: 18 ), textAlign: TextAlign.start),
        TextField(
          controller: _costController,
          decoration: InputDecoration(
            labelText: 'Agerage cost'
          ),
        ),
        SizedBox(height: 20,),

        Text('Cuisine', style: TextStyle( fontSize: 18 ), textAlign: TextAlign.start),
        TextField(
          controller: _cuisineController,
          decoration: InputDecoration(
            labelText: 'American, Italian,...'
          ),
        ),
        SizedBox(height: 20,),

        ElevatedButton(onPressed: () { _addFoodSpot(); }, child: Text('Submit'))
      ])
    );
  }
}