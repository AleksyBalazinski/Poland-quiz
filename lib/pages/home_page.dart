import 'package:flutter/material.dart';
import 'package:poland_quiz/geojson.dart';
import 'package:poland_quiz/pages/dashboard_page.dart';
import 'package:poland_quiz/pages/learn_page.dart';
import 'package:poland_quiz/pages/quiz_page.dart';
import 'dart:convert' show jsonDecode;
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  loadJson() async {
    String data = await rootBundle.loadString('assets/gadm41_POL_1.json');
    Map<String, dynamic> parsedJson = jsonDecode(data);
    GeoJson geoJson = GeoJson.fromJson(parsedJson);
    print('hello');
    print(geoJson.type);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadJson();
    });
  }

  final List<Widget> _screens = [
    const DashboardPage(),
    const LearnPage(),
    const QuizPage(),
  ];

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
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _itemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.school,
              ),
              label: 'Learning'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.question_mark,
              ),
              label: 'Quiz'),
        ],
      ),
    );
  }
}
