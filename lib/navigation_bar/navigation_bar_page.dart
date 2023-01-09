import 'package:flutter/material.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int currentPageIndex = 0;
  final pageController = PageController(
    initialPage: 2,
    keepPage: true,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
          pageController.jumpToPage(currentPageIndex);
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.commute),
            icon: Icon(Icons.commute_outlined),
            label: 'Commute',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            label: 'Home',
            icon: Icon(Icons.home_outlined),
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person),
            label: 'User',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bookmark),
            icon: Icon(Icons.bookmark_border),
            label: 'Saved',
          ),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: const <Widget>[
          PageViewDemo(title: 'Page 1'),
          PageViewDemo(title: 'Page 2'),
          PageViewDemo(title: 'Page 3'),
          PageViewDemo(title: 'Page 4'),
          PageViewDemo(title: 'Page 5'),
        ],
      ),
    );
  }

  void onPageChanged(int value) {
    print('Page View Index:  ${value + 1}');
  }
}

class PageViewDemo extends StatelessWidget {
  final String title;
  const PageViewDemo({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}
