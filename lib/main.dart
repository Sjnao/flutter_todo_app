import 'package:flutter/material.dart';
import 'homepage.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        backgroundColor: Colors.orange[700]
      ),
      home: Homepage(),
    );
  }
}


