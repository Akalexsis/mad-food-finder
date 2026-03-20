/*
  Author - Kayla Thornton
  Purpose - 8-question stepper questionnaire that saves answers to SharedPreferences.
            Launches on first open; re-accessible from Profile tab at any time.
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/shared_preferences_helper.dart';

class QuestionnaireScreen extends StatefulWidget {
  // fromProfile = true  → show a back button (opened from Profile)
  // fromProfile = false → no back button (first-launch onboarding)
  final bool fromProfile;
  const QuestionnaireScreen({super.key, this.fromProfile = false});
  

  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}