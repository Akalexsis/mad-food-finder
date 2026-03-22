/*
  Author - Kayla Thornton
  Purpose - 5-question stepper questionnaire that saves answers to SharedPreferences.
            Launches on first open; re-accessible from Profile tab at any time.
            Users can skip and use a default profile.
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/shared_preference_helper.dart';

class QuestionnaireScreen extends StatefulWidget {
  // fromProfile = true  → show a back button (opened from Profile)
  // fromProfile = false → no back button (first-launch onboarding)
  final bool fromProfile;
  const QuestionnaireScreen({super.key, this.fromProfile = false});

  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  int _currentStep = 0;
  final TextEditingController _budgetController = TextEditingController();

  // ─── Answer state ────────────────────────────────────────────────────────
  final List<String> _selectedCuisines = [];
  final List<String> _selectedDietary = [];
  final List<String> _selectedAllergies = [];
  String _selectedBudget = '';
  final List<String> _selectedBusiestDays = [];

  // ─── Question options ────────────────────────────────────────────────────
  final List<String> _cuisineOptions = [
    'American',
    'Italian',
    'Mexican',
    'Asian',
    'Chinese',
    'Japanese',
    'Mediterranean',
    'Fast Food',
    'Seafood',
    'Vegan / Plant-based',
    'Cafe',
    'Other',
  ];

  final List<String> _dietaryOptions = [
    'None',
    'Vegetarian',
    'Vegan',
    'Gluten-Free',
    'Halal',
    'Kosher',
    'Dairy-Free',
    'Low-Carb',
  ];

  final List<String> _allergyOptions = [
    'None',
    'Peanuts',
    'Tree Nuts',
    'Shellfish',
    'Fish',
    'Dairy',
    'Eggs',
    'Wheat / Gluten',
    'Soy',
    'Sesame',
  ];

  final List<String> _dayOptions = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  // ─── Helpers ─────────────────────────────────────────────────────────────

  // Toggle item in a multi-select list
  void _toggle(List<String> list, String value) {
    setState(() {
      list.contains(value) ? list.remove(value) : list.add(value);
    });
  }

  bool _stepIsValid() {
    switch (_currentStep) {
      case 0:
        return _selectedCuisines.isNotEmpty;
      case 1:
        return _selectedDietary.isNotEmpty;
      case 2:
        return _selectedAllergies.isNotEmpty;
      case 3:
        return _selectedBudget.isNotEmpty &&
            double.tryParse(_selectedBudget) != null;
      case 4:
        return _selectedBusiestDays.isNotEmpty;
      default:
        return false;
    }
  }

  // ← NEW: Save default profile when user skips
  Future<void> _saveDefaultProfile() async {
    await SharedPreferencesHelper.saveAllAnswers(
      cuisines: ['American', 'Fast Food', 'Asian'], // Popular choices
      dietaryRestrictions: ['None'],
      allergies: ['None'],
      monthlyBudget: '100', // Average student budget
      busiestDays: ['Monday', 'Wednesday', 'Friday'], // Typical MWF schedule
    );

    if (!mounted) return;

    if (widget.fromProfile) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  // ← NEW: Show skip confirmation dialog
  Future<void> _confirmSkip() async {
    final shouldSkip = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Skip Setup?'),
        content: const Text(
          'We\'ll set up a default profile for you. You can always update your preferences later in the Profile tab.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Skip'),
          ),
        ],
      ),
    );

    if (shouldSkip == true) {
      _saveDefaultProfile();
    }
  }

  Future<void> _saveAndFinish() async {
    await SharedPreferencesHelper.saveAllAnswers(
      cuisines: _selectedCuisines,
      dietaryRestrictions: _selectedDietary,
      allergies: _selectedAllergies,
      monthlyBudget: _selectedBudget,
      busiestDays: _selectedBusiestDays,
    );

    if (!mounted) return;

    if (widget.fromProfile) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  // ─── UI builders ─────────────────────────────────────────────────────────

  Widget _buildChipGroup(List<String> options, List<String> selected) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selected.contains(option);
        return FilterChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (_) => _toggle(selected, option),
          selectedColor: Colors.green.shade100,
          checkmarkColor: Colors.green.shade800,
          labelStyle: TextStyle(
            color: isSelected ? Colors.green.shade800 : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }

  // Each step: returns a Step widget
  List<Step> _buildSteps() {
    return [
      // ── Step 1 ── Cuisine preferences
      Step(
        title: const Text('Cuisine Preferences'),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What cuisines do you enjoy? (Select all that apply)',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            _buildChipGroup(_cuisineOptions, _selectedCuisines),
          ],
        ),
      ),

      // ── Step 2 ── Dietary restrictions
      Step(
        title: const Text('Dietary Restrictions'),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Do you follow any dietary restrictions?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            _buildChipGroup(_dietaryOptions, _selectedDietary),
          ],
        ),
      ),

      // ── Step 3 ── Allergies
      Step(
        title: const Text('Allergies'),
        isActive: _currentStep >= 2,
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Do you have any food allergies we should know about?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text(
              'We\'ll warn you when a restaurant may not be safe.',
              style: TextStyle(fontSize: 13, color: Colors.blueGrey),
            ),
            const SizedBox(height: 12),
            _buildChipGroup(_allergyOptions, _selectedAllergies),
          ],
        ),
      ),

      // ── Step 4 ── Budget
      Step(
        title: const Text('Monthly Food Budget'),
        isActive: _currentStep >= 3,
        state: _currentStep > 3 ? StepState.complete : StepState.indexed,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What is your maximum monthly food budget?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _budgetController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d\.]')),
              ],
              decoration: const InputDecoration(
                prefixText: '\$ ',
                labelText: 'Enter amount (e.g. 150)',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => _selectedBudget = val),
            ),
          ],
        ),
      ),

      // ── Step 5 ── Busiest days
      Step(
        title: const Text('Busiest Days'),
        isActive: _currentStep >= 4,
        state: _currentStep > 4 ? StepState.complete : StepState.indexed,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Which days are you busiest? (We\'ll suggest quick options)',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            _buildChipGroup(_dayOptions, _selectedBusiestDays),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Food Profile'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: widget.fromProfile,
        // ← NEW: Skip button in AppBar
        actions: [
          TextButton(
            onPressed: _confirmSkip,
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Step ${_currentStep + 1} of 5',
                  style: const TextStyle(color: Colors.blueGrey, fontSize: 13),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: LinearProgressIndicator(
                    value: (_currentStep + 1) / 5,
                    backgroundColor: Colors.grey.shade200,
                    color: Colors.green,
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),

          // Stepper
          Expanded(
            child: Stepper(
              currentStep: _currentStep,
              onStepTapped: (step) => setState(() => _currentStep = step),
              controlsBuilder: (context, details) {
                final isLast = _currentStep == 4;
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _stepIsValid()
                            ? () {
                                if (isLast) {
                                  _saveAndFinish();
                                } else {
                                  setState(() => _currentStep++);
                                }
                              }
                            : null,
                        child: Text(isLast ? 'Finish' : 'Next'),
                      ),
                      if (_currentStep > 0) ...[
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: () => setState(() => _currentStep--),
                          child: const Text('Back'),
                        ),
                      ],
                    ],
                  ),
                );
              },
              steps: _buildSteps(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }
}