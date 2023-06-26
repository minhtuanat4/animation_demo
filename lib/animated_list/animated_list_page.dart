import 'package:flutter/material.dart';

class AnimatedListPage extends StatefulWidget {
  const AnimatedListPage({Key? key}) : super(key: key);

  @override
  State<AnimatedListPage> createState() => _AnimatedListPageState();
}

class _AnimatedListPageState extends State<AnimatedListPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final List<String> _items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 1',
    'Item 2',
    'Item 3' 'Item 1',
    'Item 2',
    'Item 3' 'Item 1',
    'Item 2',
    'Item 3'
  ];

  void _addItem() {
    setState(() {
      _items.insert(_items.length, 'New Item');
      _listKey.currentState?.insertItem(_items.length - 1);
    });
  }

  void _removeItem() {
    setState(() {
      _items.removeAt(_items.length - 1);
      _listKey.currentState?.removeItem(_items.length, (context, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            child: ListTile(title: Text(_items[_items.length])),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated List'),
      ),
      body: AnimatedList(
        key: _listKey,
        initialItemCount: _items.length,
        itemBuilder: (context, index, animation) {
          return FadeTransition(
            opacity: animation,
            child: ListTile(title: Text(_items[index])),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}
