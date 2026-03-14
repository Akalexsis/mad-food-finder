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
  late String username;
  late String cuisine;
  late int budget;

  // get settings
  void initState(){
    super.initState();
  }

  // get user preferences
  Future<void> getPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: .start,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute( builder: (context) => EditProfile() )
              );
            }, 
            child: Text('Edit') 
          ),
          // Render username, profile pic, number of favorites, and number of spots visited
            // add edit profile button and view favorites button

          // List information to get from user (budget amount)
        ],
      )
    );
  }
}