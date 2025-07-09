import 'package:flutter/material.dart';

class MaxHeartRateCalculator extends StatefulWidget {
  const MaxHeartRateCalculator({super.key});

  @override
  State<MaxHeartRateCalculator> createState() => _MaxHeartRateCalculatorState();
}

class _MaxHeartRateCalculatorState extends State<MaxHeartRateCalculator> {
  final _ageController = TextEditingController();
  String _formula = 'fox';
  int? _maxHR;
  Map<String, int>? _heartRateZones;

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  void _calculateMaxHR() {
    if (_ageController.text.isEmpty) {
      return;
    }

    final age = int.tryParse(_ageController.text);

    if (age == null) {
      return;
    }

    // Validate input ranges
    if (age < 10 || age > 120) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a valid age between 10 and 120 years')),
      );
      return;
    }

    int maxHR;
    
    // Calculate Max HR based on selected formula
    switch (_formula) {
      case 'fox':
        // Fox formula: 220 - age
        maxHR = 220 - age;
        break;
      case 'tanaka':
        // Tanaka formula: 208 - (0.7 * age)
        maxHR = 208 - (0.7 * age).round();
        break;
      case 'gellish':
        // Gellish formula: 207 - (0.7 * age)
        maxHR = 207 - (0.7 * age).round();
        break;
      case 'nes':
        // Nes formula: 211 - (0.64 * age)
        maxHR = 211 - (0.64 * age).round();
        break;
      default:
        maxHR = 220 - age;
    }
    
    // Calculate heart rate zones
    Map<String, int> heartRateZones = {
      'zone1': (maxHR * 0.5).round(), // 50-60% of MHR - Very Light
      'zone2': (maxHR * 0.6).round(), // 60-70% of MHR - Light
      'zone3': (maxHR * 0.7).round(), // 70-80% of MHR - Moderate
      'zone4': (maxHR * 0.8).round(), // 80-90% of MHR - Hard
      'zone5': (maxHR * 0.9).round(), // 90-100% of MHR - Maximum
    };
    
    setState(() {
      _maxHR = maxHR;
      _heartRateZones = heartRateZones;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Max Heart Rate Calculator',
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
                    // Age input
                    _buildInputField(
                      label: 'Age',
                      controller: _ageController,
                      suffix: 'years',
                      hintText: 'Enter age',
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
                              value: 'fox',
                              child: Text('Fox (220 - age)'),
                            ),
                            DropdownMenuItem(
                              value: 'tanaka',
                              child: Text('Tanaka (208 - 0.7 × age)'),
                            ),
                            DropdownMenuItem(
                              value: 'gellish',
                              child: Text('Gellish (207 - 0.7 × age)'),
                            ),
                            DropdownMenuItem(
                              value: 'nes',
                              child: Text('Nes (211 - 0.64 × age)'),
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
                        onPressed: _calculateMaxHR,
                        child: const Text('Calculate Max Heart Rate'),
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
                            'About the Formulas',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '• Fox: The traditional formula (220 - age). Simple but may overestimate MHR for older adults.\n'
                            '• Tanaka: More accurate for adults over 40 (208 - 0.7 × age).\n'
                            '• Gellish: Based on a large study (207 - 0.7 × age).\n'
                            '• Nes: Recent research-based formula (211 - 0.64 × age).',
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
                  child: _maxHR != null
                      ? Column(
                          children: [
                            // Max HR Value
                            Column(
                              children: [
                                Text(
                                  '$_maxHR',
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                const Text(
                                  'beats per minute (bpm)',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            
                            // Heart Rate Zones
                            const Text(
                              'Heart Rate Training Zones',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Zone 1
                            _buildHeartRateZone(
                              zoneName: 'Zone 1 - Very Light',
                              zoneRange: '50-60%',
                              bpmRange: '${_heartRateZones!['zone1']}-${(_heartRateZones!['zone2'] ?? 0) - 1} bpm',
                              description: 'Warm up, recovery, improves overall health',
                              color: Colors.blue.shade300,
                            ),
                            const SizedBox(height: 12),
                            
                            // Zone 2
                            _buildHeartRateZone(
                              zoneName: 'Zone 2 - Light',
                              zoneRange: '60-70%',
                              bpmRange: '${_heartRateZones!['zone2']}-${(_heartRateZones!['zone3'] ?? 0) - 1} bpm',
                              description: 'Improves basic endurance and fat burning',
                              color: Colors.green.shade300,
                            ),
                            const SizedBox(height: 12),
                            
                            // Zone 3
                            _buildHeartRateZone(
                              zoneName: 'Zone 3 - Moderate',
                              zoneRange: '70-80%',
                              bpmRange: '${_heartRateZones!['zone3']}-${(_heartRateZones!['zone4'] ?? 0) - 1} bpm',
                              description: 'Improves aerobic fitness and endurance',
                              color: Colors.amber.shade300,
                            ),
                            const SizedBox(height: 12),
                            
                            // Zone 4
                            _buildHeartRateZone(
                              zoneName: 'Zone 4 - Hard',
                              zoneRange: '80-90%',
                              bpmRange: '${_heartRateZones!['zone4']}-${(_heartRateZones!['zone5'] ?? 0) - 1} bpm',
                              description: 'Increases maximum performance capacity',
                              color: Colors.orange.shade300,
                            ),
                            const SizedBox(height: 12),
                            
                            // Zone 5
                            _buildHeartRateZone(
                              zoneName: 'Zone 5 - Maximum',
                              zoneRange: '90-100%',
                              bpmRange: '${_heartRateZones!['zone5']}-$_maxHR bpm',
                              description: 'Develops maximum performance and speed',
                              color: Colors.red.shade300,
                            ),
                            const SizedBox(height: 24),
                            
                            // Heart rate zones visualization
                            Container(
                              height: 24,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade300,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomLeft: Radius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      color: Colors.green.shade300,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      color: Colors.amber.shade300,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      color: Colors.orange.shade300,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade300,
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '50%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  '60%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  '70%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  '80%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  '90%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  '100%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            
                            // Max HR explanation
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'What is Maximum Heart Rate?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Maximum Heart Rate (MHR) is the highest number of times your heart can beat in one minute during intense exercise. It\'s primarily determined by age and genetics. Training at different percentages of your MHR helps target specific fitness goals.',
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
                              'Enter your age to calculate your Maximum Heart Rate',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'Maximum Heart Rate (MHR) is the highest number of times your heart can beat in one minute during intense exercise. Knowing your MHR helps you optimize your workouts by training in specific heart rate zones.',
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

  Widget _buildHeartRateZone({
    required String zoneName,
    required String zoneRange,
    required String bpmRange,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color,
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
                  zoneName,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                bpmRange,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                zoneRange,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
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
