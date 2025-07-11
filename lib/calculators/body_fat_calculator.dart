import 'package:flutter/material.dart';
import 'dart:math' as math;

class BodyFatCalculator extends StatefulWidget {
  const BodyFatCalculator({super.key});

  @override
  State<BodyFatCalculator> createState() => _BodyFatCalculatorState();
}

class _BodyFatCalculatorState extends State<BodyFatCalculator> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _waistController = TextEditingController();
  final _neckController = TextEditingController();
  final _hipController = TextEditingController();
  String _gender = 'male';
  String _method = 'navy';
  double? _bodyFatPercentage;

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _waistController.dispose();
    _neckController.dispose();
    _hipController.dispose();
    super.dispose();
  }

  void _calculateBodyFat() {
    if (_method == 'navy') {
      if (_heightController.text.isEmpty ||
          _waistController.text.isEmpty ||
          _neckController.text.isEmpty ||
          (_gender == 'female' && _hipController.text.isEmpty)) {
        return;
      }

      final height = double.tryParse(_heightController.text);
      final waist = double.tryParse(_waistController.text);
      final neck = double.tryParse(_neckController.text);
      final hip = _gender == 'female' ? double.tryParse(_hipController.text) : 0;

      if (height == null || waist == null || neck == null || (_gender == 'female' && hip == null)) {
        return;
      }

      double bodyFat;
      if (_gender == 'male') {
        // U.S. Navy method for men
        bodyFat = 495 / (1.0324 - 0.19077 * log10(waist - neck) + 0.15456 * log10(height)) - 450;
      } else {
        // U.S. Navy method for women
        bodyFat = 495 / (1.29579 - 0.35004 * log10(waist + hip! - neck) + 0.22100 * log10(height)) - 450;
      }

      setState(() {
        _bodyFatPercentage = double.parse(bodyFat.toStringAsFixed(1));
      });
    } else if (_method == 'bmi') {
      if (_heightController.text.isEmpty || _weightController.text.isEmpty) {
        return;
      }

      final height = double.tryParse(_heightController.text);
      final weight = double.tryParse(_weightController.text);

      if (height == null || weight == null) {
        return;
      }

      // Calculate BMI
      final heightInMeters = height / 100;
      final bmi = weight / (heightInMeters * heightInMeters);

      // Estimate body fat from BMI (Deurenberg formula)
      double bodyFat;
      if (_gender == 'male') {
        bodyFat = (1.20 * bmi) + (0.23 * 30) - 16.2; // Assuming age 30
      } else {
        bodyFat = (1.20 * bmi) + (0.23 * 30) - 5.4; // Assuming age 30
      }

      setState(() {
        _bodyFatPercentage = double.parse(bodyFat.toStringAsFixed(1));
      });
    }
  }

  Map<String, dynamic> _getBodyFatCategory(double bodyFat) {
    if (_gender == 'male') {
      if (bodyFat < 2) return {
        'category': 'Not Possible',
        'color': Colors.grey,
        'description': 'Body fat percentage below 2% is not possible for survival.'
      };
      if (bodyFat < 6) return {
        'category': 'Essential Fat',
        'color': Colors.blue,
        'description': 'Essential fat necessary for basic physiological functions.'
      };
      if (bodyFat < 14) return {
        'category': 'Athletic',
        'color': Colors.green,
        'description': 'Very low body fat, typically seen in elite athletes.'
      };
      if (bodyFat < 18) return {
        'category': 'Fitness',
        'color': Colors.green,
        'description': 'Lean and fit, common among regular exercisers.'
      };
      if (bodyFat < 25) return {
        'category': 'Average',
        'color': Colors.amber,
        'description': 'Common range for many men, some excess fat.'
      };
      return {
        'category': 'Obese',
        'color': Colors.red,
        'description': 'Excess body fat that may pose health risks.'
      };
    } else {
      if (bodyFat < 10) return {
        'category': 'Not Possible',
        'color': Colors.grey,
        'description': 'Body fat percentage below 10% is extremely rare in women and may be unhealthy.'
      };
      if (bodyFat < 14) return {
        'category': 'Essential Fat',
        'color': Colors.blue,
        'description': 'Essential fat necessary for basic physiological functions.'
      };
      if (bodyFat < 21) return {
        'category': 'Athletic',
        'color': Colors.green,
        'description': 'Very low body fat, typically seen in elite female athletes.'
      };
      if (bodyFat < 25) return {
        'category': 'Fitness',
        'color': Colors.green,
        'description': 'Lean and fit, common among women who exercise regularly.'
      };
      if (bodyFat < 32) return {
        'category': 'Average',
        'color': Colors.amber,
        'description': 'Common range for many women, some excess fat.'
      };
      return {
        'category': 'Obese',
        'color': Colors.red,
        'description': 'Excess body fat that may pose health risks.'
      };
    }
  }

  // Helper function for logarithm base 10
  double log10(double x) {
    return log(x) / log(10);
  }

  // Natural logarithm function
  double log(double x) {
    return math.log(x);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Body Fat Calculator',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 768;
              
              return isMobile ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Input section
                  _buildInputSection(),
                  const SizedBox(height: 24),
                  // Results section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _buildResultsContent(),
                  ),
                ],
              ) : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Input section
                  Expanded(child: _buildInputSection()),
                  const SizedBox(width: 24),
                  // Results section
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: _buildResultsContent(),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Column(
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
        
        // Method selection
        const Text(
          'Method',
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
              value: _method,
              items: const [
                DropdownMenuItem(
                  value: 'navy',
                  child: Text('Navy Method'),
                ),
                DropdownMenuItem(
                  value: 'bmi',
                  child: Text('BMI Method'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _method = value;
                  });
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Height input
        _buildInputField(
          label: 'Height',
          controller: _heightController,
          suffix: 'cm',
          hintText: 'Enter height',
        ),
        const SizedBox(height: 16),
        
        // Conditional inputs based on method
        if (_method == 'navy') ...[
          _buildInputField(
            label: 'Neck Circumference',
            controller: _neckController,
            suffix: 'cm',
            hintText: 'Enter neck measurement',
          ),
          const SizedBox(height: 16),
          _buildInputField(
            label: 'Waist Circumference',
            controller: _waistController,
            suffix: 'cm',
            hintText: 'Enter waist measurement',
          ),
          if (_gender == 'female') ...[
            const SizedBox(height: 16),
            _buildInputField(
              label: 'Hip Circumference',
              controller: _hipController,
              suffix: 'cm',
              hintText: 'Enter hip measurement',
            ),
          ],
        ] else if (_method == 'bmi') ...[
          _buildInputField(
            label: 'Weight',
            controller: _weightController,
            suffix: 'kg',
            hintText: 'Enter weight',
          ),
        ],
        
        const SizedBox(height: 24),
        
        // Calculate button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _calculateBodyFat,
            child: const Text('Calculate Body Fat'),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsContent() {
    return _bodyFatPercentage != null
        ? Column(
            children: [
              // Body Fat Value
              Column(
                children: [
                  Text(
                    '$_bodyFatPercentage%',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Body Fat Percentage',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Body Fat Category
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getBodyFatCategory(_bodyFatPercentage!)['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getBodyFatCategory(_bodyFatPercentage!)['color'].withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getBodyFatCategory(_bodyFatPercentage!)['category'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _getBodyFatCategory(_bodyFatPercentage!)['color'],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getBodyFatCategory(_bodyFatPercentage!)['description'],
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Method explanation
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _method == 'navy' 
                          ? 'About Navy Method'
                          : 'About BMI Method',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _method == 'navy'
                          ? 'The U.S. Navy method uses circumference measurements to estimate body fat percentage. It\'s generally accurate within 3-4% of body fat for most people.'
                          : 'The BMI method provides a rough estimate based on height and weight. It\'s less accurate than methods that use circumference measurements.',
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
                'Enter your measurements to calculate your body fat percentage',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 24),
              Text(
                'Body fat percentage is the amount of body fat as a proportion of your body weight. It\'s a more accurate measure of fitness than weight alone.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ],
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
                    
                    // Method selection
                    const Text(
                      'Method',
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
                          value: _method,
                          items: const [
                            DropdownMenuItem(
                              value: 'navy',
                              child: Text('Navy Method'),
                            ),
                            DropdownMenuItem(
                              value: 'bmi',
                              child: Text('BMI Method'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _method = value;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Height input
                    _buildInputField(
                      label: 'Height',
                      controller: _heightController,
                      suffix: 'cm',
                      hintText: 'Enter height',
                    ),
                    const SizedBox(height: 16),
                    
                    // Conditional inputs based on method
                    if (_method == 'navy') ...[
                      _buildInputField(
                        label: 'Neck Circumference',
                        controller: _neckController,
                        suffix: 'cm',
                        hintText: 'Enter neck measurement',
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(
                        label: 'Waist Circumference',
                        controller: _waistController,
                        suffix: 'cm',
                        hintText: 'Enter waist measurement',
                      ),
                      if (_gender == 'female') ...[
                        const SizedBox(height: 16),
                        _buildInputField(
                          label: 'Hip Circumference',
                          controller: _hipController,
                          suffix: 'cm',
                          hintText: 'Enter hip measurement',
                        ),
                      ],
                    ] else if (_method == 'bmi') ...[
                      _buildInputField(
                        label: 'Weight',
                        controller: _weightController,
                        suffix: 'kg',
                        hintText: 'Enter weight',
                      ),
                    ],
                    
                    const SizedBox(height: 24),
                    
                    // Calculate button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _calculateBodyFat,
                        child: const Text('Calculate Body Fat'),
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
                  child: _bodyFatPercentage != null
                      ? Column(
                          children: [
                            // Body Fat Value
                            Column(
                              children: [
                                Text(
                                  '$_bodyFatPercentage%',
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Body Fat Percentage',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            
                            // Body Fat Category
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _getBodyFatCategory(_bodyFatPercentage!)['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _getBodyFatCategory(_bodyFatPercentage!)['color'].withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getBodyFatCategory(_bodyFatPercentage!)['category'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: _getBodyFatCategory(_bodyFatPercentage!)['color'],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _getBodyFatCategory(_bodyFatPercentage!)['description'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Method explanation
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.blue.withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _method == 'navy' 
                                        ? 'About Navy Method'
                                        : 'About BMI Method',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _method == 'navy'
                                        ? 'The U.S. Navy method uses circumference measurements to estimate body fat percentage. It\'s generally accurate within 3-4% of body fat for most people.'
                                        : 'The BMI method provides a rough estimate based on height and weight. It\'s less accurate than methods that use circumference measurements.',
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
                              'Enter your measurements to calculate your body fat percentage',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'Body fat percentage is the amount of body fat as a proportion of your body weight. It\'s a more accurate measure of fitness than weight alone.',
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
