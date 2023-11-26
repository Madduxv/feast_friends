import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:what_to_eat_app/widgets/appBar.dart';
import 'package:what_to_eat_app/widgets/bottomBar.dart';
//rename to feast friend

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}): super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  List<String> names = [ /* TODO */
      'John'
      'nathan'
      'mark'];

  @override
  void initState(){
    for(int i = 0; i<names.length; i++) {
      _swipeItems.add(SwipeItem(content: Content(text: names[i]),
      likeAction: (){},
      nopeAction: (){},
      superlikeAction: (){}
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
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(20),
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