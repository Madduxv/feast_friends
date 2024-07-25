
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'dart:async';
import 'package:swipe_cards/swipe_cards.dart';

import 'package:what_to_eat_app/functions/alertFunction.dart';
// import 'package:what_to_eat_app/functions/httpFunctions.dart';
import 'package:what_to_eat_app/functions/WebSocketService.dart';
import 'package:what_to_eat_app/utils/constants.dart';
import 'package:what_to_eat_app/widgets/appBar.dart';
import 'package:what_to_eat_app/widgets/bottomBar.dart';

class RestaurantCards extends StatefulWidget {
  final List<String> restaurantChoices;
  final String groupName;

  const RestaurantCards({Key? key, required this.restaurantChoices, required this.groupName}): super(key: key);

  @override
  RestaurantCardState createState() => RestaurantCardState();
}

class RestaurantCardState extends State<RestaurantCards> {
  late WebSocketService webSocketService;
  late WebSocketChannel channel;
  final Completer<void> _restaurantsCompleter = Completer<void>();
  dynamic _receivedMessage = '';

  List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;

  List<String> restaurantNames = [];
  List<String> restaurants = [];


  @override
  void initState(){
    super.initState();
    webSocketService = Provider.of<WebSocketService>(context, listen: false);
    webSocketService.messages.listen((message) {
        setState(() {
            _receivedMessage = jsonDecode(message);
            switch (_receivedMessage['contentType']) {
            case 'groupRestaurants':
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

    restaurantNames = widget.restaurantChoices;
    print(restaurantNames);
    for(int i = 0; i<restaurantNames.length; i++) {
      _swipeItems.add(SwipeItem(content: Content(text: restaurantNames[i]),
          likeAction: (){
            _requestRestaurant(restaurantNames[i]);
            actions(context, restaurantNames[i], 'Liked');
          },
          nopeAction: (){
            actions(context, restaurantNames[i], 'Rejected');
          },
          superlikeAction: (){
            _requestRestaurant(restaurantNames[i]);
            actions(context, restaurantNames[i], 'Super Liked');
          }
      ));
    }
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    // super.initState();
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
                  String? imagePath = restaurantImages[restaurantNames[index]];
                    return Container(
                      alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                          image: AssetImage(imagePath ?? 'assets/Zen.jpg'),
                              fit: BoxFit.cover),
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            restaurantNames[index],
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
                    fetchAndNavigate();
                  },
                ),
              )),
              const BottomBar()
            ]
        ),
      ),
    );

  }

  Future<void> _requestRestaurant(restaurant) async {
    webSocketService.sendMessage('addRestaurant', restaurant);
    print('Requesting restaurant');
  }

  Future<void> _requestedRestaurants(groupName) async {
    webSocketService.sendMessage('getRequestedRestaurants', groupName);
  }

  Future<ScaffoldFeatureController> fetchAndNavigate() async {
    _requestedRestaurants(widget.groupName);

    await Future.wait([_restaurantsCompleter.future]);
    print('restaurants: $restaurants');
    return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The List is over')));
  }
}


class Content{
  final String? text;
  Content({this.text});
}
