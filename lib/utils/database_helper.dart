import '../models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
//import 'dart:io';
import 'package:path/path.dart';
//import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> get database async {
    _database ??= await initialiseDatabase();
    return _database!;
  }

  Future<Database> initialiseDatabase() async {
    //Directory directory = await getApplicationDocumentsDirectory();
    //String path = '${directory.path}notes.db';

    String directory = await getDatabasesPath();
    String path = join(directory, 'notes.db');
    //Open connection
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: createDb);
    return notesDatabase;
  }

  void createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');
  }

  //Fetch

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await database;

    //var results = await db.rawQueryCursor('SELECT * FROM $noteTable order by $colPriority ASC', null);
    var results = await db.query(noteTable, orderBy: '$colPriority ASC');
    return results;
  }

  // insert

  Future<int> insertNote(Note note) async {
    Database db = await database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  // update
  Future<int> updateNote(Note note) async {
    Database db = await database;
    var result = await db.update(noteTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  // delete

  Future<int> deleteNote(int id) async {
    Database db = await database;
    var result =
        await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.query('SELECT  COUNT(*) FROM $noteTable');

    int result = Sqflite.firstIntValue(x)!;
    return result;
  }

  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList();
    List<Note> noteList = [];
    //int count = noteMapList.length;
    noteMapList.toList().forEach((map) {
      noteList.add(Note.fromMapObject(map));
    });

    return noteList;
  }
}
