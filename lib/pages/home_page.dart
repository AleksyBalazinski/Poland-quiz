import 'package:flutter/material.dart';
import 'package:poland_quiz/pages/dashboard_page.dart';
import 'package:poland_quiz/pages/learn_page.dart';
import 'package:poland_quiz/pages/quiz_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

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
                //color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
              ),
              label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.school,
                //color: _selectedIndex == 1 ? Colors.blue : Colors.grey,
              ),
              label: 'Learning'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.question_mark,
                //color: _selectedIndex == 2 ? Colors.blue : Colors.grey,
              ),
              label: 'Quiz'),
        ],
      ),
    );
  }
}
