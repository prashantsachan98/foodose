/*import 'dart:convert';
import '../models/joke.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

apiService() {
  final String _baseURL = "api.spoonacular.com";
  const String API_KEY = "254d7e3cb60949c7a71f3e329b3b555d";

  Future<Joke> fetchJoke() async {
    Map<String, String> parameter = {
      'apiKey': API_KEY,
    };
    Uri uri = Uri.https(
    _baseURL,
    '/food/jokes/random',
     parameter,
  );
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  try {
    var response = await http.get(uri, headers: headers);
    Map<String, dynamic> data = json.decode(response.body);
    Joke joke = Joke.fromJson(data);
    return joke;
  } catch (err) {
    throw err.toString();
  }


  }
}
*/
