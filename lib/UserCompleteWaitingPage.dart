import 'package:flutter/material.dart';
import 'package:what_to_eat_app/functions/httpFunctions.dart';
import 'RestaurantCardsPage.dart';

class UserCompleteWaitingPage extends StatelessWidget {
  final List<String> genres;
  final List<String> restaurants;
  const UserCompleteWaitingPage({Key? key, required this.genres, required this.restaurants}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waiting Page'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {  
            Navigator.push(context, MaterialPageRoute(builder: (context) {
                return RestaurantCards(genres: genres, restaurants: restaurants);
            }));
          },
          child: const Text('Next'),
        ),
      ),
    );
  }
}
