import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:what_to_eat_app/find_group_page.dart';
import 'package:what_to_eat_app/functions/WebSocketService.dart';
// import 'package:what_to_eat_app/functions/httpFunctions.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({Key? key}): super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late WebSocketService webSocketService;
  late WebSocketChannel channel;
  late TextEditingController _controller;
  dynamic _receivedMessage = '';
  final Completer<void> _nameCompleter = Completer<void>();
  String name = '';

  @override
  void initState() {
    webSocketService = Provider.of<WebSocketService>(context, listen: false);
    webSocketService.messages.listen((message) {
        setState(() {
            _receivedMessage = jsonDecode(message);
            switch (_receivedMessage['contentType']) {
            case 'name':
              print("Name Set");
              _nameCompleter.complete();
              break;
            default:
              print('Unknown content type $_receivedMessage[contentType]');
            }
            print(_receivedMessage);
            });
        });
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _setName(String name) async {
    webSocketService.sendMessage('name', name);
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
            _setName(name);
            await Future.wait([_nameCompleter.future]);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return FindGroupPage(name: name);
                  }));
          },),
        ),
      )
    );
  }
}

