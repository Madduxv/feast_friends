import 'package:flutter/material.dart';
import 'GenrePage.dart';
import 'RestaurantCardsPage.dart';
//rename to feast friend

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
      home: const GenreCards(),
    );
  }
}

