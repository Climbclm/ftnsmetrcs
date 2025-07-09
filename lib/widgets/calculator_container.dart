import 'package:flutter/material.dart';
import 'responsive_layout.dart';
import '../calculators/bmi_calculator.dart';
import '../calculators/bmr_calculator.dart';
import '../calculators/body_fat_calculator.dart';
import '../calculators/waist_hip_ratio_calculator.dart';
import '../calculators/lean_body_mass_calculator.dart';
import '../calculators/body_frame_calculator.dart';
import '../calculators/tdee_calculator.dart';
import '../calculators/macro_calculator.dart';
import '../calculators/water_intake_calculator.dart';
import '../calculators/max_heart_rate_calculator.dart';
import '../calculators/one_rep_max_calculator.dart';
import '../calculators/wilks_calculator.dart';
import '../calculators/power_index_calculator.dart';
import '../calculators/running_pace_calculator.dart';
import '../calculators/vo2max_calculator.dart';
import '../calculators/ideal_weight_calculator.dart';

class CalculatorContainer extends StatelessWidget {
  final String toolId;

  const CalculatorContainer({super.key, required this.toolId});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _getCalculator(),
        ),
      ),
      desktopLayout: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _getCalculator(),
        ),
      ),
    );
  }

  Widget _getCalculator() {
    switch (toolId) {
      case 'bmi':
        return const BMICalculator();
      case 'bmr':
        return const BMRCalculator();
      case 'bodyfat':
        return const BodyFatCalculator();
      case 'whr':
        return const WaistHipRatioCalculator();
      case 'lbm':
        return const LeanBodyMassCalculator();
      case 'frame':
        return const BodyFrameCalculator();
      case 'tdee':
        return const TDEECalculator();
      case 'macros':
        return const MacroCalculator();
      case 'water':
        return const WaterIntakeCalculator();
      case 'maxhr':
        return const MaxHeartRateCalculator();
      case 'onerepmax':
        return const OneRepMaxCalculator();
      case 'wilks':
        return const WilksCalculator();
      case 'power':
        return const PowerIndexCalculator();
      case 'pace':
        return const RunningPaceCalculator();
      case 'vo2max':
        return const VO2MaxCalculator();
      case 'ideal':
        return const IdealWeightCalculator();
      default:
        return const BMICalculator();
    }
  }
}
