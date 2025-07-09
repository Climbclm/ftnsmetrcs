import 'package:flutter/material.dart';

class MacroCalculator extends StatefulWidget {
  const MacroCalculator({super.key});

  @override
  State<MacroCalculator> createState() => _MacroCalculatorState();
}

class _MacroCalculatorState extends State<MacroCalculator> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();
  String _gender = 'male';
  String _activityLevel = 'moderate';
  String _goal = 'maintain';
  String _macroRatio = 'balanced';
  
  double? _calories;
  Map<String, double>? _macros;

  final Map<String, double> _activityMultipliers = {
    'sedentary': 1.2,
    'light': 1.375,
    'moderate': 1.55,
    'active': 1.725,
    'veryActive': 1.9,
  };

  final Map<String, Map<String, double>> _macroRatios = {
    'balanced': {'protein': 0.3, 'carbs': 0.4, 'fat': 0.3},
    'lowCarb': {'protein': 0.4, 'carbs': 0.2, 'fat': 0.4},
    'highProtein': {'protein': 0.4, 'carbs': 0.3, 'fat': 0.3},
    'ketogenic': {'protein': 0.25, 'carbs': 0.05, 'fat': 0.7},
    'highCarb': {'protein': 0.25, 'carbs': 0.55, 'fat': 0.2},
  };

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _calculateMacros() {
    if (_weightController.text.isEmpty || 
        _heightController.text.isEmpty || 
        _ageController.text.isEmpty) {
      return;
    }

    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);
    final age = int.tryParse(_ageController.text);

    if (weight == null || height == null || age == null) {
      return;
    }

    // Calculate BMR using Mifflin-St Jeor Equation
    double bmr;
    if (_gender == 'male') {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }

    // Calculate TDEE
    double tdee = bmr * _activityMultipliers[_activityLevel]!;

    // Adjust calories based on goal
    double calories;
    switch (_goal) {
      case 'lose':
        calories = tdee * 0.8; // 20% deficit
        break;
      case 'maintain':
        calories = tdee;
        break;
      case 'gain':
        calories = tdee * 1.1; // 10% surplus
        break;
      default:
        calories = tdee;
    }

    // Calculate macros based on selected ratio
    final ratio = _macroRatios[_macroRatio]!;
    
    final protein = (calories * ratio['protein']! / 4).round(); // 4 calories per gram
    final carbs = (calories * ratio['carbs']! / 4).round(); // 4 calories per gram
    final fat = (calories * ratio['fat']! / 9).round(); // 9 calories per gram

    setState(() {
      _calories = calories;
      _macros = {
        'protein': protein.toDouble(),
        'carbs': carbs.toDouble(),
        'fat': fat.toDouble(),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Macro Calculator',
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
                    
                    // Basic inputs
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
                          items: const [
                            DropdownMenuItem(
                              value: 'sedentary',
                              child: Text('Sedentary (little or no exercise)'),
                            ),
                            DropdownMenuItem(
                              value: 'light',
                              child: Text('Light (exercise 1-3 days/week)'),
                            ),
                            DropdownMenuItem(
                              value: 'moderate',
                              child: Text('Moderate (exercise 3-5 days/week)'),
                            ),
                            DropdownMenuItem(
                              value: 'active',
                              child: Text('Active (exercise 6-7 days/week)'),
                            ),
                            DropdownMenuItem(
                              value: 'veryActive',
                              child: Text('Very Active (intense exercise daily)'),
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
                    const SizedBox(height: 16),
                    
                    // Goal selection
                    const Text(
                      'Goal',
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
                                _goal = 'lose';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _goal == 'lose'
                                    ? Colors.blue
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _goal == 'lose'
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Lose',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _goal == 'lose'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _goal = 'maintain';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _goal == 'maintain'
                                    ? Colors.green
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _goal == 'maintain'
                                      ? Colors.green
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Maintain',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _goal == 'maintain'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _goal = 'gain';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _goal == 'gain'
                                    ? Colors.orange
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _goal == 'gain'
                                      ? Colors.orange
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Gain',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _goal == 'gain'
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
                    
                    // Macro ratio selection
                    const Text(
                      'Macro Ratio',
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
                          value: _macroRatio,
                          items: const [
                            DropdownMenuItem(
                              value: 'balanced',
                              child: Text('Balanced (30P/40C/30F)'),
                            ),
                            DropdownMenuItem(
                              value: 'lowCarb',
                              child: Text('Low Carb (40P/20C/40F)'),
                            ),
                            DropdownMenuItem(
                              value: 'highProtein',
                              child: Text('High Protein (40P/30C/30F)'),
                            ),
                            DropdownMenuItem(
                              value: 'ketogenic',
                              child: Text('Ketogenic (25P/5C/70F)'),
                            ),
                            DropdownMenuItem(
                              value: 'highCarb',
                              child: Text('High Carb (25P/55C/20F)'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _macroRatio = value;
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
                        onPressed: _calculateMacros,
                        child: const Text('Calculate Macros'),
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
                  child: _macros != null
                      ? Column(
                          children: [
                            // Calorie Value
                            Column(
                              children: [
                                Text(
                                  '${_calories!.toInt()}',
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
                            const SizedBox(height: 24),
                            
                            // Macro breakdown
                            const Text(
                              'Daily Macro Nutrients',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Protein
                            _buildMacroItem(
                              label: 'Protein',
                              value: _macros!['protein']!.toInt(),
                              percentage: _macroRatios[_macroRatio]!['protein']! * 100,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 12),
                            
                            // Carbs
                            _buildMacroItem(
                              label: 'Carbohydrates',
                              value: _macros!['carbs']!.toInt(),
                              percentage: _macroRatios[_macroRatio]!['carbs']! * 100,
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 12),
                            
                            // Fat
                            _buildMacroItem(
                              label: 'Fat',
                              value: _macros!['fat']!.toInt(),
                              percentage: _macroRatios[_macroRatio]!['fat']! * 100,
                              color: Colors.amber,
                            ),
                            const SizedBox(height: 24),
                            
                            // Macro distribution chart
                            Container(
                              height: 24,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: (_macroRatios[_macroRatio]!['protein']! * 100).toInt(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(12),
                                          bottomLeft: const Radius.circular(12),
                                          topRight: _macroRatios[_macroRatio]!['carbs']! == 0 && _macroRatios[_macroRatio]!['fat']! == 0
                                              ? const Radius.circular(12)
                                              : Radius.zero,
                                          bottomRight: _macroRatios[_macroRatio]!['carbs']! == 0 && _macroRatios[_macroRatio]!['fat']! == 0
                                              ? const Radius.circular(12)
                                              : Radius.zero,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: (_macroRatios[_macroRatio]!['carbs']! * 100).toInt(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.only(
                                          topLeft: _macroRatios[_macroRatio]!['protein']! == 0
                                              ? const Radius.circular(12)
                                              : Radius.zero,
                                          bottomLeft: _macroRatios[_macroRatio]!['protein']! == 0
                                              ? const Radius.circular(12)
                                              : Radius.zero,
                                          topRight: _macroRatios[_macroRatio]!['fat']! == 0
                                              ? const Radius.circular(12)
                                              : Radius.zero,
                                          bottomRight: _macroRatios[_macroRatio]!['fat']! == 0
                                              ? const Radius.circular(12)
                                              : Radius.zero,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: (_macroRatios[_macroRatio]!['fat']! * 100).toInt(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius: BorderRadius.only(
                                          topLeft: _macroRatios[_macroRatio]!['protein']! == 0 && _macroRatios[_macroRatio]!['carbs']! == 0
                                              ? const Radius.circular(12)
                                              : Radius.zero,
                                          bottomLeft: _macroRatios[_macroRatio]!['protein']! == 0 && _macroRatios[_macroRatio]!['carbs']! == 0
                                              ? const Radius.circular(12)
                                              : Radius.zero,
                                          topRight: const Radius.circular(12),
                                          bottomRight: const Radius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildLegendItem('Protein', Colors.red),
                                const SizedBox(width: 16),
                                _buildLegendItem('Carbs', Colors.blue),
                                const SizedBox(width: 16),
                                _buildLegendItem('Fat', Colors.amber),
                              ],
                            ),
                            const SizedBox(height: 24),
                            
                            // Macros explanation
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
                                    'About Macronutrients',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Macronutrients are the nutrients your body needs in large amounts: protein, carbohydrates, and fats. Each macro serves different functions in your body and provides different amounts of energy (calories).',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '• Protein: 4 calories per gram - Essential for muscle growth and repair\n• Carbs: 4 calories per gram - Primary energy source for your body\n• Fat: 9 calories per gram - Important for hormone production and nutrient absorption',
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
                              'Enter your details to calculate your daily macronutrient needs',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'Macronutrients (proteins, carbs, and fats) are essential nutrients that provide energy and support bodily functions. The right balance can help you achieve your fitness and health goals.',
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

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMacroItem({
    required String label,
    required int value,
    required double percentage,
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
                  '${percentage.toInt()}% of total calories',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$value g',
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
