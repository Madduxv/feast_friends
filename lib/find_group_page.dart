import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:what_to_eat_app/functions/WebSocketService.dart';

class FindGroupPage extends StatefulWidget {
  const FindGroupPage({/* Key? key */super.key, required this.name})/* : super(key: key) */;
  final String name;

  @override
  FindGroupPageState createState() => FindGroupPageState();
}


class FindGroupPageState extends State<FindGroupPage> {
  Timer? _timer;
  late WebSocketService webSocketService;
  late WebSocketChannel channel;
  dynamic _receivedMessage = '';
  List<String> data = [];
  List<String> activeFriendsGroups = []; 
  String name = '';

  @override
  void initState() {
    name = widget.name;
    webSocketService = Provider.of<WebSocketService>(context, listen: false);
    webSocketService.messages.listen((message) {
        setState(() {
            _receivedMessage = jsonDecode(message);
            switch (_receivedMessage['contentType']) {
              case 'activeFriendsGroups':
                activeFriendsGroups = List<String>.from(_receivedMessage['content']);
                _updateOpenGroups(activeFriendsGroups);
                break;
              default:
                print('Unknown content type ${_receivedMessage['contentType']}');
              }
            });
        });
    super.initState();
    loadOpenGroups();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) async {
      await loadOpenGroups();
    });
  }

  Future<void> loadOpenGroups() async {
    webSocketService.sendMessage('friendsGroups', '');
  }

  Future<void> _updateOpenGroups(List<String> activeFriendsGroups) async {
    setState(() {
      activeFriendsGroups = activeFriendsGroups;
    });
  }

  Future<void> _joinGroup(String groupName) async {
    webSocketService.sendMessage('join', groupName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Feast Friend'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: activeFriendsGroups.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(activeFriendsGroups[index]),
                  onTap: () {_showPopup(context, activeFriendsGroups[index], name);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showPopup (BuildContext context, String item, String groupName) {
    showDialog(
    context: context, 
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Join $item?"),
        backgroundColor: Colors.grey,
        actions: <Widget> [
        TextButton(
          child: const Text('No'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Yes'),
          onPressed: () {
            _joinGroup(item);
            Navigator.of(context).pop();
          },
        ),],
      );
    });
  }

}
