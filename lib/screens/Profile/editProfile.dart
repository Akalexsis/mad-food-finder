/*
 * Author - Kayla Thornton
 * Purpose - Allow users to update their settings 
 */
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // make input box for each category

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: .start,
          children: [
            const Text('You have pushed the button this many times:'),
          ],
        )
    );
  }
}
