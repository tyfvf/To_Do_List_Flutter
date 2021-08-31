import 'package:todo_list/model/note.dart';
import 'package:todo_list/model/db_local.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/repository/note_repository.dart';

class NoteDBRepository implements NoteRepository {
  @override
  late DBLocal dblocal;

  NoteDBRepository() {
    this.dblocal = DBLocal(
      table: "notes",
    );
  }

  @override
  Future<Note> find(int id) async {
    Database database = await dblocal.getConnection();

    List<Map<String, dynamic>> data = await database.query(
      dblocal.table,
      where: "id=?",
      whereArgs: [id],
    );

    database.close();
    return Note.fromMap(data.first);
  }

  @override
  Future<int> insert(Note entity) async {
    Database database = await dblocal.getConnection();
    int id = await database.insert(dblocal.table, entity.toMap());
    database.close();
    return id;
  }

  @override
  Future<int> remove({
    required String conditions,
    required List conditionsValue,
  }) async {
    Database database = await dblocal.getConnection();
    int id = await database.delete(
      dblocal.table,
      where: conditions,
      whereArgs: conditionsValue,
    );
    database.close();
    return id;
  }

  @override
  Future<List<Note>> search() async {
    Database database = await dblocal.getConnection();
    var data = await database.query(dblocal.table);
    List<Note> notes = data.map((objMap) => Note.fromMap(objMap)).toList();
    database.close();
    return notes;
  }

  @override
  Future<int> update({
    required Note entity,
    required String conditions,
    required List conditionsValue,
  }) async {
    Database database = await dblocal.getConnection();
    int id = await database.update(
      dblocal.table,
      entity.toMap(),
      where: conditions,
      whereArgs: conditionsValue,
    );
    database.close();
    return id;
  }
}
