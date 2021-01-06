import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
//import 'package:flutter/services.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:foodose/models/recipe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import './models/joke.dart';

// recipe

final String _baseURL = "api.spoonacular.com";
const String API_KEY = "254d7e3cb60949c7a71f3e329b3b555d";

Future<Recipe> fetchRecipe(String id) async {
  Map<String, String> parameters = {
    'includeNutrition': 'false',
    'apiKey': API_KEY,
  };
  Uri uri = Uri.https(
    _baseURL,
    '/recipes/$id/information',
    parameters,
  );
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  try {
    var response = await http.get(uri, headers: headers);
    Map<String, dynamic> data = json.decode(response.body);
    Recipe recipe = Recipe.fromMap(data);
    return recipe;
  } catch (err) {
    throw err.toString();
  }
}

//joke

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

void main() {
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  // statusBarColor: Colors.transparent,
  // ));
  runApp(Foodose());
}

class Foodose extends StatelessWidget {
  const Foodose({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomepage(),
    );
  }
}

class MyHomepage extends StatefulWidget {
  @override
  _MyHomepageState createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  int _index = 0;
  final id = '716429';
  Future<Recipe> futureRecipe;
  Future<Joke> futureJoke;

  @override
  void initState() {
    super.initState();
    futureRecipe = fetchRecipe(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueGrey,
      /* appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Foodose',
          style: TextStyle(color: CupertinoColors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),*/
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Container(
            height: 80,
            width: 400,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchBar(
                hintText: 'search',
                searchBarStyle:
                    SearchBarStyle(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          Container(
              height: 55,
              color: Colors.redAccent,
              child: FutureBuilder<Joke>(
                future: futureJoke,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data.joke);
                    log(snapshot.data.joke);
                    return Text(snapshot.data.joke);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return CircularProgressIndicator();
                },
              )),
          Container(
            color: Colors.white10,
            padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
            height: 480.0,
            width: 270,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 180,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20)),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    elevation: 5,
                    child: Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: FutureBuilder<Recipe>(
                            future: futureRecipe,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Image.network(snapshot.data.imgURL);
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }
                              return CircularProgressIndicator();
                            },
                          ),
                          //Image.asset('assets/images/food.jpg'),
                        ),
                        Container(
                            padding: EdgeInsets.all(20),
                            alignment: AlignmentDirectional.bottomStart,
                            child: FutureBuilder<Recipe>(
                              future: futureRecipe,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(snapshot.data.title);
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                return CircularProgressIndicator();
                              },
                            )
                            //Text(
                            //'recipie name',
                            //style: TextStyle(color: Colors.white, fontSize: 30),
                            ),
                        Card(
                          elevation: 0,
                          child: InkWell(
                            splashColor: Colors.white,
                            onTap: () {},
                          ),
                          color: Color.fromRGBO(0, 0, 0, 0),
                        ),
                      ],
                    ),
                  ),
                );
              },
              scrollDirection: Axis.vertical,
            ),
          )
        ],
      ),
      bottomNavigationBar: FloatingNavbar(
        iconSize: 20,
        backgroundColor: CupertinoColors.white,
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.grey,
        onTap: (int val) => setState(() => _index = val),
        currentIndex: _index,
        items: [
          FloatingNavbarItem(
            icon: Icons.recent_actors_sharp,
            title: 'recent',
          ),
          FloatingNavbarItem(icon: Icons.save_rounded, title: 'saved'),
          FloatingNavbarItem(icon: Icons.recent_actors, title: 'recent'),
        ],
      ),
    );
  }
}
