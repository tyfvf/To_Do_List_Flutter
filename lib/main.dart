import 'package:flutter/material.dart';
import 'package:todo_list/view/add.dart';
import 'package:todo_list/view/connection.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    routes: {
      "/": (BuildContext context) => Connection(),
      "/add": (BuildContext context) => AddNote(),
    },
  ));
}
