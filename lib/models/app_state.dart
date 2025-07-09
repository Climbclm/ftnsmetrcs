import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  String _activeCategory = 'bodyComposition';
  String _activeTool = 'bmi';

  String get activeCategory => _activeCategory;
  String get activeTool => _activeTool;

  void setActiveCategory(String category) {
    _activeCategory = category;
    notifyListeners();
  }

  void setActiveTool(String tool) {
    _activeTool = tool;
    notifyListeners();
  }

  // Define categories and tools similar to the original app
  final Map<String, Map<String, dynamic>> categories = {
    'bodyComposition': {
      'name': 'Body Composition',
      'tools': [
        {'id': 'bmi', 'label': 'BMI', 'icon': Icons.scale},
        {'id': 'bodyfat', 'label': 'Body Fat', 'icon': Icons.fitness_center},
        {'id': 'whr', 'label': 'WHR', 'icon': Icons.straighten},
        {'id': 'lbm', 'label': 'Lean Mass', 'icon': Icons.fitness_center},
        {'id': 'frame', 'label': 'Frame Size', 'icon': Icons.straighten},
      ]
    },
    'nutritionMetabolism': {
      'name': 'Nutrition & Metabolism',
      'tools': [
        {'id': 'bmr', 'label': 'BMR', 'icon': Icons.favorite},
        {'id': 'tdee', 'label': 'TDEE', 'icon': Icons.local_fire_department},
        {'id': 'macros', 'label': 'Macros', 'icon': Icons.restaurant},
        {'id': 'water', 'label': 'Water Intake', 'icon': Icons.water_drop},
      ]
    },
    'strengthPower': {
      'name': 'Strength & Power',
      'tools': [
        {'id': 'onerepmax', 'label': '1RM', 'icon': Icons.fitness_center},
        {'id': 'wilks', 'label': 'Wilks Score', 'icon': Icons.calculate},
        {'id': 'power', 'label': 'Power Index', 'icon': Icons.bolt},
      ]
    },
    'performanceMetrics': {
      'name': 'Performance Metrics',
      'tools': [
        {'id': 'maxhr', 'label': 'Max HR', 'icon': Icons.favorite},
        {'id': 'pace', 'label': 'Running Pace', 'icon': Icons.timer},
        {'id': 'vo2max', 'label': 'VO2 Max', 'icon': Icons.monitor_heart},
      ]
    },
    'healthGoals': {
      'name': 'Health Goals',
      'tools': [
        {'id': 'ideal', 'label': 'Ideal Weight', 'icon': Icons.scale},
      ]
    }
  };

  // Tool descriptions
  final Map<String, Map<String, String>> toolDescriptions = {
    'bmi': {
      'title': 'About BMI',
      'content': 'Body Mass Index (BMI) is a simple measure using your height and weight to work out if your weight is healthy.'
    },
    'bmr': {
      'title': 'About BMR',
      'content': 'Basal Metabolic Rate (BMR) is the number of calories your body burns at rest to maintain vital functions.'
    },
    'tdee': {
      'title': 'About TDEE',
      'content': 'Total Daily Energy Expenditure (TDEE) calculates your total daily calorie needs based on your BMR and activity level.'
    },
    'macros': {
      'title': 'About Macro Nutrients',
      'content': 'Macronutrients (proteins, carbs, and fats) are essential nutrients that provide energy and support bodily functions.'
    },
    'bodyfat': {
      'title': 'About Body Fat Percentage',
      'content': 'Body fat percentage is the amount of body fat as a proportion of your body weight.'
    },
    'whr': {
      'title': 'About Waist-Hip Ratio',
      'content': 'Waist-hip ratio (WHR) is a measure of body fat distribution and a predictor of health risk.'
    },
    'lbm': {
      'title': 'About Lean Body Mass',
      'content': 'Lean Body Mass (LBM) is the weight of your body minus your fat mass, including muscles, bones, and organs.'
    },
    'frame': {
      'title': 'About Body Frame Size',
      'content': 'Body frame size is determined by your bone structure and can help determine your ideal weight range and guide fitness plans.'
    },
    'water': {
      'title': 'About Water Intake',
      'content': 'Proper hydration is essential for health. Your daily water needs depend on various factors including weight and activity level.'
    },
    'maxhr': {
      'title': 'About Maximum Heart Rate',
      'content': 'Maximum Heart Rate (MHR) is the highest number of times your heart can beat in one minute during intense exercise.'
    },
    'onerepmax': {
      'title': 'About One Rep Max',
      'content': 'One Rep Max (1RM) is the maximum weight you can lift for a single repetition. It helps in planning training programs and tracking strength progress.'
    },
    'wilks': {
      'title': 'About Wilks Score',
      'content': 'The Wilks Score is a formula that standardizes powerlifting performances across different body weights, allowing comparison between weight classes.'
    },
    'power': {
      'title': 'About Power Index',
      'content': 'The Power Index measures explosive power output relative to body weight, useful for sports requiring quick, powerful movements.'
    },
    'pace': {
      'title': 'About Running Pace',
      'content': 'Running pace helps you track and plan your running performance. It can be used to set goals and maintain consistent effort during training and races.'
    },
    'vo2max': {
      'title': 'About VO2 Max',
      'content': 'VO2 max is the maximum rate of oxygen consumption during intense exercise. It\'s a key indicator of cardiovascular fitness and endurance capacity.'
    },
    'ideal': {
      'title': 'About Ideal Weight',
      'content': 'Ideal weight ranges are based on height, gender, and frame size, providing a target weight range for optimal health.'
    }
  };
}
