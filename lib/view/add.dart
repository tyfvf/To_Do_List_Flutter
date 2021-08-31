import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/model/note.dart';
import 'package:todo_list/repository/notedb_repository.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();

  DateTime _date = DateTime.now();

  final DateFormat _dateFormatter = DateFormat("MMM dd, yyyy");

  @override
  void initState() {
    super.initState();

    _dateController.text = _dateFormatter.format(_date);
  }

  _handleDatePicker() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormatter.format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/");
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Create a new note",
                      style:
                          TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Title"),
                    keyboardType: TextInputType.text,
                    controller: _titleController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Date",
                    ),
                    onTap: _handleDatePicker,
                    controller: _dateController,
                    readOnly: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      save();
                    },
                    child: Text("Create new note"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void save() async {
    final String title = _titleController.text;
    final String date = _dateController.text;
    String message;

    if (_titleController.text == "") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error!!"),
          content: Text("Please fill the title form field"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    } else {
      Note note = Note(
        title: title,
        date: date,
      );

      var repository = NoteDBRepository();
      int register = await repository.insert(note);

      if (register != 0) {
        message = "Note added with sucess.";
      } else {
        message = "Failed to add note.";
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
    }
  }
}
