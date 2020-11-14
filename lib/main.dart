import 'package:flutter/material.dart';
import 'package:todo/ui/Home.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter TODO',
      home: HomePage(),
    );
  }
}
