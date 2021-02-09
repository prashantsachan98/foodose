import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:foodose/models/recipe.dart';
import 'package:foodose/models/saved_recipe.dart';
import 'package:foodose/models/search.dart';
import 'package:foodose/view/meal_planner.dart';
import 'package:foodose/view/searchedRecipe.dart';
import 'package:http/http.dart' as http;
import './view/offline.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:io';
import './models/joke.dart';
import './models/ui_provider.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
//import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';

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

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
void main() async {
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  /*SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));*/
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(SavedRecipeAdapter());
  await Hive.openBox<SavedRecipe>('offline');

  runApp(Foodose());
}

class Foodose extends StatelessWidget {
  const Foodose({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UI()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.amberAccent[700],
        ),
        home: MyHomepage(),
        navigatorKey: navigatorKey,
      ),
    );
  }
}

class MyHomepage extends StatefulWidget {
  @override
  _MyHomepageState createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  Box box;
  // int _index = 0;
  Future<List<Recipe>> futureRecipe;
  Future<Joke> futureJoke;
  Future<SList> filter;
  String _textString;
  bool _folded = true;

  @override
  void initState() {
    filter = flist(_textString);
    super.initState();
    futureRecipe = fetchRandomRecipe();
    futureJoke = fetchJoke();
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
          Container(
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 1,
            child: Column(
              //padding: EdgeInsets.zero,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 15,
                  width: MediaQuery.of(context).size.width * 1,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                  child: FittedBox(
                    child: Card(
                      shadowColor: Colors.deepPurple,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Text(
                          'Hello prashant',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'poppins',
                              color: Colors.deepPurple),
                        ),
                      ),
                    ),
                  ),
                ),
                FutureBuilder<Joke>(
                  future: futureJoke,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data.joke);
                      return Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          snapshot.data.joke,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return CircularProgressIndicator();
                  },
                ),
                FutureBuilder(
                  future: futureRecipe,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: SingleChildScrollView(
                          // scrollDirection: Axis.horizontal,
                          //physics: NeverScrollableScrollPhysics(),
                          //shrinkWrap: true,
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          child: Column(
                            children: <Widget>[
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                child: getRecipeView(snapshot.data[0]),
                                elevation: 9,
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                child: getRecipeView(snapshot.data[1]),
                                elevation: 9,
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                child: getRecipeView(snapshot.data[2]),
                                elevation: 9,
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                child: getRecipeView(snapshot.data[3]),
                                elevation: 9,
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                child: getRecipeView(snapshot.data[4]),
                                elevation: 9,
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                child: getRecipeView(snapshot.data[5]),
                                elevation: 9,
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                child: getRecipeView(snapshot.data[6]),
                                elevation: 9,
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                child: getRecipeView(snapshot.data[7]),
                                elevation: 9,
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                child: getRecipeView(snapshot.data[8]),
                                elevation: 9,
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                child: getRecipeView(snapshot.data[9]),
                                elevation: 9,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Transform.scale(
                      scale: 1,
                      child: Container(
                        height: 300,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                            //strokeWidth: 20,
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),
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
                duration: Duration(milliseconds: 150),
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
                duration: Duration(milliseconds: 200),
                height: _folded ? 0 : 550,
                alignment: Alignment.centerRight,
                // height: 550,
                child: FutureBuilder<SList>(
                    future: flist(_textString),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          // padding: EdgeInsets.zero,
                          color: Colors.white70,
                          // color: Color.fromRGBO(1, 1, 1, 0.2),
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
                                    // borderRadius: BorderRadius.circular(30),
                                    ),
                                //color: Colors.white.withOpacity(0.9),
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

                                    //width:
                                    //  MediaQuery.of(context).size.width * 1,
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        snapshot.data.search[index].title
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
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
      bottomNavigationBar: Consumer<UI>(builder: (context, ui, child) {
        return Container(
          padding: EdgeInsets.zero,

          //  height: MediaQuery.of(context).size.height * 1 -
          //     MediaQuery.of(context).size.height * 0.8945,
          child: FloatingNavbar(
            //  padding: EdgeInsets.zero,
            iconSize: 20,
            backgroundColor: Colors.deepPurple,
            selectedItemColor: Colors.deepPurple,
            unselectedItemColor: Colors.white,
            onTap: (newValue) => setState(() {
              // _index = newValue;
              ui.index = newValue;

              if (ui.index == 1) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MealPlanner()));
              }

              if (ui.index == 2) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Offline()));
              }
              if (ui.index == 0) {
                Get.off(MyHomepage());
              }
            }),
            currentIndex: ui.index,
            items: [
              FloatingNavbarItem(
                icon: Icons.home_outlined,
                title: 'Home',
              ),
              FloatingNavbarItem(icon: Icons.food_bank, title: 'Meals'),
              FloatingNavbarItem(icon: Icons.save_rounded, title: 'saved'),
            ],
          ),
        );
      }),
    );
  }

  Widget getRecipeView(Recipe recipe) {
    /* _launchURL() async {
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
    }*/

    return Container(
        child: Stack(children: <Widget>[
      InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchedRecipe(recipe.id.toString())));
        },
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.elliptical(30, 30)),
              color: Colors.white10,
              boxShadow: kElevationToShadow[10],
              //gradient:
              //   LinearGradient(colors: [Colors.green, Colors.blue]),
              //borderRadius: BorderRadius.circular(100),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(
                    'https://spoonacular.com//recipeImages/${recipe.id.toString()}-312x231.jpg'),
                //fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            elevation: 0,
            child: Text(
              recipe.title,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 20,
              ),
            ),
          ),
        ]),
      ),
    ]));
  }
}

//transition
