import 'package:flutter/material.dart';
import './screens/Profile/profileScreen.dart';
import './screens/Profile/editProfile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EditProfile(),
    );
  }
}


