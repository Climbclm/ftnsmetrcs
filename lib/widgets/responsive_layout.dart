import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget desktopLayout;
  final double breakpoint;

  const ResponsiveLayout({
    super.key,
    required this.mobileLayout,
    required this.desktopLayout,
    this.breakpoint = 768,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < breakpoint) {
          return mobileLayout;
        } else {
          return desktopLayout;
        }
      },
    );
  }
}

class ResponsiveCalculatorLayout extends StatelessWidget {
  final Widget inputSection;
  final Widget resultsSection;
  final double breakpoint;

  const ResponsiveCalculatorLayout({
    super.key,
    required this.inputSection,
    required this.resultsSection,
    this.breakpoint = 768,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < breakpoint) {
          // Mobile layout - vertical stack
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              inputSection,
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: resultsSection,
              ),
            ],
          );
        } else {
          // Desktop layout - horizontal row
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: inputSection),
              const SizedBox(width: 24),
              Expanded(child: resultsSection),
            ],
          );
        }
      },
    );
  }
}