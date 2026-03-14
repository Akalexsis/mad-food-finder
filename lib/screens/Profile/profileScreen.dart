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
  late String displayName;
  late String cuisine;
  late double budget;

  int favorites = 3; // TO-DO get number of favoirted items

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

  // TO-DO - ROUTE USER TO HOME PAGE AND DISPLAY LIST OF FAVORITED ITEMS
  void _showFavorites() {
    print('Favorite spots');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: .start,
        children: [
          

          // Render username, profile pic, number of favorites, and number of spots visited
          Column( // group related information
            children: [
              // display user information
              ListTile(
                leading: Icon(Icons.person),
                title: Text(username, style: TextStyle( fontSize: 24 ), ),
                subtitle: Row( 
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text('\$$budget Monthly Budget'),
                    Text('$favorites Favorites'),
                    Text('$cuisine Preferred Cuisine')
                  ],
                )
              ),

              // display buttons in a row
              Row(
                children: [
                  ElevatedButton( // route to edit profile page to update preferences
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute( builder: (context) => EditProfile() ),
                    );

                    await _getPrefs(); // refresh page after saving profile edits
                  }, 
                  child: Text('Edit') 
                ),


                ElevatedButton( // route to home page to see list of favorited spots
                  onPressed: () { _showFavorites(); },
                  child: Text('Favorites') 
                ),
                ],
              )
              
              ],
            ),
          

          // List information to get from user (budget amount)
        ],
      )
    );
  }
}