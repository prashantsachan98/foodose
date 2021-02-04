import 'package:flutter/material.dart';
import 'package:foodose/main.dart';
import '../models/meal_plan.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';

//generate meal plan
final String _baseURL = "api.spoonacular.com";
const String API_KEY3 = "5d7b6cc60c0c41f89d54d1becb453300";
Future<MealPlan> fetchMealPlan() async {
  print('step2');
  Map<String, String> parameters = {
    'apiKey': API_KEY3,
    'timeFrame': '1',
    //'targetCalories': '200',
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
    print(mealPlanList.meals[0].title);
    return mealPlanList;
  } catch (err) {
    throw err.toString();
  }
}

//widget

class MealPlanner extends StatefulWidget {
  @override
  _MealPlannerState createState() => _MealPlannerState();
}

class _MealPlannerState extends State<MealPlanner> {
  List<String> _diets = [
    //List of diets that lets spoonacular filter
    'None',
    'Gluten Free',
    'Ketogenic',
    'Lacto-Vegetarian',
    'Ovo-Vegetarian',
    'Vegan',
    'Pescetarian',
    'Paleo',
    'Primal',
    'Whole30',
  ];
  Future<MealPlan> futureMealPlan;
  double _sliderVal = 1;
  String _diet = 'None';
  int _index = 0;

  @override
  void initState() {
    print('step3');
    super.initState();
    futureMealPlan = fetchMealPlan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=353&q=80'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white60),
                child: Text(
                  'My Daily Meal Planner',
                  style: TextStyle(
                      fontSize: 30,
                      //color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                ),
                // height: 50,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                padding: EdgeInsets.symmetric(horizontal: 30),
                height: MediaQuery.of(context).size.height * 0.50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white60),
                //color: Colors.white,

                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: DropdownButtonFormField(
                        items: _diets.map((String priority) {
                          return DropdownMenuItem(
                            value: priority,
                            child: Text(
                              priority,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Diet',
                          labelStyle: TextStyle(fontSize: 18),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _diet = value;
                          });
                        },
                        value: _diet,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RichText(
                      text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(fontSize: 25),
                          children: [
                            TextSpan(
                                text: _sliderVal.truncate().toString(),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: 'cal',
                                style: TextStyle(fontWeight: FontWeight.w600)),
                          ]),
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbColor: Theme.of(context).primaryColor,
                        inactiveTrackColor: Colors.lightBlue[100],
                        trackHeight: 6,
                      ),
                      child: Slider(
                        min: 0,
                        max: 4500,
                        //  autofocus: true,
                        label: 'calories',
                        value: this._sliderVal,
                        onChanged: (double value) {
                          setState(() {
                            this._sliderVal = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    //FlatButton where onPressed() triggers a function called _searchMealPlan
                    FlatButton(
                      padding:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 8),
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'Search',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      //_searchMealPlan function is above the build method
                      onPressed: () {
                        fetchMealPlan();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.zero,

            //  height: MediaQuery.of(context).size.height * 1 -
            //     MediaQuery.of(context).size.height * 0.8945,
            child: FloatingNavbar(
              //  padding: EdgeInsets.zero,
              iconSize: 20,
              backgroundColor: Colors.deepPurple,
              selectedItemColor: Colors.deepPurple,
              unselectedItemColor: Colors.white,
              onTap: (int val) => setState(() {
                _index = val;
                if (_index == 0) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyHomepage()));
                }
              }),
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
        ],
      ),
    );
  }
}