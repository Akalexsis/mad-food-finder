/*
 * Author - Kayla Thornton
 * Purpose - Allow users to view their settings
 */
import 'package:flutter/material.dart';

void main() {
  runApp(const ProfilePage());
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Profile Page')
    );
  }
}