/*
 * Author - Kayla Thornton
 * Purpose - Allow users to update their settings 
 */
import 'package:flutter/material.dart';
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

  // save set values and re-route to profile screen
  Future<void> savePrefs() async {

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
            ),

            // TO-DO ADD STYLING AND SET INITIAL VALUE TO BE THE CURRENT VALUE
            Text('Preferred Cuisine', style: TextStyle( fontSize: 18 ), textAlign: .start,),
            TextField(
              controller: _cuisineController,
            ),

            ElevatedButton(
              onPressed: () { savePrefs(); }, 
              child: Text('Save')
            ),
          ],
        )
    );
  }
}
