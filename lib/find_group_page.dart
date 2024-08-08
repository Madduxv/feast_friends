import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:what_to_eat_app/functions/WebSocketService.dart';
import 'package:what_to_eat_app/widgets/searchBar.dart';
import 'package:what_to_eat_app/functions/httpFunctions.dart';

class FindGroupPage extends StatefulWidget {
  const FindGroupPage({Key? key}): super(key: key);

  @override
  _FindGroupPageState createState() => _FindGroupPageState();
}


class _FindGroupPageState extends State<FindGroupPage> {
  late WebSocketService webSocketService;
  late WebSocketChannel channel;
  final Completer<void> _activeFriendsCompleter = Completer<void>();
  dynamic _receivedMessage = '';
  List<String> data = [];
  List<String> searchResults = [];
  List<String> activeFriends = []; 
  String name = 'Maddux';

  @override
  void initState() {
    webSocketService = Provider.of<WebSocketService>(context, listen: false);
    webSocketService.messages.listen((message) {
        setState(() {
            _receivedMessage = jsonDecode(message);
            switch (_receivedMessage['contentType']) {
            case 'activeFriendsGroups':
              activeFriends = List<String>.from(_receivedMessage['content']);
              print(activeFriends);
              _activeFriendsCompleter.complete();
              break;
            default:
              print('Unknown content type');
            }
            print(_receivedMessage);
            });
        });
    super.initState();
    loadUsersNames();
  }

  void onQueryChanged(String query) {
    setState(() {
      searchResults = data
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void loadUsersNames() async {
    data = await getUsersNames();
  }

  Future<List<String>> getUsersNames() async {
    data = await HttpFunctions.getUsersNames();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Feast Friend'),
      ),
      body: Column(
        children: [
          MySearchBar(onQueryChanged: onQueryChanged),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(searchResults[index]),
                  onTap: () {_showPopup(context, searchResults[index], name);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showPopup (BuildContext context, String item, String name) {
    showDialog(
    context: context, 
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Add $item as a friend?"),
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
            HttpFunctions.addUserFriend(name, item);
            Navigator.of(context).pop();
          },
        ),],
      );
    });
  }

}
