import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:what_to_eat_app/functions/httpFunctions.dart';
import 'package:what_to_eat_app/functions/WebSocketService.dart';
import 'RestaurantCardsPage.dart';

class UserCompleteWaitingPage extends StatefulWidget {
  final List<String> genres;
  final String groupName;

  const UserCompleteWaitingPage({super.key, required this.genres, required this.groupName});

  @override
  UserCompleteWaitingPageState createState() => UserCompleteWaitingPageState();
}

class UserCompleteWaitingPageState extends State<UserCompleteWaitingPage> {
  late WebSocketService webSocketService;
  late WebSocketChannel channel;
  final Completer<void> _groupDoneCompleter = Completer<void>();
  final Completer<void> _restaurantsCompleter = Completer<void>();
  dynamic _receivedMessage = '';
  List<String> restaurants = [];

  @override
  void initState(){
    super.initState();
    webSocketService = Provider.of<WebSocketService>(context, listen: false);
    webSocketService.messages.listen((message) {
        setState(() {
            _receivedMessage = jsonDecode(message);
            print(_receivedMessage);
            switch (_receivedMessage['contentType']) {
            case 'groupDoneStatus':
              _groupDoneCompleter.complete();
              _requestedRestaurants(widget.groupName);
              print("Everyone is done choosing genres.");
              break;
            case 'restaurants':
              restaurants = List<String>.from(_receivedMessage['content']);
              _restaurantsCompleter.complete();
              print(restaurants);
              break;
            default:
              print('Unknown content type');
            }
            print(_receivedMessage);
            });
        });
          _sendDoneMessage(widget.groupName);
          waitAndNavigate(widget.groupName);
  }

  Future<void> _requestedRestaurants(groupName) async {
    webSocketService.sendMessage('getRestaurantChoices', groupName);
  }

  Future<void> _sendDoneMessage(String groupName) async {
    webSocketService.sendMessage('done', groupName);
  }

  Future<void> waitAndNavigate(String groupName) async {
    await Future.wait([_groupDoneCompleter.future, _restaurantsCompleter.future]);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
          return RestaurantCards(restaurantChoices: restaurants, groupName: widget.groupName);
          }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waiting Page'),
      ),
      body: const Center(
        child:  CircularProgressIndicator(semanticsLabel: "Waiting for group members.",)           
        ),
    );
  }

}
