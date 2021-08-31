import 'package:todo_list/model/db_local.dart';
import 'package:todo_list/model/irepository.dart';
import 'package:todo_list/model/note.dart';

abstract class NoteRepository implements IRepository<Note>{
  //All types of acess to data
  late DBLocal dblocal;
}