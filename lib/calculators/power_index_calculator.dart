import 'package:flutter/material.dart';
import 'dart:math' as math;

class PowerIndexCalculator extends StatefulWidget {
  const PowerIndexCalculator({super.key});

  @override
  State<PowerIndexCalculator> createState() => _PowerIndexCalculatorState();
}

class _PowerIndexCalculatorState extends State<PowerIndexCalculator> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _verticalJumpController = TextEditingController();
  String _units = 'metric';
  double? _powerIndex;
  String? _powerCategory;

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _verticalJumpController.dispose();
    super.dispose();
  }

  void _calculatePowerIndex() {
    if (_weightController.text.isEmpty || 
        _heightController.text.isEmpty || 
        _verticalJumpController.text.isEmpty) {
      return;
    }

    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);
    final verticalJump = double.tryParse(_verticalJumpController.text);

    if (weight == null || height == null || verticalJump == null) {
      return;
    }

    // Convert to metric if needed
    double weightKg = weight;
    double heightCm = height;
    double jumpCm = verticalJump;
    
    if (_units == 'imperial') {
      // Convert pounds to kg
      weightKg = weight * 0.453592;
      
      // Convert feet/inches to cm
      heightCm = height * 2.54;
      
      // Convert inches to cm
      jumpCm = verticalJump * 2.54;
    }

    // Validate input ranges
    if (weightKg < 20 || weightKg > 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a valid weight between 20-200 kg (44-440 lbs)')),
      );
      return;
    }
    if (heightCm < 100 || heightCm > 250) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a valid height between 100-250 cm (39-98 inches)')),
      );
      return;
    }
    if (jumpCm < 10 || jumpCm > 150) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a valid vertical jump between 10-150 cm (4-59 inches)')),
      );
      return;
    }

    // Calculate power index
    // Formula: (Jump Height in cm × Body Weight in kg) / (Height in cm)
    final powerIndexValue = (jumpCm * weightKg) / heightCm;
    
    // Determine power category
    String category;
    if (powerIndexValue < 1.0) {
      category = 'Below Average';
    } else if (powerIndexValue < 2.0) {
      category = 'Average';
    } else if (powerIndexValue < 3.0) {
      category = 'Good';
    } else if (powerIndexValue < 4.0) {
      category = 'Very Good';
    } else {
      category = 'Excellent';
    }
    
    setState(() {
      _powerIndex = double.parse(powerIndexValue.toStringAsFixed(2));
      _powerCategory = category;
    });
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Below Average':
        return Colors.red;
      case 'Average':
        return Colors.amber;
      case 'Good':
        return Colors.green;
      case 'Very Good':
        return Colors.blue;
      case 'Excellent':
        return Colors.purple;
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
            'Power Index Calculator',
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
                                _units = 'metric';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _units == 'metric'
                                    ? Colors.blue
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _units == 'metric'
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Metric (kg/cm)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _units == 'metric'
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
                                _units = 'imperial';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _units == 'imperial'
                                    ? Colors.blue
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _units == 'imperial'
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Imperial (lb/in)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _units == 'imperial'
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
                    
                    // Weight input
                    _buildInputField(
                      label: 'Body Weight',
                      controller: _weightController,
                      suffix: _units == 'metric' ? 'kg' : 'lb',
                      hintText: 'Enter body weight',
                    ),
                    const SizedBox(height: 16),
                    
                    // Height input
                    _buildInputField(
                      label: 'Height',
                      controller: _heightController,
                      suffix: _units == 'metric' ? 'cm' : 'in',
                      hintText: _units == 'metric' 
                          ? 'Enter height in cm' 
                          : 'Enter height in inches',
                    ),
                    const SizedBox(height: 16),
                    
                    // Vertical jump input
                    _buildInputField(
                      label: 'Vertical Jump',
                      controller: _verticalJumpController,
                      suffix: _units == 'metric' ? 'cm' : 'in',
                      hintText: 'Enter vertical jump',
                    ),
                    const SizedBox(height: 24),
                    
                    // Calculate button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _calculatePowerIndex,
                        child: const Text('Calculate Power Index'),
                      ),
                    ),
                    
                    // Measurement guide
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
                            'How to Measure Vertical Jump',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '1. Stand next to a wall with your arm extended upward\n'
                            '2. Mark the highest point you can reach while standing flat-footed\n'
                            '3. Jump as high as you can and mark the highest point\n'
                            '4. Measure the distance between the two marks',
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
                  child: _powerIndex != null
                      ? Column(
                          children: [
                            // Power Index Value
                            Column(
                              children: [
                                Text(
                                  _powerIndex.toString(),
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: _getCategoryColor(_powerCategory!),
                                  ),
                                ),
                                const Text(
                                  'Power Index',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            // Power Category
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _getCategoryColor(_powerCategory!).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _getCategoryColor(_powerCategory!).withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Category: $_powerCategory',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: _getCategoryColor(_powerCategory!),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _getCategoryDescription(_powerCategory!),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Power categories table
                            const Text(
                              'Power Index Categories',
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
                                        'Power Index Range',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                _buildCategoryRow('Below Average', '< 1.0'),
                                _buildCategoryRow('Average', '1.0 - 1.9'),
                                _buildCategoryRow('Good', '2.0 - 2.9'),
                                _buildCategoryRow('Very Good', '3.0 - 3.9'),
                                _buildCategoryRow('Excellent', '≥ 4.0'),
                              ],
                            ),
                            const SizedBox(height: 24),
                            
                            // Power index explanation
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
                                    'What is Power Index?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'The Power Index is a measure of explosive power relative to body size. It takes into account your vertical jump, body weight, and height to provide a standardized score that can be compared across different individuals. A higher power index indicates better explosive power.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Sports relevance
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
                                    'Sports Relevance',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Explosive power is crucial for sports like basketball, volleyball, football, track and field (especially jumping events), and Olympic weightlifting. Improving your power index can enhance performance in these sports.',
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
                              'Enter your details to calculate your Power Index',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'The Power Index measures explosive power output relative to body weight, useful for sports requiring quick, powerful movements.',
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

  TableRow _buildCategoryRow(String category, String range) {
    final isCurrentCategory = _powerCategory != null && category == _powerCategory;
    
    final color = isCurrentCategory 
                ? _getCategoryColor(category)
                : Colors.black;
    
    final weight = isCurrentCategory 
                 ? FontWeight.bold
                 : FontWeight.normal;
    
    return TableRow(
      decoration: BoxDecoration(
        color: isCurrentCategory 
            ? _getCategoryColor(category).withOpacity(0.1)
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
            range,
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
      case 'Below Average':
        return 'Your explosive power is below average. Focus on plyometric exercises and strength training to improve.';
      case 'Average':
        return 'Your explosive power is average. Continue with a balanced training program to further develop your power.';
      case 'Good':
        return 'Your explosive power is good. You have a solid foundation for sports requiring explosive movements.';
      case 'Very Good':
        return 'Your explosive power is very good. You likely excel in activities requiring jumping and quick movements.';
      case 'Excellent':
        return 'Your explosive power is excellent. You have elite-level power output relative to your body size.';
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
