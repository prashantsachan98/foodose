import 'package:flutter/material.dart';
import 'package:foodose/models/saved_recipe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

//import 'package:foodose/models/saved_recipe.dart';

//import '../models/recipe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../models/recipeid.dart';
import 'package:hive/hive.dart';
//import 'package:hive_flutter/hive_flutter.dart';
//import 'package:path_provider/path_provider.dart';
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
  String sTitle;
  int sId;

  Future<RecipeId> futureSearchedRecipe;

  @override
  void initState() {
    super.initState();
    futureSearchedRecipe = fetchSearchedRecipe(id);
  }

  void addRecipe(SavedRecipe data) {
    var box = Hive.box<SavedRecipe>('offline');

    box.add(data);
    //box.deleteFromDisk();
    print(box.getAt(1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text('Recipe', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromRGBO(251, 156, 92, 1),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder(
            future: futureSearchedRecipe,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                sTitle = snapshot.data.title;
                sId = snapshot.data.id;
                return Container(
                  color: Color.fromRGBO(255, 218, 185, 1),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),

                        //elevation: 7,
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          height: MediaQuery.of(context).size.height * 0.35,
                          width: MediaQuery.of(context).size.width * 1,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.elliptical(30, 30)),
                            color: Colors.white10,
                            boxShadow: kElevationToShadow[12],
                            //gradient:
                            //   LinearGradient(colors: [Colors.green, Colors.blue]),
                            //borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(snapshot.data.image),
                              //fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),

                        Card(
                          elevation: 0,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromRGBO(251, 156, 92, 1),
                                    width: 2)),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.center,
                            height: 40,
                            width: MediaQuery.of(context).size.width * 1,
                            child: FittedBox(
                              child: Text(snapshot.data.title,
                                  style: GoogleFonts.pacifico(
                                      fontSize: 20, letterSpacing: 0.6)),
                            ),
                          ),
                        ),

                        Card(
                          elevation: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Card(
                                elevation: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      //  boxShadow: kElevationToShadow[6],
                                      color: Colors.white),
                                  margin: EdgeInsets.all(5),
                                  // color: Colors.green,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  // width: MediaQuery.of(context).size.width * 1,
                                  child: Text('Ingredients',
                                      style:
                                          GoogleFonts.pacifico(fontSize: 20)),
                                ),
                              ),
                              Card(
                                elevation: 0,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Container(
                                    child: ListView.separated(
                                        padding: EdgeInsets.zero,
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                Divider(
                                                  height: 10,
                                                ),
                                        itemCount:
                                            snapshot.data.ingredients.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          int count = index + 1;
                                          return Text(
                                            '$count' +
                                                '.  ' +
                                                snapshot.data.ingredients[index]
                                                    .name,
                                            style: GoogleFonts.sansita(
                                              fontSize: 17,
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Card(
                          elevation: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Card(
                                  elevation: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        //  boxShadow: kElevationToShadow[6],
                                        color: Colors.white),
                                    margin: EdgeInsets.all(5),
                                    // color: Colors.green,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    // width: MediaQuery.of(context).size.width * 1,
                                    child: Text(
                                      'Instructions',
                                      style: GoogleFonts.pacifico(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Card(
                                  elevation: 0,
                                  child: ListView.separated(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      //padding: EdgeInsets.zero,
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              Divider(
                                                height: 10,
                                              ),
                                      itemCount: snapshot
                                          .data.instructions[0].steps.length,
                                      itemBuilder: (context, index) {
                                        int count = index + 1;
                                        return Text(
                                          '$count' +
                                              '.  ' +
                                              snapshot.data.instructions[0]
                                                  .steps[index].step,
                                          style: GoogleFonts.sansita(
                                              fontSize: 17, wordSpacing: 4),
                                        );
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Transform.scale(
                  scale: 0.01, child: CircularProgressIndicator());
            },
          ),
        ],
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          backgroundColor: Color.fromRGBO(251, 156, 92, 1),
          child: Icon(Icons.save),
          onPressed: () {
            print('l');
            addRecipe(
              SavedRecipe(title: sTitle, id: sId),
            );
            Scaffold.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.deepOrangeAccent,
              content: Text('saved'),
            ));
          },
        ),
      ),
    );
  }
}
