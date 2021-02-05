import 'package:flutter/material.dart';
import '../models/meal_plan.dart';
import 'package:http/http.dart' as http;
import './searchedRecipe.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'dart:ui';

//generate meal plan
final String _baseURL = "api.spoonacular.com";
const String API_KEY3 = "5d7b6cc60c0c41f89d54d1becb453300";
Future<MealPlan> fetchMealPlan(double calories, String diet) async {
  String calorie = calories.toString();
  print('api se data fetch kiye jaa rhe hain');
  Map<String, String> parameters = {
    'apiKey': API_KEY3,
    'timeFrame': '3',
    'targetCalories': calorie,
    'diet': diet
  };
  Uri uri = Uri.https(
    _baseURL,
    '/mealplanner/generate',
    parameters,
  );

  print(uri);
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  try {
    var response = await http.get(uri, headers: headers);
    final jsonResponse = json.decode(response.body);
    MealPlan mealPlanList = new MealPlan.fromJson(jsonResponse);
    print("generated meal title");
    print(mealPlanList.nutrients.carbohydrates);
    return mealPlanList;
  } catch (err) {
    throw err.toString();
  }
}

class MealRecipeList extends StatefulWidget {
  final double calories;
  final String diet;
  MealRecipeList(this.calories, this.diet);
  @override
  _MealRecipeListState createState() => _MealRecipeListState(calories, diet);
}

class _MealRecipeListState extends State<MealRecipeList> {
  List<String> _meals = ['Breakfast', 'Lunch', 'dinner'];
  final double calories;
  final String diet;
  Future<MealPlan> futureMealplan;
  @override
  void initState() {
    super.initState();
    futureMealplan = fetchMealPlan(calories, diet);
  }

  _MealRecipeListState(this.calories, this.diet);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureMealplan,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: Container(
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Card(
                      elevation: 10,
                      child: Column(
                        children: [
                          Card(
                            elevation: 10,
                            child: Text(
                              'Nutrients Value ',
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          Card(
                            elevation: 1,
                            margin: EdgeInsets.all(20),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Calories',
                                      style: TextStyle(fontSize: 30),
                                    ),
                                    Text(snapshot.data.nutrients.calories
                                        .toString())
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Carbohydrates',
                                      style: TextStyle(fontSize: 30),
                                    ),
                                    Text(snapshot.data.nutrients.carbohydrates
                                        .toString())
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Fat',
                                      style: TextStyle(fontSize: 30),
                                    ),
                                    Text(snapshot.data.nutrients.fat.toString())
                                  ],
                                )
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 10,
                      child: Text('Breakfast', style: TextStyle(fontSize: 30)),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchedRecipe(
                                    snapshot.data.meals[0].id.toString())));
                      },
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: MediaQuery.of(context).size.width * 1,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.elliptical(30, 30)),
                              color: Colors.white10,
                              boxShadow: kElevationToShadow[10],
                              //gradient:
                              //   LinearGradient(colors: [Colors.green, Colors.blue]),
                              //borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    'https://spoonacular.com//recipeImages/${snapshot.data.meals[0].id.toString()}-312x231.jpg'),
                                //fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: MediaQuery.of(context).size.width * 1,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            //color: Colors.redAccent,
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white54,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                snapshot.data.meals[0].title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 10,
                      child: Text('Lunch', style: TextStyle(fontSize: 30)),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchedRecipe(
                                    snapshot.data.meals[1].id.toString())));
                      },
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: MediaQuery.of(context).size.width * 1,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.elliptical(30, 30)),
                              color: Colors.white10,
                              boxShadow: kElevationToShadow[10],
                              //gradient:
                              //   LinearGradient(colors: [Colors.green, Colors.blue]),
                              //borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    'https://spoonacular.com//recipeImages/${snapshot.data.meals[1].id.toString()}-312x231.jpg'),
                                //fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: MediaQuery.of(context).size.width * 1,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            //color: Colors.redAccent,
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white54,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                snapshot.data.meals[1].title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 10,
                      child: Text('Dinner', style: TextStyle(fontSize: 30)),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchedRecipe(
                                    snapshot.data.meals[2].id.toString())));
                      },
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: MediaQuery.of(context).size.width * 1,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.elliptical(30, 30)),
                              color: Colors.white10,
                              boxShadow: kElevationToShadow[10],
                              //gradient:
                              //   LinearGradient(colors: [Colors.green, Colors.blue]),
                              //borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    'https://spoonacular.com//recipeImages/${snapshot.data.meals[2].id.toString()}-312x231.jpg'),
                                //fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: MediaQuery.of(context).size.width * 1,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            //color: Colors.redAccent,
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white54,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                snapshot.data.meals[2].title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}

/*Text(
                              _meals[index],
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Image.network(
                                'https://spoonacular.com//recipeImages/$id-312x231.jpg'),
                            Card(
                              child: Text(snapshot.data.meals[index].title),
                            ),
                            Card() */
