import 'package:flutter/material.dart';
import 'package:todo_list/repository/notedb_repository.dart';
import 'package:todo_list/view/home.dart';

class Connection extends StatefulWidget {
  @override
  _ConnectionState createState() => _ConnectionState();
}

class _ConnectionState extends State<Connection> {
  @override
  Widget build(BuildContext context) {
    var noteDBRepository = NoteDBRepository();

    return FutureBuilder(
      future: noteDBRepository.search(),
      builder: builder,
    );
  }

  Widget builder(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      default:
        return Home(snapshot.data);
    }
  }
}
