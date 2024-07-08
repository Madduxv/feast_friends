import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:what_to_eat_app/functions/alertFunction.dart';
import 'package:what_to_eat_app/functions/httpFunctions.dart';
import 'package:what_to_eat_app/utils/constants.dart';
import 'package:what_to_eat_app/widgets/appBar.dart';
import 'package:what_to_eat_app/widgets/bottomBar.dart';

class RestaurantCards extends StatefulWidget {
  const RestaurantCards({Key? key}): super(key: key);

  @override
  RestaurantCardState createState() => RestaurantCardState();
}

class RestaurantCardState extends State<RestaurantCards> {
  List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  List<String> restaurantNames = [
    'Burger King',
    'Copelands',
    'Mcdonalds',
    'Pokegeaux',
    'Texas Roadhouse'
  ];


  @override
  void initState(){
    for(int i = 0; i<restaurantNames.length; i++) {
      _swipeItems.add(SwipeItem(content: Content(text: restaurantNames[i]),
          likeAction: (){
            actions(context, restaurantNames[i], 'Liked');
          },
          nopeAction: (){
            actions(context, restaurantNames[i], 'Rejected');
          },
          superlikeAction: (){
            actions(context, restaurantNames[i], 'Super Liked');
          }
      ));
    }
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
            children: [
              SizedBox(height: 70),
              TopBar(),
              Expanded(child: Container(
                child: SwipeCards(
                  matchEngine: _matchEngine!,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage(restaurantImages[index]),
                              fit: BoxFit.cover),
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.all(20),
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
                    return ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('The List is over')));
                  },
                ),
              )),
              BottomBar()
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
