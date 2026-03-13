/*
 * Author - Kayla Thornton
 * Purpose - form for users to fill out to create a new meal log
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


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

  // ensure inputs are correct data type and fields aren't empty
  void _validateForm() {
    print('added spot');
  }

  // add new meal log to database and clear form
  void _addLogSpot() {
    _validateForm();

    // read the current name from the controller
    String name = _nameController.text;

    final confirm = SnackBar(content: Text('$name log has been added'));
    ScaffoldMessenger.of(context).showSnackBar(confirm);

    // reset form
    _resetForm();

    // route back to meal log page
    Navigator.pop(context);
  }

  // clear form after successfully submitting form
  void _resetForm() {
     setState(() {
      _nameController.clear();
      _descController.clear();
      _dateController.clear();
      _costController.clear();
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
      appBar: AppBar(),
      body: Column( children: [
        Text('New Meal Log', style: TextStyle( fontSize: 24 ), textAlign: TextAlign.center ),

        // accept all input
        Text('Name', style: TextStyle( fontSize: 18 ), textAlign: TextAlign.start),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Log Name'
          ),
        ),
        SizedBox(height: 20,),

        Text('Description', style: TextStyle( fontSize: 18 ), textAlign: TextAlign.start),
        TextField(
          controller: _descController,
          decoration: InputDecoration(
            labelText: 'I ordered ... '
          ),
        ),

        Text('date', style: TextStyle( fontSize: 18 ), textAlign: TextAlign.start),
        TextField(
          controller: _dateController,
          decoration: InputDecoration(
            labelText: 'Mar 16, 2026'
          ),
        ),
        SizedBox(height: 20,),
        
        Text('Cost', style: TextStyle( fontSize: 18 ), textAlign: TextAlign.start),
        TextField(
          controller: _costController,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d\.]')) // allow decimal values
          ],
          keyboardType: TextInputType.numberWithOptions( decimal: true ), // accept double int values from users
          decoration: InputDecoration(
            labelText: 'I spent ...'
          ),
        ),
        SizedBox(height: 20,),

        ElevatedButton(onPressed: () { _addLogSpot(); }, child: Text('Submit'))
      ])
    );
  }
}