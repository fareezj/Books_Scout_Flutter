import 'package:book_scout/db/database_helper.dart';
import 'package:book_scout/models/db_book_model.dart';
import 'package:sqflite/sqflite.dart';

class DbBooksViewModel {
  Future<void> addBookmark(DbBookModel dbBookModel) async {
    Database db = await DatabaseHelper.instance.database;
    await db.insert('books', dbBookModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> addToReadDetails(DbBookReadModel dbBookReadModel) async {
    Database db = await DatabaseHelper.instance.database;
    await db.insert('booksRead', dbBookReadModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map>> getReadBookDetails(String bookId) async {
    Database db = await DatabaseHelper.instance.database;
    List<Map> result =
        await db.rawQuery('SELECT * FROM booksRead where idRead=?', [bookId]);
    print(result[0]);
    return result;
  }

  Future<List<Map>> getBookmark(String bookId) async {
    Database db = await DatabaseHelper.instance.database;
    List<Map> result =
        await db.rawQuery('SELECT * FROM books WHERE id=?', [bookId]);
    return result;
  }

  Future<void> updateBookmark(String bookId, DbBookModel bookData) async {
    Database db = await DatabaseHelper.instance.database;
    await db
        .update('books', bookData.toMap(), where: 'id=?', whereArgs: [bookId]);
    // await db.delete('books', where: 'id=?', whereArgs: [bookId]);
  }

  Future<List<Map>> getAllBookmark() async {
    Database db = await DatabaseHelper.instance.database;
    List<Map> result =
        await db.rawQuery('SELECT * FROM books WHERE isFavourite=?', ["true"]);
    //print(result[0]["id"]);
    print(result.length);
    return result;
  }

  Future<List<Map>> getAllReadBooks() async {
    Database db = await DatabaseHelper.instance.database;
    List<Map> result = await db
        .rawQuery('SELECT * FROM books WHERE isAddedToReadList=?', ["true"]);
    //print(result[0]["id"]);
    print(result[0]);
    return result;
  }
}
