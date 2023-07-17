import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_animated_bottom_bar.dart';
import 'provider/bottom_bar_provider.dart';

class AnimatedBottomBarPage extends StatelessWidget {
  const AnimatedBottomBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => BottomBarProvider()),
        ],
        builder: (context, _) {
          return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: const Text("Custom Animated Bottom Navigation Bar"),
                backgroundColor: Colors.green[200],
              ),
              body: const BodyWidget(),
              bottomNavigationBar: const BottomNavigatioBar());
        });
  }
}

class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key});

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      Container(
        alignment: Alignment.center,
        child: const Text(
          "Home",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: const Text(
          "Users",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: const Text(
          "Messages",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: const Text(
          "Settings",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: const Text(
          "Settings",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    ];
    return Selector<BottomBarProvider, int>(
        selector: (_, p1) => p1.currentIndex,
        builder: (context, currentIndex, child) {
          return IndexedStack(
            index: currentIndex,
            children: pages,
          );
        });
  }
}

class BottomNavigatioBar extends StatelessWidget {
  const BottomNavigatioBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomBarProvider>(builder: (context, pr, child) {
      return CustomAnimatedBottomBar(
        containerHeight: 70,
        backgroundColor: Colors.black,
        selectedIndex: pr.currentIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        onItemSelected: (index) {
          pr.currentIndex = index;
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: const Icon(Icons.apps),
            title: const Text('HomeHomeHomeHome'),
            activeColor: Colors.green,
            inactiveColor: pr.inactiveColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.people),
            title: const Text('Users'),
            activeColor: Colors.purpleAccent,
            inactiveColor: pr.inactiveColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.message),
            title: const Text(
              'Messages ',
            ),
            activeColor: Colors.pink,
            inactiveColor: pr.inactiveColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.settings),
            title: const Text('Settings'),
            activeColor: Colors.blue,
            inactiveColor: pr.inactiveColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.settings),
            title: const Text('Settings'),
            activeColor: Colors.blue,
            inactiveColor: pr.inactiveColor,
            textAlign: TextAlign.center,
          ),
        ],
      );
    });
  }
}
