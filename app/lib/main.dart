import 'package:flutter/material.dart';

import 'widgets/screens/task_selector.dart';

void main() => runApp(MmdoZlpApp());

class MmdoZlpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskSelector(),
    );
  }
}