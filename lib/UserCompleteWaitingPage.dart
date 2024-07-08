import 'package:flutter/material.dart';
import 'package:what_to_eat_app/functions/httpFunctions.dart';
import 'RestaurantCardsPage.dart';

class UserCompleteWaitingPage extends StatelessWidget {
  const UserCompleteWaitingPage({Key? key}) : super(key: key);
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
                return const RestaurantCards();
            }));
          },
          child: const Text('Next'),
        ),
      ),
    );
  }
}
