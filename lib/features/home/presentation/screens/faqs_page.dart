import 'package:flutter/material.dart';
import 'package:shopy/core/widgets/title_section.dart';

class FaqsPage extends StatelessWidget {
  const FaqsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(children: [TitleSection(title: 'FAQs')]),
        ),
      ),
    );
  }
}
