import 'package:flutter/material.dart';
import 'package:foodose/main.dart';
import 'package:foodose/models/ui_provider.dart';
import 'package:foodose/view/searchedRecipe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
//import 'package:hive_flutter/hive_flutter.dart';
import '../models/saved_recipe.dart';
import 'package:provider/provider.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import './meal_planner.dart';
import 'package:get/get.dart';

class Offline extends StatefulWidget {
  @override
  _OfflineState createState() => _OfflineState();
}

class _OfflineState extends State<Offline> {
  var box = Hive.box<SavedRecipe>('offline');
  int length;
  @override
  void initState() {
    super.initState();
    length = box.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text('saved Recipe', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromRGBO(251, 156, 92, 1),
      ),
      //body: _buildListview()
      body: Container(
        color: Color.fromRGBO(255, 218, 185, 1),
        child: ListView.builder(
          itemCount: box.length,
          itemBuilder: (context, index) {
            final boxdata = box.getAt(index);
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SearchedRecipe(boxdata.id.toString())));
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Text(
                    boxdata.title,
                    style: GoogleFonts.pacifico(),
                  ),
                  trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        print(index);
                        box.deleteAt(index);
                        setState(() {
                          length = box.length;
                        });
                      }),
                ),
              ),
            );
          },
        ),
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.zero,
        color: Color.fromRGBO(255, 218, 185, 1),

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
              if (ui.index == 1) {
                Get.off(MealPlanner());
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
