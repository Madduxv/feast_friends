import 'package:flutter/material.dart';
class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      color: Colors.deepPurpleAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
        buttonWidget(Icons.refresh, Colors.amber),
        buttonWidget(Icons.close, Colors.red),
        buttonWidget(Icons.star, Colors.blue),
        buttonWidget(Icons.favorite_outline_outlined, Colors.pink),
        ],
      ),
    );
  }
}

Widget buttonWidget(IconData icon, Color color) {
  return Container(
    height: 60,
    width: 60,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white,
      border: Border.all(color: color)
    ),
    child: Icon(icon,
    color: color,
    size: 30,),
  );
}