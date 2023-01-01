import 'package:flutter/material.dart';
import 'package:poland_quiz/pages/dashboard_page.dart';
import 'package:poland_quiz/pages/learn_page.dart';
import 'package:poland_quiz/pages/quiz_page.dart';
import 'package:poland_quiz/geojson.dart';
import 'package:poland_quiz/infojson.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  List<Widget> _getScreens(GeoJson geoJson, InfoJson infoJson) {
    return [
      const DashboardPage(),
      LearnPage(geoJson: geoJson, infoJson: infoJson),
      QuizPage(geoJson: geoJson, infoJson: infoJson)
    ];
  }

  final String _mapPath = 'assets/gadm41_POL_1.json';
  final String _infoPath = 'assets/pol_info.json';

  int _selectedIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _itemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Future.wait([loadGeoJson(_mapPath), loadInfoJson(_infoPath)]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              physics: const NeverScrollableScrollPhysics(),
              children: _getScreens(snapshot.data![0], snapshot.data![1]),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _itemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(
                Icons.home,
              ),
              label: AppLocalizations.of(context)!.dashboard),
          BottomNavigationBarItem(
              icon: const Icon(
                Icons.school,
              ),
              label: AppLocalizations.of(context)!.learning),
          BottomNavigationBarItem(
              icon: const Icon(
                Icons.question_mark,
              ),
              label: AppLocalizations.of(context)!.quiz),
        ],
      ),
    );
  }
}
