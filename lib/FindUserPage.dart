import 'package:flutter/material.dart';
import 'package:what_to_eat_app/widgets/searchBar.dart';
import 'package:what_to_eat_app/functions/httpFunctions.dart';

class FindUserPage extends StatefulWidget {
  const FindUserPage({Key? key}): super(key: key);

  @override
  FindUserPageState createState() => FindUserPageState();
}


class FindUserPageState extends State<FindUserPage> {
  List<String> data = [];
  List<String> searchResults = [];
  String name = 'Maddux';

  @override
  void initState() {
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
