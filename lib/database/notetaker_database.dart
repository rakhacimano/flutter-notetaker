import 'package:notetaker/models/notetaker.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotetakerDatabase {
  static final NotetakerDatabase instance = NotetakerDatabase._init();

  NotetakerDatabase._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notetaker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    const sql = '''
    CREATE TABLE $tableNotetaker(
      ${NotetakerFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${NotetakerFields.isImportant} BOOLEAN NOT NULL,
      ${NotetakerFields.number} INTEGER NOT NULL,
      ${NotetakerFields.title} TEXT NOT NULL,
      ${NotetakerFields.description},
      ${NotetakerFields.time} TEXT NOT NULL
    )
    ''';
    await db.execute(sql);
  }

  Future<Notetaker> create(Notetaker notetaker) async {
    final db = await instance.database;
    final id = await db.insert(tableNotetaker, notetaker.toJson());
    return notetaker.copy(id: id);
  }

  Future<List<Notetaker>> getAllNotes() async {
    final db = await instance.database;
    final result = await db.query(tableNotetaker);
    return result.map((json) => Notetaker.fromJson(json)).toList();
  }

  Future<Notetaker> getNoteById(int id) async {
    final db = await instance.database;
    final result = await db.query(tableNotetaker,
        where: '${NotetakerFields.id} = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Notetaker.fromJson(result.first);
    } else {
      throw Exception('ID $id not found ');
    }
  }

  Future<int> deleteNoteById(int id) async {
    final db = await instance.database;
    return await db.delete(tableNotetaker,
        where: '${NotetakerFields.id} = ?', whereArgs: [id]);
  }

  Future<int> updateNote(Notetaker notetaker) async {
    final db = await instance.database;
    return await db.update(tableNotetaker, notetaker.toJson(),
        where: '${NotetakerFields.id} = ?', whereArgs: [notetaker.id]);
  }
}
