import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

import 'package:what_to_eat_app/config.dart';

class WebSocketService {

  final WebSocketChannel channel;

  WebSocketService(String url)
      : channel = WebSocketChannel.connect(Uri.parse(url));

  void close() {
    channel.sink.close();
  }

  void sendMessage(String action, String content) {
    final message = jsonEncode({
      'action': action,
      'content': content,
    });
    channel.sink.add(message);
  }

  // static void createGroup(String name) {
  //   sendMessage('join', '${name}s group');
  // }
  //
  // static void requestGenre(String genre) {
  //   sendMessage('addGenre', genre.toUpperCase());
  // }
  //
  // static void getRequestedRestaurants(String groupName) {
  //   sendMessage('getRequestedRestaurants', groupName);
  // }
  //
  // static void getRequestedGenres(String groupName) {
  //   sendMessage('getRequestedRestaurants', groupName);
  // }
  //
  // static void broadcastMessage(String message) {
  //   sendMessage('message', message);
  // }
}
