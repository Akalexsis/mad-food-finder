/*
  Author - Kayla Thornton
  Purpose - Display saved user profile preferences loaded from SharedPreferences.
            Allows users to retake the questionnaire at any time.
 */
import 'package:flutter/material.dart';
import '/shared_preferences_helper.dart';
import '/screens/Profile/questionnaireScreen.dart';

class ProfileScreen extends StatefulWidget {
  final Function(bool)? onThemeToggle;
  
  const ProfileScreen({super.key, this.onThemeToggle});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {
  Map<String, dynamic> _answers = {};
  bool _isLoading = true;
  bool _isDarkMode = false;

  // ← ADDED: Keep state alive when switching tabs
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadAnswers();
    _loadDarkMode();
  }

  // ← ADDED: Listen for when screen becomes visible again
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload dark mode setting whenever we switch to this tab
    _loadDarkMode();
  }

  Future<void> _loadAnswers() async {
    final answers = await SharedPreferencesHelper.loadAllAnswers();
    
    if (!mounted) return;
    
    setState(() {
      _answers = answers;
      _isLoading = false;
    });
  }

  Future<void> _loadDarkMode() async {
    final isDark = await SharedPreferencesHelper.getDarkMode();
    if (!mounted) return;
    setState(() {
      _isDarkMode = isDark;
    });
  }

  Future<void> _openQuestionnaire() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QuestionnaireScreen(fromProfile: true),
      ),
    );
   
    if (!mounted) return;
    
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

  Widget _buildValue(String value) {
    return Text(
      value.isEmpty ? 'Not set' : '\$$value/month',
      style: TextStyle(
        fontSize: 14,
        color: value.isEmpty ? Colors.blueGrey : Colors.black87,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // ← ADDED: Required for AutomaticKeepAliveClientMixin
    
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.green)),
      );
    }

    final List<String> cuisines       = List<String>.from(_answers['cuisines'] ?? []);
    final List<String> dietary        = List<String>.from(_answers['dietaryRestrictions'] ?? []);
    final List<String> allergies      = List<String>.from(_answers['allergies'] ?? []);
    final String budget               = _answers['monthlyBudget'] ?? '';
    final List<String> busiestDays    = List<String>.from(_answers['busiestDays'] ?? []);

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

            // ── App Settings (Dark Mode) ─────────────────────────────────
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: SwitchListTile(
                secondary: Icon(
                  _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: Colors.green,
                ),
                title: const Text('Dark Mode',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                subtitle: const Text('Switch between light and dark themes',
                    style: TextStyle(fontSize: 13)),
                value: _isDarkMode,
                activeColor: Colors.green,
                onChanged: (bool value) async {
                  // ← UPDATED: Immediately update local state
                  setState(() {
                    _isDarkMode = value;
                  });
                  
                  // Save to SharedPreferences
                  await SharedPreferencesHelper.saveDarkMode(value);
                  
                  // Notify parent to change theme
                  widget.onThemeToggle?.call(value);
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          value ? 'Dark mode enabled' : 'Light mode enabled',
                        ),
                        duration: const Duration(seconds: 1),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
              ),
            ),

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
                              'Food Finder will hide spots that may contain your allergens.',
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

            // ── Budget & Schedule ────────────────────────────────────────
            _buildSection(
              icon: Icons.attach_money_rounded,
              title: 'Monthly Food Budget',
              child: _buildValue(budget),
            ),

            _buildSection(
              icon: Icons.calendar_today,
              title: 'Busiest Days',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'We\'ll suggest quick meal options on these days',
                    style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 8),
                  _buildChips(busiestDays),
                ],
              ),
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