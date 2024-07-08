import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:what_to_eat_app/functions/alertFunction.dart';
import 'package:what_to_eat_app/functions/httpFunctions.dart';
import 'package:what_to_eat_app/utils/constants.dart';
import 'package:what_to_eat_app/widgets/appBar.dart';
import 'package:what_to_eat_app/widgets/bottomBar.dart';

import 'RestaurantCardsPage.dart';
import 'UserCompleteWaitingPage.dart';

class GenreCards extends StatefulWidget {
  const GenreCards({Key? key}): super(key: key);

  @override
  GenreCardsState createState() => GenreCardsState();
}

class GenreCardsState extends State<GenreCards> {
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
    for(int i = 0; i<genreNames.length; i++) {
      _swipeItems.add(SwipeItem(content: Content(text: genreNames[i]),
          likeAction: (){
            // actions(context, genreNames[i], 'Liked');
          },
          nopeAction: (){
            // actions(context, genreNames[i], 'Rejected');
          },
          superlikeAction: (){
            // actions(context, genreNames[i], 'Super Liked');
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
                          image: DecorationImage(image: AssetImage(genreImages[index]),
                              fit: BoxFit.cover),
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.all(20),
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
                       Navigator.push(context, MaterialPageRoute(builder: (context) {
                           return const UserCompleteWaitingPage();
                       }));
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
