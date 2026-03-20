/*
  Author - Kayla Thornton
  Purpose - Handle all SharedPreferences read/write operations for user profile questionnaire
 */
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  // Keys for all questionnaire answers
  static const String keyHasCompletedQuestionnaire = 'has_completed_questionnaire';
  static const String keyCuisinePreferences = 'cuisine_preferences';     // List<String>
  static const String keyDietaryRestrictions = 'dietary_restrictions';   // List<String>
  static const String keyAllergies = 'allergies';                         // List<String>
  static const String keyMonthlyBudget = 'monthly_budget';               // String (e.g. "50-100")
  static const String keyMealFrequency = 'meal_frequency';               // String
  static const String keyClassSchedule = 'class_schedule';               // String (e.g. "MWF", "TTh")
  static const String keyBusiestDays = 'busiest_days';                   // List<String>
  static const String keyDiningGoal = 'dining_goal';                     // String

  // ─── COMPLETED FLAG ───────────────────────────────────────────────────────

  static Future<bool> hasCompletedQuestionnaire() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyHasCompletedQuestionnaire) ?? false;
  }

  static Future<void> setQuestionnnaireCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyHasCompletedQuestionnaire, true);
  }

  // ─── CUISINE PREFERENCES ─────────────────────────────────────────────────

  static Future<void> saveCuisinePreferences(List<String> cuisines) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(keyCuisinePreferences, cuisines);
  }

  static Future<List<String>> getCuisinePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(keyCuisinePreferences) ?? [];
  }

  // ─── DIETARY RESTRICTIONS ────────────────────────────────────────────────

  static Future<void> saveDietaryRestrictions(List<String> restrictions) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(keyDietaryRestrictions, restrictions);
  }

  static Future<List<String>> getDietaryRestrictions() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(keyDietaryRestrictions) ?? [];
  }

  // ─── ALLERGIES ───────────────────────────────────────────────────────────

  static Future<void> saveAllergies(List<String> allergies) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(keyAllergies, allergies);
  }

  static Future<List<String>> getAllergies() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(keyAllergies) ?? [];
  }

  // ─── MONTHLY BUDGET ──────────────────────────────────────────────────────

  static Future<void> saveMonthlyBudget(String budget) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyMonthlyBudget, budget);
  }

  static Future<String> getMonthlyBudget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyMonthlyBudget) ?? 'Not set';
  }

  // ─── MEAL FREQUENCY ──────────────────────────────────────────────────────

  static Future<void> saveMealFrequency(String frequency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyMealFrequency, frequency);
  }

  static Future<String> getMealFrequency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyMealFrequency) ?? 'Not set';
  }

  // ─── CLASS SCHEDULE ──────────────────────────────────────────────────────

  static Future<void> saveClassSchedule(String schedule) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyClassSchedule, schedule);
  }

  static Future<String> getClassSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyClassSchedule) ?? 'Not set';
  }

  // ─── BUSIEST DAYS ────────────────────────────────────────────────────────

  static Future<void> saveBusiestDays(List<String> days) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(keyBusiestDays, days);
  }

  static Future<List<String>> getBusiestDays() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(keyBusiestDays) ?? [];
  }

  // ─── DINING GOAL ─────────────────────────────────────────────────────────

  static Future<void> saveDiningGoal(String goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyDiningGoal, goal);
  }

  static Future<String> getDiningGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyDiningGoal) ?? 'Not set';
  }

  // ─── SAVE ALL AT ONCE ────────────────────────────────────────────────────

  static Future<void> saveAllAnswers({
    required List<String> cuisines,
    required List<String> dietaryRestrictions,
    required List<String> allergies,
    required String monthlyBudget,
    required String mealFrequency,
    required String classSchedule,
    required List<String> busiestDays,
    required String diningGoal,
  }) async {
    await saveCuisinePreferences(cuisines);
    await saveDietaryRestrictions(dietaryRestrictions);
    await saveAllergies(allergies);
    await saveMonthlyBudget(monthlyBudget);
    await saveMealFrequency(mealFrequency);
    await saveClassSchedule(classSchedule);
    await saveBusiestDays(busiestDays);
    await saveDiningGoal(diningGoal);
    await setQuestionnnaireCompleted();
  }

  // ─── LOAD ALL AT ONCE ────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> loadAllAnswers() async {
    return {
      'cuisines': await getCuisinePreferences(),
      'dietaryRestrictions': await getDietaryRestrictions(),
      'allergies': await getAllergies(),
      'monthlyBudget': await getMonthlyBudget(),
      'mealFrequency': await getMealFrequency(),
      'classSchedule': await getClassSchedule(),
      'busiestDays': await getBusiestDays(),
      'diningGoal': await getDiningGoal(),
    };
  }

  // ─── RESET (retake questionnaire) ────────────────────────────────────────

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}