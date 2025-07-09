import 'package:flutter/material.dart';

class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key});

  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  double? _bmi;

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _calculateBMI() {
    if (_heightController.text.isEmpty || _weightController.text.isEmpty) {
      return;
    }

    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);

    if (height == null || weight == null) {
      return;
    }

    // Validate input ranges
    if (height < 50 || height > 250) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid height between 50cm and 250cm')),
      );
      return;
    }
    if (weight < 20 || weight > 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid weight between 20kg and 500kg')),
      );
      return;
    }

    // WHO standard BMI formula
    final heightInMeters = height / 100;
    final bmiValue = weight / (heightInMeters * heightInMeters);
    
    setState(() {
      _bmi = double.parse(bmiValue.toStringAsFixed(1));
    });
  }

  Map<String, dynamic> _getBMICategory(double bmi) {
    // WHO BMI Classification
    if (bmi < 16) {
      return {
        'category': 'Severe Underweight',
        'color': Colors.red,
        'bgColor': Colors.red.shade50,
        'description': 'Urgent medical attention may be required. Please consult a healthcare provider.',
        'range': '< 16'
      };
    }
    if (bmi < 17) {
      return {
        'category': 'Moderate Underweight',
        'color': Colors.orange,
        'bgColor': Colors.orange.shade50,
        'description': 'Medical evaluation recommended. Focus on nutrient-rich foods and consult a healthcare provider.',
        'range': '16 - 16.9'
      };
    }
    if (bmi < 18.5) {
      return {
        'category': 'Mild Underweight',
        'color': Colors.amber,
        'bgColor': Colors.amber.shade50,
        'description': 'Consider increasing caloric intake with healthy foods. Consult a nutritionist if needed.',
        'range': '17 - 18.4'
      };
    }
    if (bmi < 25) {
      return {
        'category': 'Normal Weight',
        'color': Colors.green,
        'bgColor': Colors.green.shade50,
        'description': 'You are at a healthy weight. Maintain it with balanced nutrition and regular exercise.',
        'range': '18.5 - 24.9'
      };
    }
    if (bmi < 30) {
      return {
        'category': 'Pre-obesity',
        'color': Colors.amber,
        'bgColor': Colors.amber.shade50,
        'description': 'Consider lifestyle modifications through balanced diet and increased physical activity.',
        'range': '25.0 - 29.9'
      };
    }
    if (bmi < 35) {
      return {
        'category': 'Obesity Class I',
        'color': Colors.orange,
        'bgColor': Colors.orange.shade50,
        'description': 'Medical evaluation recommended. Consider a structured weight management program.',
        'range': '30.0 - 34.9'
      };
    }
    if (bmi < 40) {
      return {
        'category': 'Obesity Class II',
        'color': Colors.red,
        'bgColor': Colors.red.shade50,
        'description': 'Medical intervention advised. Consult healthcare providers for a comprehensive weight management plan.',
        'range': '35.0 - 39.9'
      };
    }
    return {
      'category': 'Obesity Class III',
      'color': Colors.red.shade900,
      'bgColor': Colors.red.shade50,
      'description': 'Immediate medical attention recommended. Seek professional healthcare guidance for specialized treatment.',
      'range': '≥ 40'
    };
  }

  final List<Map<String, dynamic>> _bmiCategories = [
    {'range': '< 18.5', 'category': 'Underweight', 'color': Colors.amber},
    {'range': '18.5 - 24.9', 'category': 'Normal', 'color': Colors.green},
    {'range': '25.0 - 29.9', 'category': 'Overweight', 'color': Colors.orange},
    {'range': '≥ 30', 'category': 'Obese', 'color': Colors.red}
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'BMI Calculator',
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
                  children: [
                    _buildInputField(
                      label: 'Height (cm)',
                      controller: _heightController,
                      suffix: 'cm',
                      hintText: 'Enter height',
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: 'Weight (kg)',
                      controller: _weightController,
                      suffix: 'kg',
                      hintText: 'Enter weight',
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _calculateBMI,
                        child: const Text('Calculate BMI'),
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
                  child: _bmi != null
                      ? Column(
                          children: [
                            // BMI Value
                            Column(
                              children: [
                                Text(
                                  _bmi!.toString(),
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Your BMI',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // BMI Category
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _getBMICategory(_bmi!)['bgColor'],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _getBMICategory(_bmi!)['color'].withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getBMICategory(_bmi!)['category'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: _getBMICategory(_bmi!)['color'],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _getBMICategory(_bmi!)['description'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            // BMI Scale
                            Column(
                              children: [
                                // Color bar
                                Container(
                                  height: 16,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: _bmiCategories
                                        .map(
                                          (category) => Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: category['color'],
                                                borderRadius: BorderRadius.horizontal(
                                                  left: _bmiCategories.first == category
                                                      ? const Radius.circular(8)
                                                      : Radius.zero,
                                                  right: _bmiCategories.last == category
                                                      ? const Radius.circular(8)
                                                      : Radius.zero,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Category labels
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: _bmiCategories
                                      .map(
                                        (category) => Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                category['category'],
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                category['range'],
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Enter your height and weight to calculate your BMI',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 24),
                            // BMI Scale
                            Column(
                              children: [
                                // Color bar
                                Container(
                                  height: 16,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: _bmiCategories
                                        .map(
                                          (category) => Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: category['color'],
                                                borderRadius: BorderRadius.horizontal(
                                                  left: _bmiCategories.first == category
                                                      ? const Radius.circular(8)
                                                      : Radius.zero,
                                                  right: _bmiCategories.last == category
                                                      ? const Radius.circular(8)
                                                      : Radius.zero,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Category labels
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: _bmiCategories
                                      .map(
                                        (category) => Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                category['category'],
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                category['range'],
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
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
