import 'package:flutter/material.dart';

class HomeTestPage extends StatefulWidget {
  const HomeTestPage({super.key});

  @override
  State<HomeTestPage> createState() => _HomeTestPageState();
}

class _HomeTestPageState extends State<HomeTestPage> {
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

class PageViewOne extends StatefulWidget {
  final String title;
  const PageViewOne({super.key, required this.title});

  @override
  State<PageViewOne> createState() => _PageViewOneState();
}

class _PageViewOneState extends State<PageViewOne> {
  bool isState = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Page 1',
          style: TextStyle(fontSize: 24),
        ),
        const SizedBox(
          height: 24,
        ),
        ElevatedButton(
            onPressed: () {
              isState = !isState;
              setState(() {});
            },
            child: Text(isState ? 'Remove State' : 'Change State'))
      ],
    );
  }
}
