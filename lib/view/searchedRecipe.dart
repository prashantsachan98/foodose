import 'package:flutter/material.dart';
//import '../models/recipe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../models/recipeid.dart';
//import 'package:url_launcher/url_launcher.dart';

//searched recipe data
final String _baseURL = "api.spoonacular.com";
const String API_KEY2 = "3a3ad0eb28cb4dcba4fbf2fce12670b5";
Future<RecipeId> fetchSearchedRecipe(String id) async {
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
    final jsonResponse = json.decode(response.body);
    RecipeId recipeId = new RecipeId.fromJson(jsonResponse);
    print('object');
    print(recipeId.instructions[0].steps[2].step);
    return recipeId;
    //var response = await http.get(uri, headers: headers);
    //final jsonResult = json.decode(response.body);
    //Recipe recipe = Recipe.fromMap(jsonResult);
    //print(recipe.title);
    //return recipe;
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

  Future<RecipeId> futureSearchedRecipe;
  @override
  void initState() {
    super.initState();
    futureSearchedRecipe = fetchSearchedRecipe(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //decoration: BoxDecoration(
        //gradient: LinearGradient(colors: [Colors.green, Colors.blue]),
        //),
        alignment: Alignment.center,
        child: FutureBuilder(
          future: futureSearchedRecipe,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.green, Colors.blue]),
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Card(
                      //elevation: 7,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width * 1,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(450),
                          color: Colors.white10,
                          boxShadow: kElevationToShadow[12],
                          //gradient:
                          //   LinearGradient(colors: [Colors.green, Colors.blue]),
                          //borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            image: NetworkImage(snapshot.data.image),
                            //fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.center,
                        height: 40,
                        width: MediaQuery.of(context).size.width * 1,
                        child: Text(
                          snapshot.data.title,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'poppins'),
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          snapshot.data.instructions[0].steps[2].step,
                          style: TextStyle(
                            //fontSize: 10,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
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
