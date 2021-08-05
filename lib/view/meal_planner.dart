import 'package:flutter/material.dart';
import 'package:foodose/main.dart';
import 'package:foodose/models/ui_provider.dart';
import 'package:foodose/view/meal_plan_recipes.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
//
import 'offline.dart';

import 'offline.dart';

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
  //Future<MealPlan> futureMealPlan;
  double _sliderVal = 350;
  String _diet = 'None';
  // int _index = 0;

  @override
  void initState() {
    // futureMealPlan = fetchMealPlan();
    super.initState();
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
                image: AssetImage('assets/images/splash.jfif'),
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
                        min: 350,
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
                        MealRecipeList(_sliderVal, _diet);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MealRecipeList(
                                    this._sliderVal, this._diet)));
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
            child: Consumer<UI>(builder: (context, ui, child) {
              return FloatingNavbar(
                //  padding: EdgeInsets.zero,
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                iconSize: 20,
                backgroundColor: Color.fromRGBO(251, 156, 92, 1),
                selectedItemColor: Color.fromRGBO(251, 156, 92, 1),
                unselectedItemColor: Colors.white,
                onTap: (newValue) => setState(() {
                  // _index = newValue;
                  ui.index = newValue;

                  if (ui.index == 0) {
                    navigator.pop(_createRouteHome());
                  }
                  if (ui.index == 2) {
                    Get.off(Offline());
                  }
                }),
                currentIndex: ui.index,
                items: [
                  FloatingNavbarItem(
                    icon: Icons.home_outlined,
                    title: 'Home',
                  ),
                  FloatingNavbarItem(icon: Icons.food_bank, title: 'Meal'),
                  FloatingNavbarItem(icon: Icons.save_rounded, title: 'saved'),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

Route _createRouteHome() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => MyHomepage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
