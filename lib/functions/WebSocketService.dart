// import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'dart:async';

// import 'package:what_to_eat_app/config.dart';

class WebSocketService {

  final String url;
  late WebSocketChannel channel;
  final _controller = StreamController<String>.broadcast();

  WebSocketService(this.url) {
    _connect();
  }

void _connect() {
    channel = WebSocketChannel.connect(Uri.parse(url));
    channel.stream.listen(
      (message) {
        _controller.add(message);
      },
      onDone: () {
        // Reconnect if the connection is closed
        print('Disconnected from WebSocket. Trying to reconnect...');
        _connect();
      },
      onError: (error) {
        print('WebSocket error: $error');
        // Handle error if necessary
      },
    );
  }

  Stream<String> get messages => _controller.stream;

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
