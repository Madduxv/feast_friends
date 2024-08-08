import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:what_to_eat_app/functions/WebSocketService.dart';
import 'package:what_to_eat_app/GenrePage.dart';
import 'package:what_to_eat_app/functions/httpFunctions.dart';

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
  final Completer<void> _activeFriendsCompleter = Completer<void>();
  List<String> friends = []; 
  List<String> activeFriends = []; 
  String name = '';

  @override
  void initState() {
    webSocketService = Provider.of<WebSocketService>(context, listen: false);
    webSocketService.messages.listen((message) {
        setState(() {
            _receivedMessage = jsonDecode(message);
            switch (_receivedMessage['contentType']) {
            //debug mode
            case 'activeFriendsGroups':
              activeFriends = List<String>.from(_receivedMessage['content']);
              print(activeFriends);
              _activeFriendsCompleter.complete();
              break;
            case 'name':
              print("Name Set");
              _nameCompleter.complete();
              break;
            // case 'message':
            //   this.message = _receivedMessage['content'];
            //   break;
            default:
              print('Unknown content type');
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

  Future<void> _getActiveFriends() async {
    webSocketService.sendMessage('friendsGroups', '');
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
            _getActiveFriends();
            await Future.wait([_activeFriendsCompleter.future]);
            print(friends);
            print(activeFriends);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return GenreCards(name: name);
                  }));
          },),
        ),
      )
    );
  }
}

