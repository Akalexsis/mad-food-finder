/*
 * Author - Kayla Thornton
 * Purpose - Allow users to update their settings 
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // make input box for each category
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _cuisineController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  
  // load text fields with existing data

  // save form values and re-route to profile screen
  Future<void> _savePrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    double budgetValue = double.parse( _budgetController.text ); // convert budget's value to double

    // save form values in shared preferences
    await prefs.setString('username', _usernameController.text);
    await prefs.setDouble('budget', budgetValue);
    await prefs.setString('display', _displayNameController.text);
    await prefs.setString('cuisine', _cuisineController.text);

    // route to profile screen
    const confirm = SnackBar(content: Text('Profile Updated'),);
    ScaffoldMessenger.of(context).showSnackBar(confirm);

    Navigator.pop(context); 
  }


  // dispose of controllers 
  @override 
  void dispose(){
    _usernameController.dispose();
    _budgetController.dispose();
    _cuisineController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: .start,
          children: [
            Text('Edit Profile', style: TextStyle( fontSize: 24 ), textAlign: .start),

            // TO-DO ADD STYLING AND SET INITIAL VALUE TO BE THE CURRENT VALUE
            Text('Display Name', style: TextStyle( fontSize: 18 ), textAlign: .start),
            TextField(
              controller: _displayNameController,
            ),

            // TO-DO ADD STYLING AND SET INITIAL VALUE TO BE THE CURRENT VALUE
            Text('Username', style: TextStyle( fontSize: 18 ), textAlign: .start),
            TextField(
              controller: _usernameController,
            ),

            // TO-DO ADD STYLING AND SET INITIAL VALUE TO BE THE CURRENT VALUE
            Text('Monthly Budget', style: TextStyle( fontSize: 18 ), textAlign: .start),
            TextField(
              controller: _budgetController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d\.]')) // allow decimal values
              ],
              keyboardType: TextInputType.numberWithOptions( decimal: true ),
            ),

            // TO-DO ADD STYLING AND SET INITIAL VALUE TO BE THE CURRENT VALUE
            Text('Preferred Cuisine', style: TextStyle( fontSize: 18 ), textAlign: .start,),
            TextField(
              controller: _cuisineController,
            ),

            ElevatedButton(
              onPressed: () { _savePrefs(); }, 
              child: Text('Save')
            ),
          ],
        )
    );
  }
}
