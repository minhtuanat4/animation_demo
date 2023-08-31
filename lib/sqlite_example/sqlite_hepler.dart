import 'package:sqflite/sqflite.dart';

import 'model/udpate_email_model.dart';

const String newsTable = 'news';
const String emailRaw = 'email';
const String secureCodeRaw = 'securecode';
const String secureTypeIdRaw = 'securetype';
const String index = 'indexNew';
const String columnIdRaw = 'id';

class NewsProvider {
  static final NewsProvider _shared = NewsProvider._initialState();
  factory NewsProvider() {
    return _shared;
  }
  NewsProvider._initialState();
  late Database db;
  String _path = '';
  Future<void> getPathData() async {
    final pathDB = await getDatabasesPath();
    _path = '$pathDB/$newsTable.db';
  }

  String get path => _path;

  Future<void> initOpenDababase() async {
    db = await openDatabase(_path,
        version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {});
    await db.execute('''
create table IF NOT EXISTS $newsTable ( 
  $index INTEGER PRIMARY KEY AUTOINCREMENT, 
  $columnIdRaw integer unique not null, 
  $emailRaw text not null,
  $secureCodeRaw text,
  $secureTypeIdRaw integer)
''');
  }

  Future<UpdateEmailRequest> insertNews(UpdateEmailRequest todo) async {
    todo.columnId = await db.insert(newsTable, todo.toJson());
    return todo;
  }

  Future<UpdateEmailRequest?> getNews(int id) async {
    List<Map<String, dynamic>> maps = await db.query(newsTable,
        columns: [columnIdRaw, emailRaw, secureCodeRaw, secureTypeIdRaw],
        where: '$columnIdRaw = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return UpdateEmailRequest.fromJson(maps.first);
    }
    return null;
  }

  Future<List<UpdateEmailRequest>?> getNewsFollowingPage(
      int pageNumber, int countItems) async {
    final skipItem = (pageNumber - 1) * countItems;
    final lstMaps = await db.rawQuery(
        '''SELECT * FROM $newsTable LIMIT $countItems OFFSET $skipItem''');

    if (lstMaps.isNotEmpty) {
      final result = List<UpdateEmailRequest>.from(
          lstMaps.map((x) => UpdateEmailRequest.fromJson(x)));
      return result;
    }
    return null;
  }

  Future<int?> delete(int id) async {
    return await db
        .delete(newsTable, where: '$columnIdRaw = ?', whereArgs: [id]);
  }

  Future<int> update(UpdateEmailRequest newItem) async {
    return await db.update(newsTable, newItem.toJson(),
        where: '$columnIdRaw = ?', whereArgs: [newItem.columnId]);
  }

  Future<void> deleteAllData() async {
    return await db.execute('DELETE FROM $newsTable');
  }

  Future close() async => db.close();
}
