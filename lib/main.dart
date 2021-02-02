import 'dart:ui';

//import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/services.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:foodose/models/recipe.dart';
import 'package:foodose/models/search.dart';
import 'package:foodose/view/searchedRecipe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import './models/joke.dart';
import 'package:easy_debounce/easy_debounce.dart';

//import 'views/description.dart';
//import './models/instruction.dart';
import 'package:url_launcher/url_launcher.dart';

//...

//  random recipe
final String _baseURL = "api.spoonacular.com";
const String API_KEY = "254d7e3cb60949c7a71f3e329b3b555d";
const String API_KEY1 = "9adf2703bfd44be886441b6fea0d49be";
const String API_KEY2 = "3a3ad0eb28cb4dcba4fbf2fce12670b5";

//search
Future<SList> flist(String text) async {
  Map<String, String> parameter = {
    'apiKey': API_KEY,
    'number': '10',
    'query': text,
  };
  Uri uri = Uri.https(
    _baseURL,
    '/recipes/autocomplete',
    parameter,
  );
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  try {
    var response = await http.get(uri, headers: headers);
    var jsonResult = json.decode(response.body);
    SList sList = SList.fromJson(jsonResult);
    int i = 0;
    while (i < 9) {
      print(sList.search[i].title);
      i++;
    }
    return sList;
  } catch (err) {
    throw err.toString();
  }
}

Future<List<Recipe>> fetchRandomRecipe() async {
  Map<String, String> parameters = {
    'number': '10',
    'apiKey': API_KEY1,
  };
  Uri uri = Uri.https(
    _baseURL,
    '/recipes/random',
    parameters,
  );

  print(uri);
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  try {
    var response = await http.get(uri, headers: headers);
    Map<String, dynamic> jsonResult = json.decode(response.body);
    var list = jsonResult['recipes'] as List;
    List<Recipe> dataList = list?.map((i) => Recipe.fromMap(i))?.toList() ?? [];
    return dataList;
  } catch (err) {
    throw err.toString();
  }
}

//joke

Future<Joke> fetchJoke() async {
  Map<String, String> parameter = {
    'apiKey': API_KEY1,
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
  //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
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
  Future<SList> filter;
  String _textString = '';
  bool _folded = true;

  @override
  void initState() {
    super.initState();
    futureRecipe = fetchRandomRecipe();
    futureJoke = fetchJoke();
    filter = flist(_textString);
  }

  void doSomething(String text) {
    setState(() {
      // _folded = !_folded;
      _textString = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: Colors.blueGrey,
      /*  appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Foodose',
          style: TextStyle(color: CupertinoColors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'search',
            color: Colors.black,
            onPressed: () async {},
          )
        ],
      ),*/
      body: Stack(
        alignment: Alignment.centerRight,
        children: [
          ListView(
            padding: EdgeInsets.zero,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: 20,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.green, Colors.blue]),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.green, Colors.blue]),
                ),
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                height: 70,
                child: Text(
                  'Hello Prashant ',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'poppins',
                      //backgroundColor: Colors.teal,
                      color: Colors.white),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.green, Colors.blue]),
                ),
                // height: MediaQuery.of(context).size.height * 0.07,
                //color: Colors.white10,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: FutureBuilder<Joke>(
                  future: futureJoke,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data.joke);
                      return Text(
                        snapshot.data.joke,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.green, Colors.blue]),
                ),
                //color: Colors.white10,
                height: (MediaQuery.of(context).size.height * 1 -
                    MediaQuery.of(context).size.height * 0.25),
                width: MediaQuery.of(context).size.width * 0.97,
                child: FutureBuilder(
                  future: futureRecipe,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        child: Column(
                          children: <Widget>[
                            getRecipeView(snapshot.data[0]),
                            getRecipeView(snapshot.data[1]),
                            getRecipeView(snapshot.data[2]),
                            getRecipeView(snapshot.data[3]),
                            getRecipeView(snapshot.data[4]),
                            getRecipeView(snapshot.data[5]),
                            getRecipeView(snapshot.data[6]),
                            getRecipeView(snapshot.data[7]),
                            getRecipeView(snapshot.data[8]),
                            getRecipeView(snapshot.data[9]),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              AnimatedContainer(
                //alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 15),
                duration: Duration(milliseconds: 300),
                width: _folded ? 56 : MediaQuery.of(context).size.width * 1,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: Colors.white,
                  boxShadow: kElevationToShadow[6],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 16),
                        child: !_folded
                            ? TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp('[a-zA-Z]'),
                                  ),
                                ],
                                onChanged: (text) {
                                  EasyDebounce.debounce(
                                    'my-debouncer', // <-- An ID for this particular debouncer
                                    Duration(
                                        milliseconds:
                                            500), // <-- The debounce duration
                                    () => doSomething(text),
                                  );
                                },
                                decoration: InputDecoration(
                                    hintText: 'Search',
                                    hintStyle:
                                        TextStyle(color: Colors.blue[300]),
                                    border: InputBorder.none),
                              )
                            : null,
                      ),
                    ),
                    Container(
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(_folded ? 32 : 0),
                            topRight: Radius.circular(32),
                            bottomLeft: Radius.circular(_folded ? 32 : 0),
                            bottomRight: Radius.circular(32),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(
                              _folded ? Icons.search : Icons.close,
                              color: Colors.blue[900],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _folded = !_folded;
                              _textString = null;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                height: _folded ? 0 : 550,
                alignment: Alignment.centerRight,
                // height: 550,
                child: FutureBuilder<SList>(
                    future: flist(_textString),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Colors.green, Colors.blue])),
                          child: ListView.separated(
                            //   padding: EdgeInsets.zero,
                            separatorBuilder:
                                (BuildContext context, int index) => Divider(
                              height: 0,
                            ),
                            itemCount: 9,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [Colors.green, Colors.blue])),
                                // color: Colors.white.withOpacity(0.9),
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                height: 58,
                                child: Material(
                                  child: InkWell(
                                    splashColor: Colors.redAccent,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SearchedRecipe(snapshot
                                                    .data.search[index].id
                                                    .toString())),
                                      );
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      // color: Colors.white,
                                      alignment: Alignment.centerLeft,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(0),
                                        gradient: LinearGradient(colors: [
                                          Colors.red,
                                          Colors.purple
                                        ]),
                                        boxShadow: kElevationToShadow[6],
                                      ),
                                      //width:
                                      //  MediaQuery.of(context).size.width * 1,
                                      child: Text(
                                        snapshot.data.search[index].title
                                            .toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    }),
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.green, Colors.blue]),
        ),
        //  height: MediaQuery.of(context).size.height * 1 -
        //     MediaQuery.of(context).size.height * 0.8945,
        child: FloatingNavbar(
          //  padding: EdgeInsets.zero,
          iconSize: 20,
          backgroundColor: Colors.deepPurple,
          selectedItemColor: Colors.greenAccent,
          unselectedItemColor: Colors.white,
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
