/*
 * Author - Kayla Thornton
 * Purpose - Allow users to view their settings
 */
import 'package:flutter/material.dart';
import '../Profile/editProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // store settings
  late String? username;
  late String? displayName;
  late String? cuisine;
  late double? budget;

  // get settings
  @override
  void initState(){
    super.initState();
    _getPrefs();
  }

  // get user preferences
  Future<void> _getPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // render values for each category
    setState( () {
      username = prefs.getString('username') ?? ''; // only render values that exist
      displayName = prefs.getString('display') ?? '';
      cuisine = prefs.getString('cuisine') ?? '';
      budget = prefs.getDouble('budget') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: .start,
        children: [
          ElevatedButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute( builder: (context) => EditProfile() ),
              );

              await _getPrefs(); // refresh page after saving profile edits
            }, 
            child: Text('Edit') 
          ),
          // Render username, profile pic, number of favorites, and number of spots visited
            // add edit profile button and view favorites button
          Text('Name: $displayName'),
          Text('Username: $username'),
          Text('Monthly Budget: \$$budget'),
          Text('Preferred Cuisine: $cuisine'),
          

          // List information to get from user (budget amount)
        ],
      )
    );
  }
}