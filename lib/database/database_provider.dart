import 'package:notes_app/model/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {

  static final DatabaseProvider instance = DatabaseProvider._init();
  static Database? _database;

  DatabaseProvider._init();

  //getting the database
  Future<Database?> get database async {
    //Check if db is already there
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    return await openDatabase(join(await getDatabasesPath(), filePath),
        onCreate: (db, version) async {
      //create first table
      await db.execute('''
          CREATE TABLE notes (
            ${NoteFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${NoteFields.number} INTEGER NOT NULL,
            ${NoteFields.title} TEXT NOT NULL,
            ${NoteFields.text} TEXT NOT NULL,
            ${NoteFields.date} TEXT NOT NULL
          )
        ''');
    }, version: 1);
  }

  // Create function to add a new note to our variable
  Future<NoteModel> addNewNote(NoteModel note) async {
    final db = await (instance.database);
    final id = await db?.insert('notes', note.toMap());
    return note.copy(id: id);
  }

  Future<NoteModel> readNote(int? id) async {
    final db = await (instance.database);
    final res = await db?.query(
      'notes',
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );

    if (res!.isNotEmpty)
      return NoteModel.fromMap(res.first);
    else
      throw Exception('ID $id not found');
  }

  //create function that will fetch our database and return all the element inside the notes table
  Future<List<NoteModel>> readAllNotes() async {
    final db = await (instance.database);
    final orderBy = '${NoteFields.date} ASC';
    final result = await db?.query('notes', orderBy: orderBy);

    return result!.map((map) => NoteModel.fromMap(map)).toList();
  }

  //function to update
  Future<int> update(NoteModel note) async {
    final db = await (instance.database);
    return db!.update(
      'notes',
      note.toMap(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  //Function to delete item
  Future<int> deleteNote(int? id) async {
    final db = await (instance.database);
    return await db!.delete(
      'notes',
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await (instance.database);
    db!.close();
  }
}
