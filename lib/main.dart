import 'package:flutter/material.dart';
import './global_variables.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
