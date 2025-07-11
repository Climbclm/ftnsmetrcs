import 'package:flutter/material.dart';

class LeanBodyMassCalculator extends StatefulWidget {
  const LeanBodyMassCalculator({super.key});

  @override
  State<LeanBodyMassCalculator> createState() => _LeanBodyMassCalculatorState();
}

class _LeanBodyMassCalculatorState extends State<LeanBodyMassCalculator> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _bodyFatController = TextEditingController();
  String _gender = 'male';
  String _formula = 'boer';
  double? _lbm;
  bool _useBodyFat = false;

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _bodyFatController.dispose();
    super.dispose();
  }

  void _calculateLBM() {
    if (_useBodyFat) {
      if (_weightController.text.isEmpty || _bodyFatController.text.isEmpty) {
        return;
      }

      final weight = double.tryParse(_weightController.text);
      final bodyFat = double.tryParse(_bodyFatController.text);

      if (weight == null || bodyFat == null) {
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
      if (bodyFat < 1 || bodyFat > 70) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please enter a valid body fat percentage between 1% and 70%')),
        );
        return;
      }

      // Calculate LBM using body fat percentage
      final lbmValue = weight * (1 - (bodyFat / 100));
      
      setState(() {
        _lbm = double.parse(lbmValue.toStringAsFixed(1));
      });
    } else {
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
          const SnackBar(
              content: Text('Please enter a valid height between 50cm and 250cm')),
        );
        return;
      }
      if (weight < 20 || weight > 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please enter a valid weight between 20kg and 500kg')),
        );
        return;
      }

      double lbmValue = 0;

      // Calculate LBM based on selected formula
      switch (_formula) {
        case 'boer':
          // Boer Formula
          if (_gender == 'male') {
            lbmValue = (0.407 * weight) + (0.267 * height) - 19.2;
          } else {
            lbmValue = (0.252 * weight) + (0.473 * height) - 48.3;
          }
          break;
        case 'james':
          // James Formula
          if (_gender == 'male') {
            lbmValue = (1.1 * weight) - (128 * (weight / height) * (weight / height));
          } else {
            lbmValue = (1.07 * weight) - (148 * (weight / height) * (weight / height));
          }
          break;
        case 'hume':
          // Hume Formula
          if (_gender == 'male') {
            lbmValue = (0.32810 * weight) + (0.33929 * height) - 29.5336;
          } else {
            lbmValue = (0.29569 * weight) + (0.41813 * height) - 43.2933;
          }
          break;
      }
      
      setState(() {
        _lbm = double.parse(lbmValue.toStringAsFixed(1));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lean Body Mass Calculator',
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
        // Method selection
        const Text(
          'Calculation Method',
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
                    _useBodyFat = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: !_useBodyFat
                        ? Colors.green
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: !_useBodyFat
                          ? Colors.green
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Formula',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: !_useBodyFat
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
                    _useBodyFat = true;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _useBodyFat
                        ? Colors.green
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _useBodyFat
                          ? Colors.green
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Body Fat %',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _useBodyFat
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
        
        if (!_useBodyFat) ...[
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
                    value: 'boer',
                    child: Text('Boer Formula'),
                  ),
                  DropdownMenuItem(
                    value: 'james',
                    child: Text('James Formula'),
                  ),
                  DropdownMenuItem(
                    value: 'hume',
                    child: Text('Hume Formula'),
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
          
          // Height and weight inputs
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
        ] else ...[
          // Weight and body fat inputs
          _buildInputField(
            label: 'Weight',
            controller: _weightController,
            suffix: 'kg',
            hintText: 'Enter weight',
          ),
          const SizedBox(height: 16),
          _buildInputField(
            label: 'Body Fat Percentage',
            controller: _bodyFatController,
            suffix: '%',
            hintText: 'Enter body fat percentage',
          ),
        ],
        
        const SizedBox(height: 24),
        
        // Calculate button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _calculateLBM,
            child: const Text('Calculate Lean Body Mass'),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsContent() {
    return _lbm != null
        ? Column(
            children: [
              // LBM Value
              Column(
                children: [
                  Text(
                    '$_lbm kg',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Your Lean Body Mass',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Body composition
              if (_useBodyFat) ...[
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildCompositionItem(
                            label: 'Lean Mass',
                            value: '$_lbm kg',
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildCompositionItem(
                            label: 'Fat Mass',
                            value: '${double.parse(_weightController.text) - _lbm!} kg',
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: _lbm!.round(),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(12),
                                  bottomLeft: const Radius.circular(12),
                                  topRight: _lbm! >= double.parse(_weightController.text) * 0.95
                                      ? const Radius.circular(12)
                                      : Radius.zero,
                                  bottomRight: _lbm! >= double.parse(_weightController.text) * 0.95
                                      ? const Radius.circular(12)
                                      : Radius.zero,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: (double.parse(_weightController.text) - _lbm!).round(),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.only(
                                  topRight: const Radius.circular(12),
                                  bottomRight: const Radius.circular(12),
                                  topLeft: _lbm! <= double.parse(_weightController.text) * 0.05
                                      ? const Radius.circular(12)
                                      : Radius.zero,
                                  bottomLeft: _lbm! <= double.parse(_weightController.text) * 0.05
                                      ? const Radius.circular(12)
                                      : Radius.zero,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
              
              const SizedBox(height: 24),
              
              // LBM Explanation
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
                      'What is Lean Body Mass?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lean Body Mass (LBM) is the weight of your body excluding fat. It includes the weight of your muscles, bones, organs, and body water. LBM is an important metric for determining caloric needs and tracking fitness progress.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Formula explanation
              if (!_useBodyFat)
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
                      Text(
                        'About $_formula Formula',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formula == 'boer'
                            ? 'The Boer formula is one of the most widely used formulas for estimating lean body mass. It uses height and weight and is adjusted for gender.'
                            : _formula == 'james'
                                ? 'The James formula estimates lean body mass using weight and height. It accounts for the relationship between body mass index and body fat percentage.'
                                : 'The Hume formula is another approach to estimating lean body mass using height and weight measurements, with different coefficients for men and women.',
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
                'Enter your details to calculate your Lean Body Mass',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 24),
              Text(
                'Lean Body Mass (LBM) is the weight of your body excluding fat. It includes muscles, bones, organs, and body water. It\'s an important metric for determining caloric needs and tracking fitness progress.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ],
          );
  }

  Widget _buildCompositionItem({
    required String label,
    required String value,
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
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Method selection
                    const Text(
                      'Calculation Method',
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
                                _useBodyFat = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: !_useBodyFat
                                    ? Colors.green
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: !_useBodyFat
                                      ? Colors.green
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Formula',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: !_useBodyFat
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
                                _useBodyFat = true;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _useBodyFat
                                    ? Colors.green
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _useBodyFat
                                      ? Colors.green
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Body Fat %',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _useBodyFat
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
                    
                    if (!_useBodyFat) ...[
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
                                value: 'boer',
                                child: Text('Boer Formula'),
                              ),
                              DropdownMenuItem(
                                value: 'james',
                                child: Text('James Formula'),
                              ),
                              DropdownMenuItem(
                                value: 'hume',
                                child: Text('Hume Formula'),
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
                      
                      // Height and weight inputs
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
                    ] else ...[
                      // Weight and body fat inputs
                      _buildInputField(
                        label: 'Weight',
                        controller: _weightController,
                        suffix: 'kg',
                        hintText: 'Enter weight',
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(
                        label: 'Body Fat Percentage',
                        controller: _bodyFatController,
                        suffix: '%',
                        hintText: 'Enter body fat percentage',
                      ),
                    ],
                    
                    const SizedBox(height: 24),
                    
                    // Calculate button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _calculateLBM,
                        child: const Text('Calculate Lean Body Mass'),
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
                  child: _lbm != null
                      ? Column(
                          children: [
                            // LBM Value
                            Column(
                              children: [
                                Text(
                                  '$_lbm kg',
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Your Lean Body Mass',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            
                            // Body composition
                            if (_useBodyFat) ...[
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildCompositionItem(
                                          label: 'Lean Mass',
                                          value: '$_lbm kg',
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: _buildCompositionItem(
                                          label: 'Fat Mass',
                                          value: '${double.parse(_weightController.text) - _lbm!} kg',
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    height: 24,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey.shade300),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: _lbm!.round(),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.only(
                                                topLeft: const Radius.circular(12),
                                                bottomLeft: const Radius.circular(12),
                                                topRight: _lbm! >= double.parse(_weightController.text) * 0.95
                                                    ? const Radius.circular(12)
                                                    : Radius.zero,
                                                bottomRight: _lbm! >= double.parse(_weightController.text) * 0.95
                                                    ? const Radius.circular(12)
                                                    : Radius.zero,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: (double.parse(_weightController.text) - _lbm!).round(),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius: BorderRadius.only(
                                                topRight: const Radius.circular(12),
                                                bottomRight: const Radius.circular(12),
                                                topLeft: _lbm! <= double.parse(_weightController.text) * 0.05
                                                    ? const Radius.circular(12)
                                                    : Radius.zero,
                                                bottomLeft: _lbm! <= double.parse(_weightController.text) * 0.05
                                                    ? const Radius.circular(12)
                                                    : Radius.zero,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            
                            const SizedBox(height: 24),
                            
                            // LBM Explanation
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
                                    'What is Lean Body Mass?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Lean Body Mass (LBM) is the weight of your body excluding fat. It includes the weight of your muscles, bones, organs, and body water. LBM is an important metric for determining caloric needs and tracking fitness progress.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Formula explanation
                            if (!_useBodyFat)
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
                                    Text(
                                      'About $_formula Formula',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _formula == 'boer'
                                          ? 'The Boer formula is one of the most widely used formulas for estimating lean body mass. It uses height and weight and is adjusted for gender.'
                                          : _formula == 'james'
                                              ? 'The James formula estimates lean body mass using weight and height. It accounts for the relationship between body mass index and body fat percentage.'
                                              : 'The Hume formula is another approach to estimating lean body mass using height and weight measurements, with different coefficients for men and women.',
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
                              'Enter your details to calculate your Lean Body Mass',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'Lean Body Mass (LBM) is the weight of your body excluding fat. It includes muscles, bones, organs, and body water. It\'s an important metric for determining caloric needs and tracking fitness progress.',
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

  Widget _buildCompositionItem({
    required String label,
    required String value,
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
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
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
