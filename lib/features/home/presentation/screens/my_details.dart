import 'package:flutter/material.dart';
import 'package:shopy/core/widgets/title_section.dart';

class MyDetails extends StatelessWidget {
  const MyDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(children: [TitleSection(title: 'My Details')]),
        ),
      ),
    );
  }
}
