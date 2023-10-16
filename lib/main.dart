import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}): super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 70),
            Container(
              height: 70,
              color: Colors.deepPurpleAccent,),
            Expanded(child: Container(
              color: Colors.redAccent,
            )),
            Container(
              height: 120,
              color: Colors.deepPurpleAccent,)
          ],
        ),
      ),
    );

  }
}

