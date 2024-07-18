import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:io';

import 'package:what_to_eat_app/config.dart';
import 'GenrePage.dart';
import 'RestaurantCardsPage.dart';
import 'FindUserPage.dart';
//rename to feast friend

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = await loadConfig();
  runApp(MyApp());
}

Future<void> loadConfig() async {
  try {
    final contents = await rootBundle.loadString('assets/config.json');
    final json = jsonDecode(contents);
    Config().baseUrl = json['API_BASE_URL'];
  } catch (e) {
    throw Exception('Configuration file not found');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: /* const */ FindUserPage(),
      // home: const GenreCards(),
    );
  }
}

