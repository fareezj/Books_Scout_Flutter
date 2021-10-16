import 'package:sqflite/sqflite.dart';
import 'dart:io' show Directory;
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

class DatabaseHelper {
  static const _databaseName = "book_scouts.db";
  static const _databaseVersion = 1;
  static const table = 'books';
  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnPublisher = 'publisher';
  static const columnAuthor = 'author';
  static const columnImage = 'image';
  static const columnDescription = 'description';
  static const columnFavStatus = 'isFavourite';
  static const columnToRead = 'isAddedToReadList';
  static const tableRead = 'booksRead';
  static const columnIdRead = 'idRead';
  static const columnReview = 'reviews';
  static const columnSideNotes = 'sideNotes';

  // Singleton Class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId TEXT PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnAuthor TEXT NOT NULL,
            $columnPublisher TEXT NOT NULL,
            $columnImage TEXT NOT NULL,
            $columnDescription TEXT NOT NULL,
            $columnFavStatus TEXT NOT NULL,
            $columnToRead TEXT NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $tableRead (
            $columnIdRead TEXT PRIMARY KEY,
            $columnReview TEXT NOT NULL,
            $columnSideNotes TEXT NOT NULL
          )
          ''');
  }
}
