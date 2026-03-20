/*
 * Author - Kayla Thornton
 * Purpose - form for users to fill out to create a new meal log
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/database_helper.dart';
import '/models/meal_model.dart';
import 'package:intl/intl.dart'; // For date formatting

class AddLogScreen extends StatefulWidget {
  const AddLogScreen({super.key});

  @override
  _AddLogScreenState createState() => _AddLogScreenState();
}

class _AddLogScreenState extends State<AddLogScreen> {
  // convert to list for code readability
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  // Form validation key
  final _formKey = GlobalKey<FormState>();

  // Selected date
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // Set today's date as default
    _selectedDate = DateTime.now();
    _dateController.text = _formatDate(_selectedDate!);
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
    if (_formKey.currentState?.validate() ?? false) {
      return true;
    }
    return false;
  }

  // Add new meal log to database and clear form
  Future<void> _addLogSpot() async {
    if (!_validateForm()) {
      return;
    }

    try {
      // Parse cost
      double cost = double.tryParse(_costController.text) ?? 0.0;

      // Create new meal model
      final newMeal = MealModel(
        name: _nameController.text.trim(),
        desc: _descController.text.trim(),
        date: _dateController.text,
        cost: cost,
      );

      // Insert into database
      await DatabaseHelper.instance.insertMeal(newMeal);

      // Show confirmation
      String name = _nameController.text.trim();
      final confirm = SnackBar(
        content: Text('$name log has been added'),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(confirm);

      // Reset form
      _resetForm();

      // Return true to indicate success and go back
      Navigator.pop(context, true);
    } catch (e) {
      // Show error message
      final errorSnackbar = SnackBar(
        content: Text('Error adding log: $e'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(errorSnackbar);
      print('Error adding meal log: $e');
    }
  }

  // Clear form after successfully submitting form
  void _resetForm() {
    setState(() {
      _nameController.clear();
      _descController.clear();
      _costController.clear();
      _selectedDate = DateTime.now();
      _dateController.text = _formatDate(_selectedDate!);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _dateController.dispose();
    _costController.dispose();
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
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                
                // Name field
                Text(
                  'Name',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Log Name',
                    hintText: 'e.g., Lunch at Joe\'s Diner',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
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
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
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
                    child: Text(
                      'Submit',
                      style: TextStyle(fontSize: 18),
                    ),
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