import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

abstract class BaseRepository<T> {
  Future<T> fetch();
  Future<T> create(T item);
  Future<T> read(dynamic id);
  Future<T> update(T item);
  Future<void> delete(dynamic id);
  Future<List<T>> readAll();
  Future<Post2> createPost2();
}

abstract class BaseRepositorySecond<T> {
  Future<T> fetch();
  Future<T> create(T item);
  Future<T> read(dynamic id);
  Future<T> update(T item);
  Future<void> delete(dynamic id);
  Future<List<T>> readAll();
  Future<Post2> createPost2();
}

abstract class BaseViewModel<T> with ChangeNotifier {
  final BaseRepository<T> repository;
  T? _data;

  BaseViewModel(this.repository);

  T? get data => _data;

  Future<void> fetchData() async {
    _data = await repository.fetch();
    notifyListeners();
  }

  @override
  void dispose() {
    _data = null;
    super.dispose();
  }
}

abstract class BaseViewModelSecond<T> {
  final BaseRepository<T> repo;

  BaseViewModelSecond(this.repo);

  Future<Post2> fechData() async {
    final data = await repo.createPost2();
    return data;
  }
}

class PostViewModel extends BaseViewModel<Post> {
  PostViewModel() : super(PostRepository());
}

class Post2ViewModel extends BaseViewModelSecond<Post> {
  Post2ViewModel(super.repo);
}

class Post2 {
  final int id;
  final String title;
  final String body;

  Post2({required this.id, required this.title, required this.body});
}

class Post {
  final int id;
  final String title;
  final String body;

  Post({required this.id, required this.title, required this.body});
}

class PostRepository extends BaseRepository<Post> {
  @override
  Future<Post> fetch() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
    final responseData = json.decode(response.body);
    return Post(
      id: responseData['id'],
      title: responseData['title'],
      body: responseData['body'],
    );
  }

  @override
  Future<Post> create(Post item) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> delete(id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Post> read(id) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> readAll() {
    // TODO: implement readAll
    throw UnimplementedError();
  }

  @override
  Future<Post> update(Post item) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<Post2> createPost2() {
    // TODO: implement createPost2
    throw UnimplementedError();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
      ),
      body: Center(
        child: Consumer<PostViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.data == null) {
              return const CircularProgressIndicator();
            } else {
              final post = viewModel.data;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(post?.title ?? ''),
                  const SizedBox(height: 8),
                  Text(post?.body ?? ''),
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<PostViewModel>(context, listen: false).fetchData();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
