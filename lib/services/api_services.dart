import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/joke.dart';

class ApiService {
  static const String baseUrl = 'https://official-joke-api.appspot.com';

  // Метод за добивање на типовите на шеги
  static Future<List<String>> getJokeTypes() async {
    final response = await http.get(Uri.parse('$baseUrl/types'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Failed to load joke types');
    }
  }

  // Метод за добивање на шеги според тип
  static Future<List<Joke>> getJokesByType(String type) async {
    final response = await http.get(Uri.parse('$baseUrl/jokes/$type/ten'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((joke) => Joke.fromJson(joke)).toList();
    } else {
      throw Exception('Failed to load jokes for type $type');
    }
  }

  // Метод за добивање на рандом шега
  static Future<Joke> getRandomJoke() async {
    final response = await http.get(Uri.parse('$baseUrl/random_joke'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return Joke.fromJson(data);
    } else {
      throw Exception('Failed to load random joke');
    }
  }
}
