import 'package:flutter/material.dart';
import 'package:fireflutter/fireflutter.dart';

FireFlutter ff = FireFlutter();

void main() async {
  await ff.init();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FireFlutter'),
      ),
      body: Center(
        child: Text('FireFlutter.init'),
      ),
    );
  }
}
