import 'package:flutter/material.dart';

class BodyFrameCalculator extends StatefulWidget {
  const BodyFrameCalculator({super.key});

  @override
  State<BodyFrameCalculator> createState() => _BodyFrameCalculatorState();
}

class _BodyFrameCalculatorState extends State<BodyFrameCalculator> {
  final _heightController = TextEditingController();
  final _wristController = TextEditingController();
  String _gender = 'male';
  String _frameSize = '';
  String _method = 'wrist';

  @override
  void dispose() {
    _heightController.dispose();
    _wristController.dispose();
    super.dispose();
  }

  void _calculateFrameSize() {
    if (_heightController.text.isEmpty || _wristController.text.isEmpty) {
      return;
    }

    final height = double.tryParse(_heightController.text);
    final wrist = double.tryParse(_wristController.text);

    if (height == null || wrist == null) {
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
    if (wrist < 10 || wrist > 25) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a valid wrist measurement between 10cm and 25cm')),
      );
      return;
    }

    String frameSize;
    
    // Calculate frame size based on gender and method
    if (_method == 'wrist') {
      if (_gender == 'male') {
        if (wrist < 17) {
          frameSize = 'Small';
        } else if (wrist <= 19) {
          frameSize = 'Medium';
        } else {
          frameSize = 'Large';
        }
      } else {
        if (wrist < 15) {
          frameSize = 'Small';
        } else if (wrist <= 17) {
          frameSize = 'Medium';
        } else {
          frameSize = 'Large';
        }
      }
    } else {
      // Height-to-wrist ratio method
      final ratio = height / wrist;
      
      if (_gender == 'male') {
        if (ratio > 10.4) {
          frameSize = 'Small';
        } else if (ratio >= 9.6) {
          frameSize = 'Medium';
        } else {
          frameSize = 'Large';
        }
      } else {
        if (ratio > 11.0) {
          frameSize = 'Small';
        } else if (ratio >= 10.1) {
          frameSize = 'Medium';
        } else {
          frameSize = 'Large';
        }
      }
    }
    
    setState(() {
      _frameSize = frameSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Body Frame Calculator',
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
                    
                    // Method selection
                    const Text(
                      'Method',
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
                                _method = 'wrist';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _method == 'wrist'
                                    ? Colors.green
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _method == 'wrist'
                                      ? Colors.green
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Wrist Size',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _method == 'wrist'
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
                                _method = 'ratio';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _method == 'ratio'
                                    ? Colors.green
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _method == 'ratio'
                                      ? Colors.green
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Height/Wrist Ratio',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _method == 'ratio'
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
                    
                    // Measurement inputs
                    _buildInputField(
                      label: 'Height',
                      controller: _heightController,
                      suffix: 'cm',
                      hintText: 'Enter height',
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: 'Wrist Circumference',
                      controller: _wristController,
                      suffix: 'cm',
                      hintText: 'Enter wrist measurement',
                    ),
                    const SizedBox(height: 24),
                    
                    // Calculate button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _calculateFrameSize,
                        child: const Text('Calculate Frame Size'),
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
                            'How to Measure Your Wrist',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Use a measuring tape to measure the circumference of your wrist just below the wrist bone. Make sure the tape is snug but not tight.',
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
                  child: _frameSize.isNotEmpty
                      ? Column(
                          children: [
                            // Frame Size Result
                            Column(
                              children: [
                                Text(
                                  _frameSize,
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: _frameSize == 'Small'
                                        ? Colors.blue
                                        : _frameSize == 'Medium'
                                            ? Colors.green
                                            : Colors.orange,
                                  ),
                                ),
                                const Text(
                                  'Frame Size',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            
                            // Frame Size Explanation
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _frameSize == 'Small'
                                    ? Colors.blue.shade50
                                    : _frameSize == 'Medium'
                                        ? Colors.green.shade50
                                        : Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: (_frameSize == 'Small'
                                          ? Colors.blue
                                          : _frameSize == 'Medium'
                                              ? Colors.green
                                              : Colors.orange)
                                      .withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'What does $_frameSize Frame Mean?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: _frameSize == 'Small'
                                          ? Colors.blue
                                          : _frameSize == 'Medium'
                                              ? Colors.green
                                              : Colors.orange,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _frameSize == 'Small'
                                        ? 'You have a small frame, which means your bones are relatively small compared to your height. People with small frames typically have a more delicate bone structure.'
                                        : _frameSize == 'Medium'
                                            ? 'You have a medium frame, which is the most common frame size. Your bone structure is average relative to your height.'
                                            : 'You have a large frame, which means your bones are relatively large compared to your height. People with large frames typically have a more robust bone structure.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Method Explanation
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'About ${_method == 'wrist' ? 'Wrist Size' : 'Height/Wrist Ratio'} Method',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _method == 'wrist'
                                        ? 'This method uses your wrist circumference to determine your frame size. It\'s a simple approach that works well for most people.'
                                        : 'This method calculates the ratio of your height to your wrist circumference. It provides a more personalized assessment by accounting for your height.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Frame Size Table
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Frame Size Reference',
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
                                            'Frame Size',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Male Wrist',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Female Wrist',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Small',
                                            style: TextStyle(
                                              fontWeight: _frameSize == 'Small'
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              color: _frameSize == 'Small'
                                                  ? Colors.blue
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('< 17 cm'),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('< 15 cm'),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Medium',
                                            style: TextStyle(
                                              fontWeight: _frameSize == 'Medium'
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              color: _frameSize == 'Medium'
                                                  ? Colors.green
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('17-19 cm'),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('15-17 cm'),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Large',
                                            style: TextStyle(
                                              fontWeight: _frameSize == 'Large'
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              color: _frameSize == 'Large'
                                                  ? Colors.orange
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('> 19 cm'),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('> 17 cm'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Enter your measurements to determine your body frame size',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'Body frame size is determined by your bone structure and can help determine your ideal weight range and guide fitness plans.',
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
