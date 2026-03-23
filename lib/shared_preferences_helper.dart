/*
  Author - Kayla Thornton
  Purpose - Handle all SharedPreferences read/write operations for user profile questionnaire
 */
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  // Keys for questionnaire answers
  static const String keyHasCompletedQuestionnaire = 'has_completed_questionnaire';
  static const String keyCuisinePreferences = 'cuisine_preferences';
  static const String keyDietaryRestrictions = 'dietary_restrictions';
  static const String keyAllergies = 'allergies';
  static const String keyMonthlyBudget = 'monthly_budget';
  static const String keyBusiestDays = 'busiest_days';
  static const String keyDarkMode = 'dark_mode';

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

  // ─── BUSIEST DAYS ────────────────────────────────────────────────────────

  static Future<void> saveBusiestDays(List<String> days) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(keyBusiestDays, days);
  }

  static Future<List<String>> getBusiestDays() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(keyBusiestDays) ?? [];
  }

  // ─── DARK MODE ───────────────────────────────────────────────────────────

  static Future<void> saveDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyDarkMode, isDark);
  }

  static Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyDarkMode) ?? false;
  }

  // ─── SAVE ALL AT ONCE ────────────────────────────────────────────────────

  static Future<void> saveAllAnswers({
    required List<String> cuisines,
    required List<String> dietaryRestrictions,
    required List<String> allergies,
    required String monthlyBudget,
    required List<String> busiestDays,
  }) async {
    await saveCuisinePreferences(cuisines);
    await saveDietaryRestrictions(dietaryRestrictions);
    await saveAllergies(allergies);
    await saveMonthlyBudget(monthlyBudget);
    await saveBusiestDays(busiestDays);
    await setQuestionnnaireCompleted();
  }

  // ─── LOAD ALL AT ONCE ────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> loadAllAnswers() async {
    return {
      'cuisines': await getCuisinePreferences(),
      'dietaryRestrictions': await getDietaryRestrictions(),
      'allergies': await getAllergies(),
      'monthlyBudget': await getMonthlyBudget(),
      'busiestDays': await getBusiestDays(),
    };
  }

  // ─── RESET (retake questionnaire) ────────────────────────────────────────

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}