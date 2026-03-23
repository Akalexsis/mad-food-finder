import 'package:flutter/material.dart';
import 'screens/Meals/mealScreen.dart';
import 'screens/Home/foodScreen.dart';
import 'screens/Budget/BudgetScreen.dart';
import 'screens/Profile/profileScreen.dart';
import 'screens/Profile/questionnaireScreen.dart';
import '/shared_preferences_helper.dart';

void main() {
  runApp(const FoodFinderApp());
}

class FoodFinderApp extends StatefulWidget {
  const FoodFinderApp({super.key});

  @override
  State<FoodFinderApp> createState() => _FoodFinderAppState();
}

class _FoodFinderAppState extends State<FoodFinderApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final isDark = await SharedPreferencesHelper.getDarkMode();
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _toggleTheme(bool isDark) async {
    await SharedPreferencesHelper.saveDarkMode(isDark);
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GSU Budget Bites',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      
      // Light theme
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      ),
      
      // Dark theme
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green[800],  // ← Darker green for dark mode
          foregroundColor: Colors.white,
        ),
      ),
      
      routes: {
        '/home': (context) => MainApp(onThemeToggle: _toggleTheme),
      },
      home: _LaunchController(onThemeToggle: _toggleTheme),
    );
  }
}

class MainApp extends StatelessWidget {
  final Function(bool) onThemeToggle;
  
  const MainApp({super.key, required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('GSU Budget Bites'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.food_bank), text: 'Eateries'),
              Tab(icon: Icon(Icons.lunch_dining_outlined), text: 'Meal Log'),
              Tab(icon: Icon(Icons.attach_money_rounded), text: 'Budget'),
              Tab(icon: Icon(Icons.account_circle_rounded), text: 'Profile'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FoodScreen(),
            MealScreen(),
            BudgetScreen(),
            ProfileScreen(onThemeToggle: onThemeToggle),
          ],
        ),
      ),
    );
  }
}

class _LaunchController extends StatefulWidget {
  final Function(bool) onThemeToggle;
  
  const _LaunchController({required this.onThemeToggle});

  @override
  _LaunchControllerState createState() => _LaunchControllerState();
}

class _LaunchControllerState extends State<_LaunchController> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: SharedPreferencesHelper.hasCompletedQuestionnaire(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.green),
            ),
          );
        }

        final hasCompleted = snapshot.data!;

        if (!hasCompleted) {
          return const QuestionnaireScreen(fromProfile: false);
        }

        return MainApp(onThemeToggle: widget.onThemeToggle);
      },
    );
  }
}