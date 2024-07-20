import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:what_to_eat_app/functions/alertFunction.dart';
import 'package:what_to_eat_app/functions/httpFunctions.dart';
import 'package:what_to_eat_app/functions/WebSocketService.dart';
import 'package:what_to_eat_app/utils/constants.dart';
import 'package:what_to_eat_app/widgets/appBar.dart';
import 'package:what_to_eat_app/widgets/bottomBar.dart';
import 'package:what_to_eat_app/config.dart';

import 'UserCompleteWaitingPage.dart';

class GenreCards extends StatefulWidget {
  const GenreCards({Key? key}): super(key: key);

  @override
  GenreCardsState createState() => GenreCardsState();
}

class GenreCardsState extends State<GenreCards> {
  late WebSocketService webSocketService;
  late WebSocketChannel channel;
  TextEditingController _controller = TextEditingController();
  String _receivedMessage = '';
  String name = "Maddux";
  String groupName = "Maddux's Group";

  List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  List<String> genreNames = [
    'American',
    'Chinese',
    'Italian',
    'Japanese',
    'Mexican',
    'Cajun'
  ];

  @override
  void initState(){
    super.initState();
    // webSocketService = WebSocketService('ws://${Config().baseUrl}/ws');
    webSocketService = WebSocketService('ws://10.0.2.2:8080/ws');
    channel = webSocketService.channel;
    channel.stream.listen((message) {
        setState(() {
            _receivedMessage = message;
            print(message);
            });
        });
    _joinGroup(groupName);

    for(int i = 0; i<genreNames.length; i++) {
      _swipeItems.add(SwipeItem(content: Content(text: genreNames[i]),
          likeAction: (){
            _requestGenre(genreNames[i].toUpperCase());
            // HttpFunctions.requestGenre(genreNames[i].toUpperCase());
            // actions(context, genreNames[i], 'Liked');
          },
          nopeAction: (){
            // actions(context, genreNames[i], 'Rejected');
          },
          superlikeAction: (){
            _requestGenre(genreNames[i].toUpperCase());
            // HttpFunctions.requestGenre(genreNames[i]);
            // actions(context, genreNames[i], 'Super Liked');
          }
      ));
    }
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    super.initState();
  }

  @override
  void dispose() {
    webSocketService.close();
    super.dispose();
  }

  void _joinGroup(groupName) {
    webSocketService.sendMessage('join', groupName);
  }

  void _requestGenre(genre) {
    webSocketService.sendMessage('addGenre', genre);
    print('Genre requested');
  }

  void _requestedGenres(genre) {
    webSocketService.sendMessage('getRequestedGenres', groupName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
            children: [
              const SizedBox(height: 70),
              const TopBar(),
              Expanded(child: Container(
                child: SwipeCards(
                  matchEngine: _matchEngine!,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage(genreImages[index]),
                              fit: BoxFit.cover),
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            genreNames[index],
                            style: const TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  onStackFinished: (){
                       _requestedGenres(groupName);
                       // HttpFunctions.getRequestedGenres();
                       Navigator.push(context, MaterialPageRoute(builder: (context) {
                           return const UserCompleteWaitingPage();
                       }));
                  },
                ),
              )),
              const BottomBar()
            ]
        ),
      ),
    );

  }
}

class Content{
  final String? text;
  Content({this.text});
}
