import 'package:flutter/material.dart';

class MySearchBar extends StatefulWidget {
  final Function(String) onQueryChanged;

  MySearchBar({required this.onQueryChanged});

  @override
  _MySearchBarState createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: widget.onQueryChanged,
        decoration: const InputDecoration(
          hintText: 'Search...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
      ),
    );
  }
}

