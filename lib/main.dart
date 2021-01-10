import 'dart:ui';

import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/services.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:foodose/models/recipe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import './models/joke.dart';

// recipe

final String _baseURL = "api.spoonacular.com";
const String API_KEY = "254d7e3cb60949c7a71f3e329b3b555d";

Future<Recipe> fetchRecipe() async {
  Map<String, String> parameters = {
    'apiKey': API_KEY,
  };
  Uri uri = Uri.https(
    _baseURL,
    '/recipes/random',
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
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
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
      title: 'Custom Fonts',
      // Set Raleway as the default app font.
      theme: ThemeData(fontFamily: 'OpenSans'),
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
  Future<Recipe> futureRecipe;
  Future<Joke> futureJoke;

  @override
  void initState() {
    super.initState();
    futureRecipe = fetchRecipe();
    futureJoke = fetchJoke();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.12,
            width: MediaQuery.of(context).size.width * 1,
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
              height: MediaQuery.of(context).size.height * 0.07,
              color: Colors.white10,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: FutureBuilder<Joke>(
                future: futureJoke,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data.joke);
                    return Text(
                      snapshot.data.joke,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return CircularProgressIndicator();
                },
              )),
          Container(
            color: Colors.white10,
            height: (MediaQuery.of(context).size.height * 1 -
                MediaQuery.of(context).size.height * 0.36),
            child: ListView.builder(
              padding: EdgeInsets.only(top: 0.0),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  height: MediaQuery.of(context).size.height * 0.32,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        margin: EdgeInsets.symmetric(vertical: 4),
                        //borderRadius: BorderRadius.circular(20.0),

                        /*  child: FutureBuilder<Recipe>(
                          future: futureRecipe,
                          builder: (context, index) {
                            if (index.hasData) {
                              return Image.network(
                                index.data.imgURL,
                                fit: BoxFit.fill,
                              );
                            } else if (index.hasError) {
                              return Text("${index.error}");
                            }
                            return CircularProgressIndicator();
                          },
                        ),*/
                        //Image.asset('assets/images/food.jpg'),
                      ),
                      Container(
                          alignment: AlignmentDirectional.bottomCenter,
                          child: FutureBuilder<Recipe>(
                            future: futureRecipe,
                            builder: (context, index) {
                              if (index.hasData) {
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                          colors: [Colors.green, Colors.blue])),
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Text(
                                    index.data.id.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans',
                                      color: Colors.white70,
                                    ),
                                  ),
                                );
                              } else if (index.hasError) {
                                return Text("${index.error}");
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
                );
              },
              scrollDirection: Axis.vertical,
            ),
          )
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: MediaQuery.of(context).size.height * 1 -
            MediaQuery.of(context).size.height * 0.8945,
        child: FloatingNavbar(
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
      ),
    );
  }
}
