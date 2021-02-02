import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
//import 'package:url_launcher/url_launcher.dart';

//searched recipe data
final String _baseURL = "api.spoonacular.com";
const String API_KEY2 = "3a3ad0eb28cb4dcba4fbf2fce12670b5";
Future<Recipe> fetchSearchedRecipe(String id) async {
  Map<String, String> parameters = {
    'apiKey': API_KEY2,
    'includeNutrition': 'false'
  };
  Uri uri = Uri.https(
    _baseURL,
    '/recipes/$id/information',
    parameters,
  );

  print(uri);
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  try {
    var response = await http.get(uri, headers: headers);
    final jsonResult = json.decode(response.body);
    Recipe recipe = Recipe.fromMap(jsonResult);
    print(recipe.title);
    return recipe;
  } catch (err) {
    throw err.toString();
  }
}

class SearchedRecipe extends StatefulWidget {
  final String id;
  SearchedRecipe(this.id);

  @override
  _SearchedRecipeState createState() => _SearchedRecipeState(id);
}

class _SearchedRecipeState extends State<SearchedRecipe> {
  String id;
  _SearchedRecipeState(this.id);

  Future<Recipe> futureSearchedRecipe;
  @override
  void initState() {
    super.initState();
    futureSearchedRecipe = fetchSearchedRecipe(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.green, Colors.blue]),
        ),
        alignment: Alignment.center,
        child: FutureBuilder(
          future: futureSearchedRecipe,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                      gradient:
                          LinearGradient(colors: [Colors.green, Colors.blue]),
                    ),
                  ),
                  Container(
                    // margin: EdgeInsets.all(20),
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width * 1,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      gradient:
                          LinearGradient(colors: [Colors.green, Colors.blue]),
                      //borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                        image: NetworkImage(snapshot.data.imgURL),
                        //fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Card(
                    elevation: 10,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 1,
                      child: Text(
                        snapshot.data.title,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
