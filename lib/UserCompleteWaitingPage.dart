import 'package:flutter/material.dart';
// import 'package:what_to_eat_app/functions/httpFunctions.dart';
import 'RestaurantCardsPage.dart';

class UserCompleteWaitingPage extends StatelessWidget {
  final List<String> genres;
  final List<String> restaurants;
  final String groupName;
  const UserCompleteWaitingPage({Key? key, required this.genres, required this.restaurants, required this.groupName}) : super(key: key);

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
                return RestaurantCards(restaurantChoices: restaurants, groupName: groupName);
            }));
          },
          child: const Text('Next'),
        ),
      ),
    );
  }
}
