import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../widgets/calculator_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showInfo = false;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final activeCategory = appState.activeCategory;
    final activeTool = appState.activeTool;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.monitor_heart, color: Colors.green),
            SizedBox(width: 8),
            Text(
              'Fitness Metrics Pro',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              setState(() {
                _showInfo = !_showInfo;
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE0F7FA), Colors.white, Color(0xFFE8F5E9)],
          ),
        ),
        child: Column(
          children: [
            // Categories
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: appState.categories.entries.map((entry) {
                  final categoryKey = entry.key;
                  final category = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        appState.setActiveCategory(categoryKey);
                        // Set the first tool of the category as active
                        final firstTool = (category['tools'] as List).first;
                        appState.setActiveTool(firstTool['id'] as String);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: activeCategory == categoryKey
                            ? Colors.green
                            : Colors.white,
                        foregroundColor: activeCategory == categoryKey
                            ? Colors.white
                            : Colors.black87,
                        elevation: activeCategory == categoryKey ? 4 : 1,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      child: Text(category['name'] as String),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Tools
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: (appState.categories[activeCategory]?['tools'] as List)
                    .map((tool) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ElevatedButton.icon(
                      icon: Icon(tool['icon'] as IconData),
                      label: Text(tool['label'] as String),
                      onPressed: () {
                        appState.setActiveTool(tool['id'] as String);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: activeTool == tool['id']
                            ? Colors.green
                            : Colors.white,
                        foregroundColor: activeTool == tool['id']
                            ? Colors.white
                            : Colors.black87,
                        elevation: activeTool == tool['id'] ? 4 : 1,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Info Panel
            if (_showInfo)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appState.toolDescriptions[activeTool]?['title'] ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          appState.toolDescriptions[activeTool]?['content'] ?? '',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Calculator Container
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CalculatorContainer(toolId: activeTool),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
