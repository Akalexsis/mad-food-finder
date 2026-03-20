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

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  
  int _currentStep = 0;
  final TextEditingController _budgetController = TextEditingController();  
  // ─── Answer state ────────────────────────────────────────────────────────
  final List<String> _selectedCuisines = [];
  final List<String> _selectedDietary = [];
  final List<String> _selectedAllergies = [];
  String _selectedBudget = '';
  String _selectedMealFrequency = '';
  String _selectedClassSchedule = '';
  final List<String> _selectedBusiestDays = [];
  String _selectedDiningGoal = '';

  // ─── Question Answers
  final List<String> _cuisineOptions = [
    'American',
    'Italian',
    'Mexican',
    'Asian',
    'Mediterranean',
    'Fast Food',
    'Seafood',
    'Vegan / Plant-based',
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
  final List<String> _budgetOptions = [
    'Under \$25/mo',
    '\$25–\$50/mo',
    '\$50–\$100/mo',
    '\$100–\$200/mo',
    '\$200+/mo',
  ];
  final List<String> _frequencyOptions = [
    'Daily',
    '4–6 times/week',
    '2–3 times/week',
    'Once a week',
    'Less than once a week',
  ];
  final List<String> _scheduleOptions = [
    'MWF (Mon/Wed/Fri)',
    'TTh (Tue/Thu)',
    'MWF + TTh',
    'Online / Flexible',
    'Not currently enrolled',
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
  final List<String> _goalOptions = [
    'Save money',
    'Try new places',
    'Eat healthier',
    'Quick meals between classes',
    'Explore local spots',
  ];

  // ─── Helpers

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
        return _selectedMealFrequency.isNotEmpty;
      case 5:
        return _selectedClassSchedule.isNotEmpty;
      case 6:
        return _selectedBusiestDays.isNotEmpty;
      case 7:
        return _selectedDiningGoal.isNotEmpty;
      default:
        return false;
    }
  }

  Future<void> _saveAndFinish() async {
    await SharedPreferencesHelper.saveAllAnswers(
      cuisines: _selectedCuisines,
      dietaryRestrictions: _selectedDietary,
      allergies: _selectedAllergies,
      monthlyBudget: _selectedBudget,
      mealFrequency: _selectedMealFrequency,
      classSchedule: _selectedClassSchedule,
      busiestDays: _selectedBusiestDays,
      diningGoal: _selectedDiningGoal,
    );

    if (!mounted) return;

    if (widget.fromProfile) {
      // Return to Profile tab
      Navigator.pop(context);
    } else {
      // First-launch: replace questionnaire with main app
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

  Widget _buildRadioGroup(
    List<String> options,
    String current,
    ValueChanged<String> onChanged,
  ) {
    return Column(
      children: options.map((option) {
        return RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: current,
          activeColor: Colors.green,
          onChanged: (val) => onChanged(val!),
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
              'We\'ll warn you when a spot may not be safe.',
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

      // ── Step 5 ── Meal frequency
      Step(
        title: const Text('How Often You Eat Out'),
        isActive: _currentStep >= 4,
        state: _currentStep > 4 ? StepState.complete : StepState.indexed,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How often do you eat out or grab food on campus?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildRadioGroup(
              _frequencyOptions,
              _selectedMealFrequency,
              (val) => setState(() => _selectedMealFrequency = val),
            ),
          ],
        ),
      ),

      // ── Step 6 ── Class schedule
      Step(
        title: const Text('Class Schedule'),
        isActive: _currentStep >= 5,
        state: _currentStep > 5 ? StepState.complete : StepState.indexed,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What does your class schedule look like?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildRadioGroup(
              _scheduleOptions,
              _selectedClassSchedule,
              (val) => setState(() => _selectedClassSchedule = val),
            ),
          ],
        ),
      ),

      // ── Step 7 ── Busiest days
      Step(
        title: const Text('Busiest Days'),
        isActive: _currentStep >= 6,
        state: _currentStep > 6 ? StepState.complete : StepState.indexed,
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

      // ── Step 8 ── Dining goal
      Step(
        title: const Text('Dining Goal'),
        isActive: _currentStep >= 7,
        state: _currentStep > 7 ? StepState.complete : StepState.indexed,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What\'s your main goal when using Food Finder?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildRadioGroup(
              _goalOptions,
              _selectedDiningGoal,
              (val) => setState(() => _selectedDiningGoal = val),
            ),
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
        automaticallyImplyLeading:
            widget.fromProfile, // back btn only from Profile
      ),
      body: Column(
        children: [
          // Progress indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Step ${_currentStep + 1} of 8',
                  style: const TextStyle(color: Colors.blueGrey, fontSize: 13),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: LinearProgressIndicator(
                    value: (_currentStep + 1) / 8,
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
                final isLast = _currentStep == 7;
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
                            : null, // disabled until step is answered
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
