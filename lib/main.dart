import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:what_to_eat_app/functions/WebSocketService.dart';
import 'package:what_to_eat_app/config.dart';
import 'GenrePage.dart';
// import 'RestaurantCardsPage.dart';
// import 'FindUserPage.dart';
//rename to feast friend

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final config = await loadConfig();
//   runApp(MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = await loadConfig();
  runApp(const MyApp());
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
      return MultiProvider(
        providers: [
          Provider<WebSocketService>(
            create: (_) => WebSocketService('ws://${Config().baseUrl}/ws'),
            dispose: (_, service) => service.close(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(brightness: Brightness.dark),
          home: const GenreCards(),
          )
        );
    }
}

