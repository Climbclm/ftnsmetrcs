import 'package:flutter/material.dart';

class WaterIntakeCalculator extends StatefulWidget {
  const WaterIntakeCalculator({super.key});

  @override
  State<WaterIntakeCalculator> createState() => _WaterIntakeCalculatorState();
}

class _WaterIntakeCalculatorState extends State<WaterIntakeCalculator> {
  final _weightController = TextEditingController();
  String _activityLevel = 'moderate';
  String _climate = 'temperate';
  double? _waterIntake;
  double? _waterIntakeOz;
  double? _waterIntakeCups;

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  void _calculateWaterIntake() {
    if (_weightController.text.isEmpty) {
      return;
    }

    final weight = double.tryParse(_weightController.text);

    if (weight == null) {
      return;
    }

    // Validate input ranges
    if (weight < 20 || weight > 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a valid weight between 20kg and 500kg')),
      );
      return;
    }

    // Base calculation: 30ml per kg of body weight
    double waterIntake = weight * 30;
    
    // Adjust for activity level
    switch (_activityLevel) {
      case 'sedentary':
        waterIntake *= 0.8; // 20% less for sedentary
        break;
      case 'light':
        waterIntake *= 0.9; // 10% less for light activity
        break;
      case 'moderate':
        // No adjustment for moderate activity (baseline)
        break;
      case 'active':
        waterIntake *= 1.1; // 10% more for active
        break;
      case 'veryActive':
        waterIntake *= 1.2; // 20% more for very active
        break;
    }
    
    // Adjust for climate
    switch (_climate) {
      case 'cold':
        waterIntake *= 0.9; // 10% less for cold climate
        break;
      case 'temperate':
        // No adjustment for temperate climate (baseline)
        break;
      case 'hot':
        waterIntake *= 1.1; // 10% more for hot climate
        break;
      case 'veryHot':
        waterIntake *= 1.2; // 20% more for very hot climate
        break;
    }
    
    // Convert to liters
    final waterIntakeLiters = waterIntake / 1000;
    
    // Convert to fluid ounces (1 liter = 33.814 fluid ounces)
    final waterIntakeOz = waterIntakeLiters * 33.814;
    
    // Convert to cups (1 cup = 8 fluid ounces)
    final waterIntakeCups = waterIntakeOz / 8;
    
    setState(() {
      _waterIntake = double.parse(waterIntakeLiters.toStringAsFixed(1));
      _waterIntakeOz = double.parse(waterIntakeOz.toStringAsFixed(1));
      _waterIntakeCups = double.parse(waterIntakeCups.toStringAsFixed(1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Water Intake Calculator',
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
                    
                    // Climate selection
                    const Text(
                      'Climate',
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
                          value: _climate,
                          items: const [
                            DropdownMenuItem(
                              value: 'cold',
                              child: Text('Cold Climate'),
                            ),
                            DropdownMenuItem(
                              value: 'temperate',
                              child: Text('Temperate Climate'),
                            ),
                            DropdownMenuItem(
                              value: 'hot',
                              child: Text('Hot Climate'),
                            ),
                            DropdownMenuItem(
                              value: 'veryHot',
                              child: Text('Very Hot Climate'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _climate = value;
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
                        onPressed: _calculateWaterIntake,
                        child: const Text('Calculate Water Intake'),
                      ),
                    ),
                    
                    // Water intake tips
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
                            'Tips for Staying Hydrated',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '• Carry a reusable water bottle with you\n'
                            '• Set reminders to drink water throughout the day\n'
                            '• Drink a glass of water before each meal\n'
                            '• Eat water-rich foods like fruits and vegetables\n'
                            '• Flavor water with fruits if you find plain water boring',
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
                  child: _waterIntake != null
                      ? Column(
                          children: [
                            // Water Intake Value
                            Column(
                              children: [
                                Text(
                                  '$_waterIntake L',
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                const Text(
                                  'Daily Water Intake',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            
                            // Alternative units
                            Row(
                              children: [
                                Expanded(
                                  child: _buildWaterUnitCard(
                                    value: '$_waterIntakeOz',
                                    unit: 'fl oz',
                                    icon: Icons.water_drop_outlined,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildWaterUnitCard(
                                    value: '$_waterIntakeCups',
                                    unit: 'cups',
                                    icon: Icons.local_drink_outlined,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            
                            // Water intake visualization
                            const Text(
                              'Daily Water Intake Goal',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(8, (index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Container(
                                    width: 24,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.blue.shade200),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 24,
                                          height: 100 * (_waterIntakeCups! >= index + 1 ? 1 : 
                                                        _waterIntakeCups! > index && _waterIntakeCups! < index + 1 ? 
                                                        _waterIntakeCups! - index : 0),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade300,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '8 cups = 64 fl oz ≈ 1.9 L',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Water intake explanation
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
                                    'Why is Water Important?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Water is essential for nearly every bodily function. It helps regulate body temperature, lubricates joints, aids digestion, transports nutrients, and removes waste. Proper hydration can improve energy levels, cognitive function, and physical performance.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Signs of dehydration
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
                                    'Signs of Dehydration',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '• Thirst\n• Dark yellow urine\n• Fatigue\n• Headache\n• Dry mouth and lips\n• Dizziness\n• Decreased urination',
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
                              'Enter your weight to calculate your daily water intake needs',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'Proper hydration is essential for health. Your daily water needs depend on various factors including weight, activity level, and climate.',
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

  Widget _buildWaterUnitCard({
    required String value,
    required String unit,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.shade200,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.blue,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
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
