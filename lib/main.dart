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
import 'dart:math';

//import 'views/description.dart';
//import './models/instruction.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/services.dart' show rootBundle;

//...

//  random recipe
final String _baseURL = "api.spoonacular.com";
const String API_KEY = "254d7e3cb60949c7a71f3e329b3b555d";

Future<List<Recipe>> fetchRandomRecipe() async {
  // Map<String, String> parameters = {
  //   'number': '5000',
  //  'apiKey': API_KEY,
  //};
  // Uri uri = Uri.https(
  // _baseURL,
  //'/recipes/random',
  //parameters,
  //);

  // print(uri);
  //Map<String, String> headers = {
  // HttpHeaders.contentTypeHeader: 'application/json',
  //};

  try {
    String data = await rootBundle.loadString('assets/load_json/recipe.json');
    var jsonResult = json.decode(data);
    var list = jsonResult['recipes'] as List;
    List<Recipe> dataList = list?.map((i) => Recipe.fromMap(i))?.toList() ?? [];
    print(dataList.length);
    return dataList;
  } catch (err) {
    throw err.toString();
  }
}

//description
/*Future<Stept> fetchStep() async {
  Map<String, String> parameter = {
    'apiKey': API_KEY,
    'stepBreakdown': 'false',
  };
  Uri uri = Uri.https(
    _baseURL,
    '/recipes/$id/analyzedInstructions',
    parameter,
  );
  print(uri);
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };
  try {
    var response = await http.get(uri, headers: headers);
    Map<String, dynamic> data = json.decode(response.body);
    //var list = data['steps'] as List;
    //List<Stept> dataList = list?.map((i) => Stept.fromJson(i))?.toList() ?? [];
    Stept stept = Stept.fromJson(data);
    print(data);

    return stept;
  } catch (err) {
    throw err.toString();
  }
}*/

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

Random random = new Random();
int randomNumber = random.nextInt(90);

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
  Future<List<Recipe>> futureRecipe;
  Future<Joke> futureJoke;
  // Future<Stept> futureStep;

  @override
  void initState() {
    super.initState();
    futureRecipe = fetchRandomRecipe();
    futureJoke = fetchJoke();

    // futureStep = fetchStep();
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
                onSearch: null,
                onItemFound: null,
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
            padding: EdgeInsets.all(0),
            color: Colors.white10,
            height: (MediaQuery.of(context).size.height * 1 -
                MediaQuery.of(context).size.height * 0.33),
            width: MediaQuery.of(context).size.width * 0.97,
            child: FutureBuilder(
              future: futureRecipe,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        getRecipeView(snapshot.data[randomNumber]),
                        getRecipeView(snapshot.data[randomNumber + 1]),
                        getRecipeView(snapshot.data[randomNumber + 2]),
                        getRecipeView(snapshot.data[randomNumber + 3]),
                        getRecipeView(snapshot.data[randomNumber + 4]),
                        getRecipeView(snapshot.data[randomNumber + 5]),
                        getRecipeView(snapshot.data[randomNumber + 6]),
                        getRecipeView(snapshot.data[randomNumber + 7]),
                        getRecipeView(snapshot.data[randomNumber + 8]),
                        getRecipeView(snapshot.data[randomNumber + 9]),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Transform.scale(
                  scale: 0.2,
                  child: CircularProgressIndicator(
                    strokeWidth: 20,
                  ),
                );
              },
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

  Widget getRecipeView(Recipe recipe) {
    _launchURL() async {
      final url = recipe.sourceUrl.toString();
      if (await canLaunch(url)) {
        launch(
          url,
          forceWebView: true,
          enableJavaScript: true,
        );
      } else {
        throw 'Could not launch $url';
      }
    }

    return Container(
      child: Stack(
        children: <Widget>[
          InkWell(
            onTap: _launchURL,
            splashColor: Color.fromRGBO(139, 0, 0, 1),
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 5,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(recipe.imgURL),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  padding: EdgeInsets.all(5),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Text(
                        recipe.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
