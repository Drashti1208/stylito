import 'package:flutter/material.dart';
import '../landing/landing_page_screen.dart';

/// Legacy export wrapper pointing to the modern GetX LandingPageScreen
class StylishWebsiteView extends StatelessWidget {
  final Function(int)? onNavigateTab;

  const StylishWebsiteView({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    return LandingPageScreen(onNavigateTab: onNavigateTab);
  }
}
