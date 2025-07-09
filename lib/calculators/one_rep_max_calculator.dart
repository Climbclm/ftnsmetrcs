import 'package:flutter/material.dart';

class OneRepMaxCalculator extends StatefulWidget {
  const OneRepMaxCalculator({super.key});

  @override
  State<OneRepMaxCalculator> createState() => _OneRepMaxCalculatorState();
}

class _OneRepMaxCalculatorState extends State<OneRepMaxCalculator> {
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();
  String _formula = 'brzycki';
  double? _oneRepMax;
  Map<int, double>? _repMaxes;

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  void _calculateOneRepMax() {
    if (_weightController.text.isEmpty || _repsController.text.isEmpty) {
      return;
    }

    final weight = double.tryParse(_weightController.text);
    final reps = int.tryParse(_repsController.text);

    if (weight == null || reps == null) {
      return;
    }

    // Validate input ranges
    if (weight <= 0 || weight > 1000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a valid weight between 1 and 1000 kg')),
      );
      return;
    }
    if (reps <= 0 || reps > 30) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a valid number of reps between 1 and 30')),
      );
      return;
    }

    double oneRepMax = 0;
    
    // Calculate 1RM based on selected formula
    switch (_formula) {
      case 'brzycki':
        // Brzycki formula: weight × (36 / (37 - reps))
        oneRepMax = weight * (36 / (37 - reps));
        break;
      case 'epley':
        // Epley formula: weight × (1 + 0.0333 × reps)
        oneRepMax = weight * (1 + 0.0333 * reps);
        break;
      case 'lander':
        // Lander formula: (100 × weight) / (101.3 - 2.67123 × reps)
        oneRepMax = (100 * weight) / (101.3 - 2.67123 * reps);
        break;
      case 'lombardi':
        // Lombardi formula: weight × reps^0.1
        oneRepMax = weight * pow(reps, 0.1);
        break;
      case 'oconner':
        // O'Conner formula: weight × (1 + 0.025 × reps)
        oneRepMax = weight * (1 + 0.025 * reps);
        break;
      default:
        oneRepMax = weight * (36 / (37 - reps));
    }
    
    // Calculate rep maxes for 2-12 reps
    Map<int, double> repMaxes = {};
    for (int i = 1; i <= 12; i++) {
      double repMax = 0;
      
      // Use Brzycki formula to calculate rep maxes
      if (i == 1) {
        repMax = oneRepMax;
      } else {
        repMax = oneRepMax * (37 - i) / 36;
      }
      
      repMaxes[i] = double.parse(repMax.toStringAsFixed(1));
    }
    
    setState(() {
      _oneRepMax = double.parse(oneRepMax.toStringAsFixed(1));
      _repMaxes = repMaxes;
    });
  }

  // Helper function for power
  double pow(num x, num exponent) {
    return x.toDouble() * exponent.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'One Rep Max Calculator',
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
                    // Weight input
                    _buildInputField(
                      label: 'Weight Lifted',
                      controller: _weightController,
                      suffix: 'kg',
                      hintText: 'Enter weight',
                    ),
                    const SizedBox(height: 16),
                    
                    // Reps input
                    _buildInputField(
                      label: 'Repetitions',
                      controller: _repsController,
                      suffix: 'reps',
                      hintText: 'Enter reps',
                    ),
                    const SizedBox(height: 16),
                    
                    // Formula selection
                    const Text(
                      'Formula',
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
                              value: 'brzycki',
                              child: Text('Brzycki'),
                            ),
                            DropdownMenuItem(
                              value: 'epley',
                              child: Text('Epley'),
                            ),
                            DropdownMenuItem(
                              value: 'lander',
                              child: Text('Lander'),
                            ),
                            DropdownMenuItem(
                              value: 'lombardi',
                              child: Text('Lombardi'),
                            ),
                            DropdownMenuItem(
                              value: 'oconner',
                              child: Text('O\'Conner'),
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
                    const SizedBox(height: 24),
                    
                    // Calculate button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _calculateOneRepMax,
                        child: const Text('Calculate 1RM'),
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
                            'About 1RM Formulas',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Different formulas may give slightly different results. The Brzycki formula is most accurate when reps are less than 10. For higher reps, the Epley formula may be more accurate. For best results, perform a set with 2-5 reps at maximum effort.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Safety note
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.amber.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Safety Note',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Attempting a true 1RM can be risky, especially for beginners. Always use proper form, have spotters when necessary, and consider working with a qualified trainer for maximal lifts.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                            ),
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
                  child: _oneRepMax != null
                      ? Column(
                          children: [
                            // 1RM Value
                            Column(
                              children: [
                                Text(
                                  '$_oneRepMax kg',
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                const Text(
                                  'Estimated One Rep Max',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            
                            // Rep max table
                            const Text(
                              'Repetition Max Table',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  // Table header
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Reps',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade800,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            'Weight (kg)',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade800,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            '% of 1RM',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Table rows
                                  ...List.generate(12, (index) {
                                    final reps = index + 1;
                                    final weight = _repMaxes![reps];
                                    final percentage = (weight! / _oneRepMax! * 100).round();
                                    
                                    return Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                        color: reps == 1 ? Colors.green.shade50 : Colors.white,
                                        border: Border(
                                          top: BorderSide(color: Colors.grey.shade300),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              '$reps',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: reps == 1 ? FontWeight.bold : FontWeight.normal,
                                                color: reps == 1 ? Colors.green : Colors.black,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              '${weight.toStringAsFixed(1)}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: reps == 1 ? FontWeight.bold : FontWeight.normal,
                                                color: reps == 1 ? Colors.green : Colors.black,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              '$percentage%',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: reps == 1 ? FontWeight.bold : FontWeight.normal,
                                                color: reps == 1 ? Colors.green : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // 1RM explanation
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
                                    'What is One Rep Max?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'One Rep Max (1RM) is the maximum weight you can lift for a single repetition of a given exercise. It\'s commonly used to measure strength, track progress, and determine appropriate training loads for different rep ranges.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Training recommendations
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
                                  const Text(
                                    'Training Recommendations',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '• Strength: 1-5 reps (85-100% of 1RM)\n'
                                    '• Hypertrophy: 6-12 reps (67-85% of 1RM)\n'
                                    '• Endurance: 12+ reps (below 67% of 1RM)',
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
                              'Enter weight and reps to calculate your One Rep Max',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'One Rep Max (1RM) is the maximum weight you can lift for a single repetition. It helps in planning training programs and tracking strength progress.',
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
