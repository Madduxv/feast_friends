import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:what_to_eat_app/main.dart';
import 'dart:convert';
import 'package:what_to_eat_app/config.dart';

// gotta love Google flavoured Java :)
class HttpFunctions {

  static Future<String> fetchData() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
    if (response.statusCode == 200) {
      print(response.body);
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<String>> getRequestedRestaurants() async {
    final url = Uri.parse('http://${Config().baseUrl}/api/restaurant/requested_restaurants');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print('Successfully fetched requested restaurants.');
        // Parse the response body to a list of strings
        List<dynamic> jsonResponse = jsonDecode(response.body);
        List<String> restaurantNames = jsonResponse.cast<String>();
        print(restaurantNames);
        return restaurantNames;
      } else {
        print('Failed to load requested genres. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching requested genres: $e');
    }
    return [];
  }

  static Future<String> getRequestedGenres() async {
    // if (!Config().isLoaded) {
    //   throw Exception('Configuration not loaded');
    // }
    final url = Uri.parse('http://${Config().baseUrl}/api/restaurant/requested_genres');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print('Successfully fetched requested genres.');
        print(response.body);
        return response.body;
      } else {
        print('Failed to load requested genres. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching requested genres: $e');
    }
    return '';
  }

  static Future<void> requestGenre(String genre) async {
    final url = Uri.parse('http://${Config().baseUrl}/api/restaurant/request_genre');
    try {
      final response = await http.post(url, body: genre);
      if (response.statusCode == 200) {
        print('Successfully fetched requested genres.');
      } else {
        print('Failed to request genre. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error requesting genre: $e');
    }
  }

  static Future<void> clearRequestedGenres() async {
    final url = Uri.parse('http://${Config().baseUrl}/api/restaurant/clear_genres');
    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        print('Requested genres cleared successfully');
      } else {
        print('Failed to clear requested genres. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error clearing requested genres: $e');
    }
  }

  static Future<void> addUserFriend(String user, String friend) async {
    final url = Uri.parse('http://${Config().baseUrl}/api/user/add_friend?user=$user&friend=$friend');
    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        print('Successfully added friend');
        debugPrint("");
      } else {
        print('Failed to add friend. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding friend: $e');
    }
  }

  static Future<List<String>> getUsersNames() async {
    final url = Uri.parse('http://${Config().baseUrl}/api/user/all_users_names');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print('Successfully fetched users names');
        // Parse the response body to a list of strings
        List<dynamic> jsonResponse = jsonDecode(response.body);
        List<String> usersNames = jsonResponse.cast<String>();
        print(usersNames);
        return usersNames;
      } else {
        print('Failed to load users names. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching users names: $e');
    }
    return [];
  }
  static Future<List<String>> getUsersFriends(String name) async {
    final url = Uri.parse('http://${Config().baseUrl}/api/user/get_friends?name=$name');
    try {
      final response = await http.get(url);
      print(response.body);
      if (response.statusCode == 200) {
        print('Successfully fetched users friends');
        // Parse the response body to a list of strings
        List<dynamic> jsonResponse = jsonDecode(response.body);
        List<String> friendsNames = jsonResponse.map((friend) => friend['name'] as String).toList();
        return friendsNames;
      } else {
        print('Failed to load users friends. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching users friends: $e');
    }
    return [];
  }
}
