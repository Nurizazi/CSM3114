import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:school_management/main.dart';
import 'package:school_management/widgets/add_student.dart';
import 'package:school_management/widgets/add_teacher.dart';
import 'package:school_management/widgets/discipline_record.dart';
import 'package:school_management/widgets/student_results.dart';

class HomeScreen extends StatelessWidget {
  final List<String> images = [
    'images/education2.jpg',
    'images/education.jpg',
    'images/education3.jpeg',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('School Management App'),
          centerTitle: true,
          backgroundColor: Colors.amber,
        ),
        endDrawer: Drawer(
          child: Container(
            color: Colors.grey[900],
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.limeAccent,
                  ), //chatGpt for decoration drawer
                  child: Text(
                    'School Management',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                buildDrawerItem('Teacher', Icons.person, () {
                  navigateToPage(context, AddTeacher());
                }),
                buildDrawerItem('Student', Icons.people, () {
                  navigateToPage(context, AddStudent());
                }),
                buildDrawerItem('Record Discipline Case', Icons.assignment, () {
                  navigateToPage(context, RecordDiscipline());
                }),
                buildDrawerItem('Student Results', Icons.description, () {
                  navigateToPage(context, ManageResults());
                }),
                buildDrawerItem('Log out', Icons.exit_to_app, () {
                  navigateToPage(context, LoginPage());
                }),
              ],
            ),
          ),
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/background.jpg'),
                  fit: BoxFit.cover),
            ),
            height: 800,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CarouselSlider(
                    // reference for carouselSlider: https://pub.dev/packages/carousel_slider
                    options: CarouselOptions(
                      height: 250,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: Duration(milliseconds: 1000),
                      viewportFraction: 0.8,
                    ),
                    items: images.map((item) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(item), fit: BoxFit.fill),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.description,
                              color: Colors.brown,
                              size: 30,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Quality of School Management App',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        ListTile(
                          leading: Icon(
                            Icons.adb,
                            color: Colors.black,
                          ),
                          title: Text(
                            'One system for all school needs.',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.info,
                            color: Colors.black,
                          ),
                          title: Text(
                            'Essential student information when you need it.',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.add_chart,
                            color: Colors.black,
                          ),
                          title: Text(
                            'Whole-school performance analytics at the click of a button.',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.monitor,
                            color: Colors.black,
                          ),
                          title: Text(
                            'Monitor your school performance priorities.',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }

  Widget buildDrawerItem(String title, IconData icon, Function onTap) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      onTap: onTap as void Function(),
    );
  }

  void navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
