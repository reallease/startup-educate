import 'package:flutter/widgets.dart';

class StudyPage extends StatelessWidget {
  const StudyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Página de estudos',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
      )
    );
  }
}