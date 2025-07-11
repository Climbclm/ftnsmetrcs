import 'package:flutter/material.dart';

class WaistHipRatioCalculator extends StatefulWidget {
  const WaistHipRatioCalculator({super.key});

  @override
  State<WaistHipRatioCalculator> createState() => _WaistHipRatioCalculatorState();
}

class _WaistHipRatioCalculatorState extends State<WaistHipRatioCalculator> {
  final _waistController = TextEditingController();
  final _hipController = TextEditingController();
  String _gender = 'male';
  double? _whr;

  @override
  void dispose() {
    _waistController.dispose();
    _hipController.dispose();
    super.dispose();
  }

  void _calculateWHR() {
    if (_waistController.text.isEmpty || _hipController.text.isEmpty) {
      return;
    }

    final waist = double.tryParse(_waistController.text);
    final hip = double.tryParse(_hipController.text);

    if (waist == null || hip == null) {
      return;
    }

    // Validate input ranges
    if (waist < 40 || waist > 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a valid waist measurement between 40cm and 200cm')),
      );
      return;
    }
    if (hip < 40 || hip > 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a valid hip measurement between 40cm and 200cm')),
      );
      return;
    }

    final whrValue = waist / hip;
    
    setState(() {
      _whr = double.parse(whrValue.toStringAsFixed(2));
    });
  }

  Map<String, dynamic> _getWHRCategory(double whr) {
    if (_gender == 'male') {
      if (whr <= 0.85) return {
        'category': 'Low Risk',
        'color': Colors.green,
        'description': 'Your WHR indicates a lower risk for cardiovascular health issues.',
      };
      if (whr <= 0.90) return {
        'category': 'Moderate Risk',
        'color': Colors.amber,
        'description': 'Your WHR indicates a moderate risk for cardiovascular health issues.',
      };
      if (whr <= 0.95) return {
        'category': 'High Risk',
        'color': Colors.orange,
        'description': 'Your WHR indicates a high risk for cardiovascular health issues.',
      };
      return {
        'category': 'Very High Risk',
        'color': Colors.red,
        'description': 'Your WHR indicates a very high risk for cardiovascular health issues.',
      };
    } else {
      if (whr <= 0.75) return {
        'category': 'Low Risk',
        'color': Colors.green,
        'description': 'Your WHR indicates a lower risk for cardiovascular health issues.',
      };
      if (whr <= 0.80) return {
        'category': 'Moderate Risk',
        'color': Colors.amber,
        'description': 'Your WHR indicates a moderate risk for cardiovascular health issues.',
      };
      if (whr <= 0.85) return {
        'category': 'High Risk',
        'color': Colors.orange,
        'description': 'Your WHR indicates a high risk for cardiovascular health issues.',
      };
      return {
        'category': 'Very High Risk',
        'color': Colors.red,
        'description': 'Your WHR indicates a very high risk for cardiovascular health issues.',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Waist-Hip Ratio Calculator',
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
        
        // Measurement inputs
        _buildInputField(
          label: 'Waist Circumference',
          controller: _waistController,
          suffix: 'cm',
          hintText: 'Enter waist measurement',
        ),
        const SizedBox(height: 16),
        _buildInputField(
          label: 'Hip Circumference',
          controller: _hipController,
          suffix: 'cm',
          hintText: 'Enter hip measurement',
        ),
        const SizedBox(height: 24),
        
        // Calculate button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _calculateWHR,
            child: const Text('Calculate WHR'),
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
                'How to Measure',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Waist: Measure at the narrowest part of your waist, usually just above your belly button.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 4),
              const Text(
                'Hip: Measure at the widest part of your buttocks or hips.',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultsContent() {
    return _whr != null
        ? Column(
            children: [
              // WHR Value
              Column(
                children: [
                  Text(
                    _whr.toString(),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Your Waist-Hip Ratio',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // WHR Category
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getWHRCategory(_whr!)['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getWHRCategory(_whr!)['color'].withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getWHRCategory(_whr!)['category'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _getWHRCategory(_whr!)['color'],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getWHRCategory(_whr!)['description'],
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // WHR Explanation
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
                      'What is WHR?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Waist-to-hip ratio (WHR) is a measurement of the distribution of body fat. It measures the ratio of your waist circumference to your hip circumference. WHR is a simple way to assess your risk for developing obesity-related diseases.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Risk table
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'WHR Health Risk Categories',
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
                              'Risk',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Male',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Female',
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
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Low'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '≤ 0.85',
                              style: TextStyle(
                                color: _gender == 'male' && _whr! <= 0.85
                                    ? Colors.green
                                    : Colors.black,
                                fontWeight: _gender == 'male' && _whr! <= 0.85
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '≤ 0.75',
                              style: TextStyle(
                                color: _gender == 'female' && _whr! <= 0.75
                                    ? Colors.green
                                    : Colors.black,
                                fontWeight: _gender == 'female' && _whr! <= 0.75
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Moderate'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '0.86 - 0.90',
                              style: TextStyle(
                                color: _gender == 'male' && _whr! > 0.85 && _whr! <= 0.90
                                    ? Colors.amber
                                    : Colors.black,
                                fontWeight: _gender == 'male' && _whr! > 0.85 && _whr! <= 0.90
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '0.76 - 0.80',
                              style: TextStyle(
                                color: _gender == 'female' && _whr! > 0.75 && _whr! <= 0.80
                                    ? Colors.amber
                                    : Colors.black,
                                fontWeight: _gender == 'female' && _whr! > 0.75 && _whr! <= 0.80
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('High'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '0.91 - 0.95',
                              style: TextStyle(
                                color: _gender == 'male' && _whr! > 0.90 && _whr! <= 0.95
                                    ? Colors.orange
                                    : Colors.black,
                                fontWeight: _gender == 'male' && _whr! > 0.90 && _whr! <= 0.95
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '0.81 - 0.85',
                              style: TextStyle(
                                color: _gender == 'female' && _whr! > 0.80 && _whr! <= 0.85
                                    ? Colors.orange
                                    : Colors.black,
                                fontWeight: _gender == 'female' && _whr! > 0.80 && _whr! <= 0.85
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Very High'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '> 0.95',
                              style: TextStyle(
                                color: _gender == 'male' && _whr! > 0.95
                                    ? Colors.red
                                    : Colors.black,
                                fontWeight: _gender == 'male' && _whr! > 0.95
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '> 0.85',
                              style: TextStyle(
                                color: _gender == 'female' && _whr! > 0.85
                                    ? Colors.red
                                    : Colors.black,
                                fontWeight: _gender == 'female' && _whr! > 0.85
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
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
                'Enter your waist and hip measurements to calculate your Waist-Hip Ratio',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 24),
              Text(
                'Waist-Hip Ratio (WHR) is a measure of body fat distribution and a predictor of health risk. It can help identify if you\'re carrying too much weight around your abdomen, which is associated with higher health risks.',
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
                    
                    // Measurement inputs
                    _buildInputField(
                      label: 'Waist Circumference',
                      controller: _waistController,
                      suffix: 'cm',
                      hintText: 'Enter waist measurement',
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: 'Hip Circumference',
                      controller: _hipController,
                      suffix: 'cm',
                      hintText: 'Enter hip measurement',
                    ),
                    const SizedBox(height: 24),
                    
                    // Calculate button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _calculateWHR,
                        child: const Text('Calculate WHR'),
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
                            'How to Measure',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Waist: Measure at the narrowest part of your waist, usually just above your belly button.',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Hip: Measure at the widest part of your buttocks or hips.',
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
                  child: _whr != null
                      ? Column(
                          children: [
                            // WHR Value
                            Column(
                              children: [
                                Text(
                                  _whr.toString(),
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Your Waist-Hip Ratio',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            
                            // WHR Category
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _getWHRCategory(_whr!)['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _getWHRCategory(_whr!)['color'].withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getWHRCategory(_whr!)['category'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: _getWHRCategory(_whr!)['color'],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _getWHRCategory(_whr!)['description'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // WHR Explanation
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
                                    'What is WHR?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Waist-to-hip ratio (WHR) is a measurement of the distribution of body fat. It measures the ratio of your waist circumference to your hip circumference. WHR is a simple way to assess your risk for developing obesity-related diseases.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Risk table
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'WHR Health Risk Categories',
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
                                            'Risk',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Male',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Female',
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
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Low'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '≤ 0.85',
                                            style: TextStyle(
                                              color: _gender == 'male' && _whr! <= 0.85
                                                  ? Colors.green
                                                  : Colors.black,
                                              fontWeight: _gender == 'male' && _whr! <= 0.85
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '≤ 0.75',
                                            style: TextStyle(
                                              color: _gender == 'female' && _whr! <= 0.75
                                                  ? Colors.green
                                                  : Colors.black,
                                              fontWeight: _gender == 'female' && _whr! <= 0.75
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Moderate'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '0.86 - 0.90',
                                            style: TextStyle(
                                              color: _gender == 'male' && _whr! > 0.85 && _whr! <= 0.90
                                                  ? Colors.amber
                                                  : Colors.black,
                                              fontWeight: _gender == 'male' && _whr! > 0.85 && _whr! <= 0.90
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '0.76 - 0.80',
                                            style: TextStyle(
                                              color: _gender == 'female' && _whr! > 0.75 && _whr! <= 0.80
                                                  ? Colors.amber
                                                  : Colors.black,
                                              fontWeight: _gender == 'female' && _whr! > 0.75 && _whr! <= 0.80
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('High'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '0.91 - 0.95',
                                            style: TextStyle(
                                              color: _gender == 'male' && _whr! > 0.90 && _whr! <= 0.95
                                                  ? Colors.orange
                                                  : Colors.black,
                                              fontWeight: _gender == 'male' && _whr! > 0.90 && _whr! <= 0.95
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '0.81 - 0.85',
                                            style: TextStyle(
                                              color: _gender == 'female' && _whr! > 0.80 && _whr! <= 0.85
                                                  ? Colors.orange
                                                  : Colors.black,
                                              fontWeight: _gender == 'female' && _whr! > 0.80 && _whr! <= 0.85
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Very High'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '> 0.95',
                                            style: TextStyle(
                                              color: _gender == 'male' && _whr! > 0.95
                                                  ? Colors.red
                                                  : Colors.black,
                                              fontWeight: _gender == 'male' && _whr! > 0.95
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '> 0.85',
                                            style: TextStyle(
                                              color: _gender == 'female' && _whr! > 0.85
                                                  ? Colors.red
                                                  : Colors.black,
                                              fontWeight: _gender == 'female' && _whr! > 0.85
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
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
                              'Enter your waist and hip measurements to calculate your Waist-Hip Ratio',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'Waist-Hip Ratio (WHR) is a measure of body fat distribution and a predictor of health risk. It can help identify if you\'re carrying too much weight around your abdomen, which is associated with higher health risks.',
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
