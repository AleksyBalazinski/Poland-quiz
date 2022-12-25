import 'package:flutter/material.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz selection page'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Voivodeship on the map'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const VoivodeshipOnMapQuiz(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Position of the voivodeship'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PositionOfVoivodeship(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class VoivodeshipOnMapQuiz extends StatelessWidget {
  const VoivodeshipOnMapQuiz({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voivodeship on the map'),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: const Center(
        child: Text('Voivodeship on the map quiz goes here'),
      ),
    );
  }
}

class PositionOfVoivodeship extends StatelessWidget {
  const PositionOfVoivodeship({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Position of the voivodeship'),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: const Center(
        child: Text('Position of the voivodeship quiz goes here'),
      ),
    );
  }
}
