import 'package:flutter/material.dart';

class TDEECalculator extends StatefulWidget {
  const TDEECalculator({super.key});

  @override
  State<TDEECalculator> createState() => _TDEECalculatorState();
}

class _TDEECalculatorState extends State<TDEECalculator> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  String _gender = 'male';
  String _activityLevel = 'moderate';
  String _formula = 'mifflin';
  double? _bmr;
  double? _tdee;

  final Map<String, double> _activityMultipliers = {
    'sedentary': 1.2,
    'light': 1.375,
    'moderate': 1.55,
    'active': 1.725,
    'veryActive': 1.9,
  };

  final Map<String, String> _activityDescriptions = {
    'sedentary': 'Little or no exercise, desk job',
    'light': 'Light exercise 1-3 days/week',
    'moderate': 'Moderate exercise 3-5 days/week',
    'active': 'Hard exercise 6-7 days/week',
    'veryActive': 'Very hard exercise, physical job or training twice a day',
  };

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _calculateTDEE() {
    if (_heightController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _ageController.text.isEmpty) {
      return;
    }

    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);
    final age = int.tryParse(_ageController.text);

    if (height == null || weight == null || age == null) {
      return;
    }

    // Validate input ranges
    if (height < 50 || height > 250) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a valid height between 50cm and 250cm')),
      );
      return;
    }
    if (weight < 20 || weight > 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a valid weight between 20kg and 500kg')),
      );
      return;
    }
    if (age < 15 || age > 120) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a valid age between 15 and 120 years')),
      );
      return;
    }

    double bmrValue = 0;

    // Calculate BMR based on selected formula
    if (_formula == 'mifflin') {
      // Mifflin-St Jeor Equation
      if (_gender == 'male') {
        bmrValue = (10 * weight) + (6.25 * height) - (5 * age) + 5;
      } else {
        bmrValue = (10 * weight) + (6.25 * height) - (5 * age) - 161;
      }
    } else if (_formula == 'harris') {
      // Harris-Benedict Equation
      if (_gender == 'male') {
        bmrValue = 66.5 + (13.75 * weight) + (5.003 * height) - (6.75 * age);
      } else {
        bmrValue = 655.1 + (9.563 * weight) + (1.850 * height) - (4.676 * age);
      }
    } else if (_formula == 'katch') {
      // Katch-McArdle Formula (requires body fat percentage, using default 15% for males, 25% for females)
      double bodyFatPercentage = _gender == 'male' ? 15 : 25;
      double leanBodyMass = weight * (1 - (bodyFatPercentage / 100));
      bmrValue = 370 + (21.6 * leanBodyMass);
    }

    // Calculate TDEE based on activity level
    final tdeeValue = bmrValue * _activityMultipliers[_activityLevel]!;
    
    setState(() {
      _bmr = double.parse(bmrValue.toStringAsFixed(0));
      _tdee = double.parse(tdeeValue.toStringAsFixed(0));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TDEE Calculator',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gender selection
                    const Text(
                      'Gender',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _gender = 'male';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _gender == 'male'
                                    ? Colors.green
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _gender == 'male'
                                      ? Colors.green
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Male',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _gender == 'male'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _gender = 'female';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _gender == 'female'
                                    ? Colors.green
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _gender == 'female'
                                      ? Colors.green
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Female',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _gender == 'female'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Formula selection
                    const Text(
                      'BMR Formula',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _formula,
                          items: const [
                            DropdownMenuItem(
                              value: 'mifflin',
                              child: Text('Mifflin-St Jeor'),
                            ),
                            DropdownMenuItem(
                              value: 'harris',
                              child: Text('Harris-Benedict'),
                            ),
                            DropdownMenuItem(
                              value: 'katch',
                              child: Text('Katch-McArdle'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _formula = value;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Age, Height, Weight inputs
                    _buildInputField(
                      label: 'Age',
                      controller: _ageController,
                      suffix: 'years',
                      hintText: 'Enter age',
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: 'Height',
                      controller: _heightController,
                      suffix: 'cm',
                      hintText: 'Enter height',
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: 'Weight',
                      controller: _weightController,
                      suffix: 'kg',
                      hintText: 'Enter weight',
                    ),
                    const SizedBox(height: 16),
                    
                    // Activity level selection
                    const Text(
                      'Activity Level',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _activityLevel,
                          items: [
                            DropdownMenuItem(
                              value: 'sedentary',
                              child: Text('Sedentary: ${_activityDescriptions['sedentary']}'),
                            ),
                            DropdownMenuItem(
                              value: 'light',
                              child: Text('Light: ${_activityDescriptions['light']}'),
                            ),
                            DropdownMenuItem(
                              value: 'moderate',
                              child: Text('Moderate: ${_activityDescriptions['moderate']}'),
                            ),
                            DropdownMenuItem(
                              value: 'active',
                              child: Text('Active: ${_activityDescriptions['active']}'),
                            ),
                            DropdownMenuItem(
                              value: 'veryActive',
                              child: Text('Very Active: ${_activityDescriptions['veryActive']}'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _activityLevel = value;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Calculate button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _calculateTDEE,
                        child: const Text('Calculate TDEE'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              
              // Results section
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _tdee != null
                      ? Column(
                          children: [
                            // TDEE Value
                            Column(
                              children: [
                                Text(
                                  '${_tdee!.toInt()}',
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'calories/day',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            // BMR Value
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.blue.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Basal Metabolic Rate (BMR):',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${_bmr!.toInt()} calories/day',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Calorie goals
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Daily Calorie Goals',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildCalorieGoal(
                                  label: 'Weight Loss',
                                  calories: (_tdee! * 0.8).toInt(),
                                  description: 'Calorie deficit of 20%',
                                  color: Colors.blue,
                                ),
                                const SizedBox(height: 12),
                                _buildCalorieGoal(
                                  label: 'Maintenance',
                                  calories: _tdee!.toInt(),
                                  description: 'Maintain current weight',
                                  color: Colors.green,
                                ),
                                const SizedBox(height: 12),
                                _buildCalorieGoal(
                                  label: 'Weight Gain',
                                  calories: (_tdee! * 1.1).toInt(),
                                  description: 'Calorie surplus of 10%',
                                  color: Colors.orange,
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            
                            // TDEE Explanation
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'What is TDEE?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Total Daily Energy Expenditure (TDEE) is the total number of calories you burn each day. It includes your BMR plus additional calories burned through physical activity and digestion. Your TDEE is the number of calories you need to maintain your current weight.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Enter your details to calculate your Total Daily Energy Expenditure (TDEE)',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'TDEE is the total number of calories you burn each day. It includes your BMR plus additional calories burned through physical activity and digestion.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieGoal({
    required String label,
    required int calories,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$calories cal',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String suffix,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hintText,
            suffixText: suffix,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
