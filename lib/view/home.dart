import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:todo_list/model/note.dart';
import 'package:todo_list/repository/notedb_repository.dart';
import 'package:todo_list/view/edit.dart';

class Home extends StatefulWidget {
  final List<Note> data;

  Home(this.data);

  @override
  _HomeState createState() => _HomeState(this.data);
}

class _HomeState extends State<Home> {
  final List<Note> data;

  _HomeState(
    this.data,
  );

  ScrollController scrollController = ScrollController();
  bool closeContainer = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      setState(() {
        closeContainer = scrollController.offset > 30;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/add");
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: MediaQuery.of(context).size.width,
              height: closeContainer
                  ? 0
                  : MediaQuery.of(context).size.height * 0.10,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                  "My To Do List",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                itemBuilder: noteBuilder,
                separatorBuilder: (BuildContext _, int index) => Divider(),
                itemCount: this.data.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget noteBuilder(BuildContext context, int index) {
    Note note = this.data.elementAt(index);

    return ListTile(
      title: Text(
        note.title,
        style: note.status == 1 ? TextStyle(decoration: TextDecoration.lineThrough) : TextStyle(),
      ),
      subtitle: Text(
        note.date,
        style: note.status == 1 ? TextStyle(decoration: TextDecoration.lineThrough) : TextStyle(),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => EditNote(note)));
            },
            icon: Icon(
              Icons.edit,
              color: Colors.orange,
            ),
          ),
          IconButton(
            onPressed: () async {
              var repository = NoteDBRepository();
              String message;
              int register = await repository.remove(
                conditions: "id=?",
                conditionsValue: [note.id],
              );

              if (register != 0) {
                message = "Note deleted with sucess.";
              } else {
                message = "Failed to delete note.";
              }

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Report!"),
                  content: Text(message),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("/");
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
      leading: IconButton(
        onPressed: () async {
          int newStatus;
          if (note.status == 1) {
            newStatus = 0;
          } else {
            newStatus = 1;
          }

          var repository = NoteDBRepository();
          Note newNote = Note(
            id: note.id,
            title: note.title,
            date: note.date,
            status: newStatus
          );

          await repository.update(
              entity: newNote, conditions: "id=?", conditionsValue: [note.id]);

          Navigator.of(context).pushNamed("/");          
        },
        icon: Icon(
          Icons.done,
          color: note.status == 1 ? Colors.blue : Colors.grey,
        ),
      ),
    );
  }
}
