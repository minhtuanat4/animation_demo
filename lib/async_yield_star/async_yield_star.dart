Future<int> fetchInt(int val) async {
  return val;
}

Stream<int> fetchInts(int start, int finish) async* {
  if (start <= finish) {
    yield await fetchInt(start);
    yield* fetchInts(start + 1, finish);
  }
}

void main() {
  fetchInts(1, 10).listen((event) {
    print(event.toString());
  });
}


//// Callable Function

// class Person {
//   call(int age, String name) {}
// }
// class MyWidget extends StatefulWidget {
//   const MyWidget({super.key});

//   @override
//   State<MyWidget> createState() => _MyWidgetState();
// }

// class _MyWidgetState extends State<MyWidget> {
//   final person = Person();
//   @override
//   Widget build(BuildContext context) {
//     person(26, "Tuan");
//     return const Placeholder();
//   }
// }
