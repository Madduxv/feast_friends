import 'package:flutter/material.dart';
import 'package:what_to_eat_app/GenrePage.dart';
import 'package:what_to_eat_app/functions/httpFunctions.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({Key? key}): super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _controller;
  List<String> friends = []; 
  String name = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: SizedBox(
        width: 250,
        child: TextFormField(
          obscureText: false,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Enter Name",
            ),
          controller: _controller,
          onFieldSubmitted: (String value) async {
            name = value;
            friends = await HttpFunctions.getUsersFriends(value);
            print(friends);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return GenreCards(name: name);
                  }));
          },),
        ),
      )
    );
  }
}

