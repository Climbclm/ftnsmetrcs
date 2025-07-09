import 'package:flutter/material.dart';

class IdealWeightCalculator extends StatefulWidget {
  const IdealWeightCalculator({super.key});

  @override
  State<IdealWeightCalculator> createState() => _IdealWeightCalculatorState();
}

class _IdealWeightCalculatorState extends State<IdealWeightCalculator> {
  final _heightController = TextEditingController();
  String _gender = 'male';
  String _formula = 'devine';
  Map<String, double>? _idealWeights;

  @override
  void dispose() {
    _heightController.dispose();
    super.dispose();
  }

  void _calculateIdealWeight() {
    if (_heightController.text.isEmpty) {
      return;
    }

    final height = double.tryParse(_heightController.text);

    if (height == null) {
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

    Map<String, double> idealWeights = {};
    
    // Convert height from cm to inches for formulas
    final heightInInches = height / 2.54;
    
    // Calculate ideal weight based on different formulas
    // Devine Formula
    if (_gender == 'male') {
      idealWeights['devine'] = 50 + 2.3 * (heightInInches - 60);
    } else {
      idealWeights['devine'] = 45.5 + 2.3 * (heightInInches - 60);
    }
    
    // Robinson Formula
    if (_gender == 'male') {
      idealWeights['robinson'] = 52 + 1.9 * (heightInInches - 60);
    } else {
      idealWeights['robinson'] = 49 + 1.7 * (heightInInches - 60);
    }
    
    // Miller Formula
    if (_gender == 'male') {
      idealWeights['miller'] = 56.2 + 1.41 * (heightInInches - 60);
    } else {
      idealWeights['miller'] = 53.1 + 1.36 * (heightInInches - 60);
    }
    
    // Hamwi Formula
    if (_gender == 'male') {
      idealWeights['hamwi'] = 48 + 2.7 * (heightInInches - 60);
    } else {
      idealWeights['hamwi'] = 45.5 + 2.2 * (heightInInches - 60);
    }
    
    // BMI-based Formula (using BMI of 22 as ideal)
    final heightInMeters = height / 100;
    idealWeights['bmi'] = 22 * heightInMeters * heightInMeters;
    
    setState(() {
      _idealWeights = idealWeights;
    });
  }

  String _getFormulaName(String key) {
    switch (key) {
      case 'devine':
        return 'Devine';
      case 'robinson':
        return 'Robinson';
      case 'miller':
        return 'Miller';
      case 'hamwi':
        return 'Hamwi';
      case 'bmi':
        return 'BMI-based';
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ideal Weight Calculator',
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
                      'Preferred Formula',
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
                              value: 'devine',
                              child: Text('Devine Formula'),
                            ),
                            DropdownMenuItem(
                              value: 'robinson',
                              child: Text('Robinson Formula'),
                            ),
                            DropdownMenuItem(
                              value: 'miller',
                              child: Text('Miller Formula'),
                            ),
                            DropdownMenuItem(
                              value: 'hamwi',
                              child: Text('Hamwi Formula'),
                            ),
                            DropdownMenuItem(
                              value: 'bmi',
                              child: Text('BMI-based Formula'),
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
                    
                    // Height input
                    _buildInputField(
                      label: 'Height',
                      controller: _heightController,
                      suffix: 'cm',
                      hintText: 'Enter height',
                    ),
                    const SizedBox(height: 24),
                    
                    // Calculate button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _calculateIdealWeight,
                        child: const Text('Calculate Ideal Weight'),
                      ),
                    ),
                    
                    // Formula explanation
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'About Ideal Weight Formulas',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Different formulas may give different results as they were developed at different times and for different populations. The ideal weight range is just a reference and should be considered alongside other health metrics.',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
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
                  child: _idealWeights != null
                      ? Column(
                          children: [
                            // Ideal Weight Value
                            Column(
                              children: [
                                Text(
                                  '${_idealWeights![_formula]!.toStringAsFixed(1)} kg',
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Your Ideal Weight (${_getFormulaName(_formula)})',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            
                            // Weight range
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
                                    'Healthy Weight Range',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${(_idealWeights![_formula]! * 0.9).toStringAsFixed(1)} - ${(_idealWeights![_formula]! * 1.1).toStringAsFixed(1)} kg',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'A healthy weight range is typically within 10% of your ideal weight.',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Comparison table
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Comparison of Formulas',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Table(
                                  border: TableBorder.all(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                  children: [
                                    const TableRow(
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                      ),
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Formula',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Ideal Weight (kg)',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ..._idealWeights!.entries.map((entry) {
                                      return TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              _getFormulaName(entry.key),
                                              style: TextStyle(
                                                fontWeight: entry.key == _formula
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                                color: entry.key == _formula
                                                    ? Colors.green
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              entry.value.toStringAsFixed(1),
                                              style: TextStyle(
                                                fontWeight: entry.key == _formula
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                                color: entry.key == _formula
                                                    ? Colors.green
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            // Note about ideal weight
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.amber.withOpacity(0.3),
                                ),
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Important Note',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Ideal weight calculations are just estimates and don\'t account for factors like muscle mass, body composition, or individual health conditions. Consult with a healthcare professional for personalized advice.',
                                    style: TextStyle(
                                      fontSize: 14,
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
                              'Enter your height to calculate your ideal weight',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'Ideal weight ranges are based on height, gender, and frame size, providing a target weight range for optimal health.',
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
