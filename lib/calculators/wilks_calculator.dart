import 'package:flutter/material.dart';

class WilksCalculator extends StatefulWidget {
  const WilksCalculator({super.key});

  @override
  State<WilksCalculator> createState() => _WilksCalculatorState();
}

class _WilksCalculatorState extends State<WilksCalculator> {
  final _bodyweightController = TextEditingController();
  final _squatController = TextEditingController();
  final _benchController = TextEditingController();
  final _deadliftController = TextEditingController();
  String _gender = 'male';
  String _units = 'kg';
  double? _wilksScore;
  double? _totalWeight;

  // Wilks coefficient constants
  final List<double> _maleCoefficients = [
    -216.0475144,
    16.2606339,
    -0.002388645,
    -0.00113732,
    7.01863E-06,
    -1.291E-08
  ];
  final List<double> _femaleCoefficients = [
    594.31747775582,
    -27.23842536447,
    0.82112226871,
    -0.00930733913,
    4.731582E-05,
    -9.054E-08
  ];

  @override
  void dispose() {
    _bodyweightController.dispose();
    _squatController.dispose();
    _benchController.dispose();
    _deadliftController.dispose();
    super.dispose();
  }

  void _calculateWilks() {
    if (_bodyweightController.text.isEmpty) {
      return;
    }

    final bodyweight = double.tryParse(_bodyweightController.text);
    if (bodyweight == null) {
      return;
    }

    // Validate bodyweight
    if (bodyweight < 20 || bodyweight > 300) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a valid bodyweight between 20kg and 300kg')),
      );
      return;
    }

    // Get lift values
    double squat = double.tryParse(_squatController.text) ?? 0;
    double bench = double.tryParse(_benchController.text) ?? 0;
    double deadlift = double.tryParse(_deadliftController.text) ?? 0;

    // Convert to kg if needed
    if (_units == 'lb') {
      squat = squat / 2.20462;
      bench = bench / 2.20462;
      deadlift = deadlift / 2.20462;
    }

    // Calculate total
    final total = squat + bench + deadlift;

    // Calculate Wilks coefficient
    double coefficient = 0;
    final List<double> coefficients = _gender == 'male' ? _maleCoefficients : _femaleCoefficients;
    
    double x = bodyweight;
    coefficient = 500 / (coefficients[0] + 
                         coefficients[1] * x + 
                         coefficients[2] * x * x + 
                         coefficients[3] * x * x * x + 
                         coefficients[4] * x * x * x * x + 
                         coefficients[5] * x * x * x * x * x);
    
    // Calculate Wilks score
    final wilksScore = total * coefficient;
    
    setState(() {
      _wilksScore = double.parse(wilksScore.toStringAsFixed(2));
      _totalWeight = double.parse(total.toStringAsFixed(1));
    });
  }

  String _getWilksCategory(double score) {
    if (_gender == 'male') {
      if (score < 200) return 'Beginner';
      if (score < 300) return 'Novice';
      if (score < 400) return 'Intermediate';
      if (score < 500) return 'Advanced';
      return 'Elite';
    } else {
      if (score < 150) return 'Beginner';
      if (score < 250) return 'Novice';
      if (score < 350) return 'Intermediate';
      if (score < 450) return 'Advanced';
      return 'Elite';
    }
  }

  Color _getWilksCategoryColor(String category) {
    switch (category) {
      case 'Beginner':
        return Colors.blue;
      case 'Novice':
        return Colors.green;
      case 'Intermediate':
        return Colors.amber;
      case 'Advanced':
        return Colors.orange;
      case 'Elite':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Wilks Calculator',
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
                    
                    // Units selection
                    const Text(
                      'Units',
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
                                _units = 'kg';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _units == 'kg'
                                    ? Colors.blue
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _units == 'kg'
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Kilograms (kg)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _units == 'kg'
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
                                _units = 'lb';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _units == 'lb'
                                    ? Colors.blue
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _units == 'lb'
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Pounds (lb)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _units == 'lb'
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
                    
                    // Bodyweight input
                    _buildInputField(
                      label: 'Bodyweight',
                      controller: _bodyweightController,
                      suffix: _units,
                      hintText: 'Enter bodyweight',
                    ),
                    const SizedBox(height: 16),
                    
                    // Lift inputs
                    _buildInputField(
                      label: 'Squat',
                      controller: _squatController,
                      suffix: _units,
                      hintText: 'Enter squat weight',
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: 'Bench Press',
                      controller: _benchController,
                      suffix: _units,
                      hintText: 'Enter bench press weight',
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: 'Deadlift',
                      controller: _deadliftController,
                      suffix: _units,
                      hintText: 'Enter deadlift weight',
                    ),
                    const SizedBox(height: 24),
                    
                    // Calculate button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _calculateWilks,
                        child: const Text('Calculate Wilks Score'),
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
                  child: _wilksScore != null
                      ? Column(
                          children: [
                            // Wilks Score
                            Column(
                              children: [
                                Text(
                                  _wilksScore!.toString(),
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple,
                                  ),
                                ),
                                const Text(
                                  'Wilks Score',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            // Total weight
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
                                    'Total Weight:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '$_totalWeight kg',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Wilks category
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _getWilksCategoryColor(_getWilksCategory(_wilksScore!)).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _getWilksCategoryColor(_getWilksCategory(_wilksScore!)).withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Category: ${_getWilksCategory(_wilksScore!)}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: _getWilksCategoryColor(_getWilksCategory(_wilksScore!)),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _getCategoryDescription(_getWilksCategory(_wilksScore!)),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Wilks categories table
                            const Text(
                              'Wilks Score Categories',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Table(
                              border: TableBorder.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                              children: [
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                  ),
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Category',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Male',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Female',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                _buildCategoryRow('Beginner', '<200', '<150'),
                                _buildCategoryRow('Novice', '200-300', '150-250'),
                                _buildCategoryRow('Intermediate', '300-400', '250-350'),
                                _buildCategoryRow('Advanced', '400-500', '350-450'),
                                _buildCategoryRow('Elite', '>500', '>450'),
                              ],
                            ),
                            const SizedBox(height: 24),
                            
                            // Wilks explanation
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.purple.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.purple.withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'What is the Wilks Score?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'The Wilks Score is a coefficient that can be used to measure the strength of a powerlifter against other powerlifters despite the different weight classes. It takes into account gender and bodyweight to create a comparable score.',
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
                              'Enter your details to calculate your Wilks Score',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'The Wilks Score is a formula that standardizes powerlifting performances across different body weights, allowing comparison between weight classes.',
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

  TableRow _buildCategoryRow(String category, String male, String female) {
    final isCurrentCategory = _wilksScore != null && 
                             category == _getWilksCategory(_wilksScore!);
    
    final color = isCurrentCategory 
                ? _getWilksCategoryColor(category)
                : Colors.black;
    
    final weight = isCurrentCategory 
                 ? FontWeight.bold
                 : FontWeight.normal;
    
    return TableRow(
      decoration: BoxDecoration(
        color: isCurrentCategory 
            ? _getWilksCategoryColor(category).withOpacity(0.1)
            : Colors.white,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            category,
            style: TextStyle(
              color: color,
              fontWeight: weight,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            male,
            style: TextStyle(
              color: color,
              fontWeight: weight,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            female,
            style: TextStyle(
              color: color,
              fontWeight: weight,
            ),
          ),
        ),
      ],
    );
  }

  String _getCategoryDescription(String category) {
    switch (category) {
      case 'Beginner':
        return 'You\'re just starting out in powerlifting. Focus on learning proper form and technique.';
      case 'Novice':
        return 'You\'ve been training consistently for a few months. Continue building strength and refining technique.';
      case 'Intermediate':
        return 'You\'ve been training for 1-2 years and have a solid foundation. Progress will be slower but steady.';
      case 'Advanced':
        return 'You\'re stronger than most gym-goers and approaching competitive levels. Progress requires specialized training.';
      case 'Elite':
        return 'You\'re at a competitive powerlifting level. Your strength is exceptional compared to the general population.';
      default:
        return '';
    }
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
