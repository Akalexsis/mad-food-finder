/*
  Author - Kayla Thornton
  Purpose - Display saved user profile preferences loaded from SharedPreferences.
            Allows users to retake the questionnaire at any time.
 */
import 'package:flutter/material.dart';
import '/shared_preferences_helper.dart';
import '/screens/Profile/questionnaireScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> _answers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnswers();
  }

  Future<void> _loadAnswers() async {
    final answers = await SharedPreferencesHelper.loadAllAnswers();
    setState(() {
      _answers = answers;
      _isLoading = false;
    });
  }

  // Navigate to questionnaire and reload answers when returning
  Future<void> _openQuestionnaire() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QuestionnaireScreen(fromProfile: true),
      ),
    );
    // Reload after user potentially updates answers
    _loadAnswers();
  }

  // ─── Section card widget ─────────────────────────────────────────────────
  Widget _buildSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
            const Divider(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  // Chip row for list-type answers
  Widget _buildChips(List<String> items) {
    if (items.isEmpty) {
      return const Text('Not set', style: TextStyle(color: Colors.blueGrey));
    }
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: items
          .map((item) => Chip(
                label: Text(item, style: const TextStyle(fontSize: 12)),
                backgroundColor: Colors.green.shade50,
                side: BorderSide(color: Colors.green.shade200),
              ))
          .toList(),
    );
  }

  // Single-value answer row
  Widget _buildValue(String value) {
    return Text(
      value.isEmpty ? 'Not set' : value,
      style: TextStyle(
        fontSize: 14,
        color: value.isEmpty ? Colors.blueGrey : Colors.black87,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.green)),
      );
    }

    final List<String> cuisines       = List<String>.from(_answers['cuisines'] ?? []);
    final List<String> dietary        = List<String>.from(_answers['dietaryRestrictions'] ?? []);
    final List<String> allergies      = List<String>.from(_answers['allergies'] ?? []);
    final String budget               = _answers['monthlyBudget'] ?? '';
    final String frequency            = _answers['mealFrequency'] ?? '';
    final String schedule             = _answers['classSchedule'] ?? '';
    final List<String> busiestDays    = List<String>.from(_answers['busiestDays'] ?? []);
    final String goal                 = _answers['diningGoal'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────
            Container(
              width: double.infinity,
              color: Colors.green.shade50,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.green.shade200,
                    child: const Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text('My Food Preferences',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  const Text('Tap "Edit Profile" to update your answers',
                      style: TextStyle(fontSize: 13, color: Colors.blueGrey)),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Food Preferences ─────────────────────────────────────────
            _buildSection(
              icon: Icons.restaurant_menu,
              title: 'Cuisine Preferences',
              child: _buildChips(cuisines),
            ),

            _buildSection(
              icon: Icons.no_meals,
              title: 'Dietary Restrictions',
              child: _buildChips(dietary),
            ),

            _buildSection(
              icon: Icons.warning_amber_rounded,
              title: 'Allergies',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (allergies.isNotEmpty && !allergies.contains('None'))
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        border: Border.all(color: Colors.orange.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: Colors.orange.shade700, size: 16),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Food Finder will flag spots that may contain your allergens.',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.orange.shade800),
                            ),
                          ),
                        ],
                      ),
                    ),
                  _buildChips(allergies),
                ],
              ),
            ),

            // ── Budget & Habits ──────────────────────────────────────────
            _buildSection(
              icon: Icons.attach_money_rounded,
              title: 'Monthly Food Budget',
              child: _buildValue(budget),
            ),

            _buildSection(
              icon: Icons.repeat,
              title: 'How Often I Eat Out',
              child: _buildValue(frequency),
            ),

            // ── Schedule ────────────────────────────────────────────────
            _buildSection(
              icon: Icons.school,
              title: 'Class Schedule',
              child: _buildValue(schedule),
            ),

            _buildSection(
              icon: Icons.calendar_today,
              title: 'Busiest Days',
              child: _buildChips(busiestDays),
            ),

            // ── Goal ─────────────────────────────────────────────────────
            _buildSection(
              icon: Icons.flag_rounded,
              title: 'My Dining Goal',
              child: _buildValue(goal),
            ),

            // ── Edit button ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _openQuestionnaire,
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}