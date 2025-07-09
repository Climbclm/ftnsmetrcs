import 'package:flutter/material.dart';

class RunningPaceCalculator extends StatefulWidget {
  const RunningPaceCalculator({super.key});

  @override
  State<RunningPaceCalculator> createState() => _RunningPaceCalculatorState();
}

class _RunningPaceCalculatorState extends State<RunningPaceCalculator> {
  final _distanceController = TextEditingController();
  final _hoursController = TextEditingController();
  final _minutesController = TextEditingController();
  final _secondsController = TextEditingController();
  final _paceMinutesController = TextEditingController();
  final _paceSecondsController = TextEditingController();
  
  String _distanceUnit = 'km';
  String _paceUnit = 'min/km';
  String _calculationType = 'time'; // 'time', 'pace', or 'distance'
  
  // Results
  String? _resultPace;
  String? _resultTime;
  String? _resultDistance;
  double? _resultSpeedKmh;
  double? _resultSpeedMph;
  
  @override
  void dispose() {
    _distanceController.dispose();
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    _paceMinutesController.dispose();
    _paceSecondsController.dispose();
    super.dispose();
  }

  void _calculate() {
    // Validate inputs based on calculation type
    if (_calculationType == 'time') {
      if (_distanceController.text.isEmpty || 
          (_paceMinutesController.text.isEmpty && _paceSecondsController.text.isEmpty)) {
        _showValidationError('Please enter both distance and pace');
        return;
      }
    } else if (_calculationType == 'pace') {
      if (_distanceController.text.isEmpty || 
          (_hoursController.text.isEmpty && _minutesController.text.isEmpty && _secondsController.text.isEmpty)) {
        _showValidationError('Please enter both distance and time');
        return;
      }
    } else if (_calculationType == 'distance') {
      if ((_hoursController.text.isEmpty && _minutesController.text.isEmpty && _secondsController.text.isEmpty) || 
          (_paceMinutesController.text.isEmpty && _paceSecondsController.text.isEmpty)) {
        _showValidationError('Please enter both time and pace');
        return;
      }
    }

    // Parse values
    double? distance = double.tryParse(_distanceController.text);
    int hours = int.tryParse(_hoursController.text) ?? 0;
    int minutes = int.tryParse(_minutesController.text) ?? 0;
    int seconds = int.tryParse(_secondsController.text) ?? 0;
    int paceMinutes = int.tryParse(_paceMinutesController.text) ?? 0;
    int paceSeconds = int.tryParse(_paceSecondsController.text) ?? 0;

    // Convert to base units (km and seconds)
    double distanceKm = distance ?? 0;
    if (_distanceUnit == 'mi') {
      distanceKm = distanceKm * 1.60934;
    } else if (_distanceUnit == 'm') {
      distanceKm = distanceKm / 1000;
    }

    int totalSeconds = (hours * 3600) + (minutes * 60) + seconds;
    int paceTotalSeconds = (paceMinutes * 60) + paceSeconds;

    // Perform calculations based on type
    if (_calculationType == 'time') {
      // Calculate time from distance and pace
      int calculatedTotalSeconds = (distanceKm * paceTotalSeconds).round();
      
      // Format the time result
      _resultTime = _formatTime(calculatedTotalSeconds);
      
      // Calculate speed
      _calculateSpeed(distanceKm, calculatedTotalSeconds);
      
      // Clear other results
      _resultDistance = null;
      _resultPace = _formatPace(paceTotalSeconds, _paceUnit);
      
    } else if (_calculationType == 'pace') {
      // Calculate pace from distance and time
      if (distanceKm > 0 && totalSeconds > 0) {
        int calculatedPaceSeconds = (totalSeconds / distanceKm).round();
        
        // Format the pace result
        _resultPace = _formatPace(calculatedPaceSeconds, _paceUnit);
        
        // Calculate speed
        _calculateSpeed(distanceKm, totalSeconds);
        
        // Clear other results
        _resultDistance = null;
        _resultTime = _formatTime(totalSeconds);
      } else {
        _showValidationError('Distance and time must be greater than zero');
        return;
      }
      
    } else if (_calculationType == 'distance') {
      // Calculate distance from time and pace
      if (paceTotalSeconds > 0) {
        double calculatedDistance = totalSeconds / paceTotalSeconds;
        
        // Convert back to selected unit
        if (_distanceUnit == 'mi') {
          calculatedDistance = calculatedDistance / 1.60934;
        } else if (_distanceUnit == 'm') {
          calculatedDistance = calculatedDistance * 1000;
        }
        
        // Format the distance result
        _resultDistance = '${calculatedDistance.toStringAsFixed(2)} $_distanceUnit';
        
        // Calculate speed
        double distanceInKm = calculatedDistance;
        if (_distanceUnit == 'mi') {
          distanceInKm = calculatedDistance * 1.60934;
        } else if (_distanceUnit == 'm') {
          distanceInKm = calculatedDistance / 1000;
        }
        _calculateSpeed(distanceInKm, totalSeconds);
        
        // Clear other results
        _resultTime = _formatTime(totalSeconds);
        _resultPace = _formatPace(paceTotalSeconds, _paceUnit);
      } else {
        _showValidationError('Pace must be greater than zero');
        return;
      }
    }

    setState(() {});
  }

  void _calculateSpeed(double distanceKm, int totalSeconds) {
    if (totalSeconds > 0) {
      // Calculate speed in km/h
      _resultSpeedKmh = (distanceKm / totalSeconds) * 3600;
      
      // Calculate speed in mph
      _resultSpeedMph = _resultSpeedKmh! / 1.60934;
    } else {
      _resultSpeedKmh = null;
      _resultSpeedMph = null;
    }
  }

  String _formatTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatPace(int paceSeconds, String unit) {
    int minutes = paceSeconds ~/ 60;
    int seconds = paceSeconds % 60;
    
    String unitSuffix = unit == 'min/km' ? '/km' : '/mi';
    return '$minutes:${seconds.toString().padLeft(2, '0')}$unitSuffix';
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _resetCalculator() {
    setState(() {
      if (_calculationType == 'time') {
        _hoursController.clear();
        _minutesController.clear();
        _secondsController.clear();
      } else if (_calculationType == 'pace') {
        _paceMinutesController.clear();
        _paceSecondsController.clear();
      } else if (_calculationType == 'distance') {
        _distanceController.clear();
      }
      
      _resultPace = null;
      _resultTime = null;
      _resultDistance = null;
      _resultSpeedKmh = null;
      _resultSpeedMph = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Running Pace Calculator',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Calculation type selector
          const Text(
            'Calculate',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildSelectionButton(
                  label: 'Time',
                  isSelected: _calculationType == 'time',
                  onTap: () {
                    setState(() {
                      _calculationType = 'time';
                      _resetCalculator();
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSelectionButton(
                  label: 'Pace',
                  isSelected: _calculationType == 'pace',
                  onTap: () {
                    setState(() {
                      _calculationType = 'pace';
                      _resetCalculator();
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSelectionButton(
                  label: 'Distance',
                  isSelected: _calculationType == 'distance',
                  onTap: () {
                    setState(() {
                      _calculationType = 'distance';
                      _resetCalculator();
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Input fields based on calculation type
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column - Inputs
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Distance input (hidden when calculating distance)
                    if (_calculationType != 'distance') ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildInputField(
                              label: 'Distance',
                              controller: _distanceController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: _buildUnitSelector(
                              value: _distanceUnit,
                              options: const ['km', 'mi', 'm'],
                              onChanged: (value) {
                                setState(() {
                                  _distanceUnit = value!;
                                  if (value == 'km') {
                                    _paceUnit = 'min/km';
                                  } else if (value == 'mi') {
                                    _paceUnit = 'min/mi';
                                  } else {
                                    _paceUnit = 'min/km'; // Default to min/km for meters
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // Time input (hidden when calculating time)
                    if (_calculationType != 'time') ...[
                      const Text(
                        'Time',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInputField(
                              label: 'Hours',
                              controller: _hoursController,
                              keyboardType: TextInputType.number,
                              showLabel: false,
                              hintText: 'hh',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildInputField(
                              label: 'Minutes',
                              controller: _minutesController,
                              keyboardType: TextInputType.number,
                              showLabel: false,
                              hintText: 'mm',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildInputField(
                              label: 'Seconds',
                              controller: _secondsController,
                              keyboardType: TextInputType.number,
                              showLabel: false,
                              hintText: 'ss',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // Pace input (hidden when calculating pace)
                    if (_calculationType != 'pace') ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Pace',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildInputField(
                                        label: 'Minutes',
                                        controller: _paceMinutesController,
                                        keyboardType: TextInputType.number,
                                        showLabel: false,
                                        hintText: 'min',
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _buildInputField(
                                        label: 'Seconds',
                                        controller: _paceSecondsController,
                                        keyboardType: TextInputType.number,
                                        showLabel: false,
                                        hintText: 'sec',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: _buildUnitSelector(
                              value: _paceUnit,
                              options: const ['min/km', 'min/mi'],
                              onChanged: (value) {
                                setState(() {
                                  _paceUnit = value!;
                                  if (value == 'min/km') {
                                    _distanceUnit = 'km';
                                  } else {
                                    _distanceUnit = 'mi';
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // Calculate button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _calculate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Calculate',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Common running distances
                    const Text(
                      'Common Distances',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildDistanceChip('5K', '5'),
                        _buildDistanceChip('10K', '10'),
                        _buildDistanceChip('Half Marathon', '21.0975'),
                        _buildDistanceChip('Marathon', '42.195'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              
              // Right column - Results
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Results',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Time result
                      _buildResultItem(
                        label: 'Time',
                        value: _resultTime ?? '--:--:--',
                        highlight: _calculationType == 'time',
                      ),
                      const SizedBox(height: 16),
                      
                      // Pace result
                      _buildResultItem(
                        label: 'Pace',
                        value: _resultPace ?? '--:--',
                        highlight: _calculationType == 'pace',
                      ),
                      const SizedBox(height: 16),
                      
                      // Distance result
                      _buildResultItem(
                        label: 'Distance',
                        value: _resultDistance ?? '-- ${_distanceUnit}',
                        highlight: _calculationType == 'distance',
                      ),
                      const SizedBox(height: 16),
                      
                      // Speed results
                      if (_resultSpeedKmh != null) ...[
                        const Divider(),
                        const SizedBox(height: 16),
                        _buildResultItem(
                          label: 'Speed (km/h)',
                          value: '${_resultSpeedKmh!.toStringAsFixed(2)} km/h',
                          highlight: false,
                        ),
                        const SizedBox(height: 16),
                        _buildResultItem(
                          label: 'Speed (mph)',
                          value: '${_resultSpeedMph!.toStringAsFixed(2)} mph',
                          highlight: false,
                        ),
                      ],
                      
                      const SizedBox(height: 24),
                      
                      // Explanation
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'How to use',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getHowToUseText(),
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
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Race equivalency explanation
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Training Tip',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'For effective training, try to maintain a consistent pace throughout your run. Use this calculator to plan your training sessions and track your progress over time. For race preparation, practice running at your target pace to build muscle memory and endurance.',
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
    );
  }

  String _getHowToUseText() {
    if (_calculationType == 'time') {
      return 'Enter your distance and target pace to calculate your total running time.';
    } else if (_calculationType == 'pace') {
      return 'Enter your distance and total time to calculate your running pace.';
    } else {
      return 'Enter your total time and target pace to calculate the distance you can run.';
    }
  }

  Widget _buildDistanceChip(String label, String value) {
    return GestureDetector(
      onTap: () {
        if (_calculationType != 'distance') {
          setState(() {
            _distanceController.text = value;
          });
        }
      },
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.blue.shade50,
        side: BorderSide(color: Colors.blue.shade200),
      ),
    );
  }

  Widget _buildResultItem({
    required String label,
    required String value,
    required bool highlight,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: highlight ? Colors.blue : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
    bool showLabel = true,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText ?? 'Enter $label',
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
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUnitSelector({
    required String value,
    required List<String> options,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Unit',
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
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              items: options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
