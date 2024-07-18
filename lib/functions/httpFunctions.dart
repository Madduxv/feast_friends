import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:what_to_eat_app/main.dart';
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
    final url = Uri.parse('${Config().baseUrl}/restaurant/requested_restaurants');
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
    final url = Uri.parse('${Config().baseUrl}/restaurant/requested_genres');
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
    final url = Uri.parse('${Config().baseUrl}/restaurant/request_genre');
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
    final url = Uri.parse('${Config().baseUrl}/restaurant/clear_genres');
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
}
