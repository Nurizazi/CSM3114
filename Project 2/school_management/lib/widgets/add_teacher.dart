import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_management/main.dart';
import 'package:http/http.dart' as https;

void main() => runApp(MyApp());

class Teacher {
  final String teacher;
  final String id;
  final String name;
  final String subject;

  Teacher(
      {required this.id,
      required this.name,
      required this.subject,
      required this.teacher});
}

class AddTeacher extends StatefulWidget {
  @override
  _AddTeacherState createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _subjectController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<Teacher> teachers = [];
  @override
  void initState() {
    super.initState();
    _loadTeacher();
  }

  Future<void> _loadTeacher() async {
    final url = Uri.https(
      'school-management-app-9ccc8-default-rtdb.asia-southeast1.firebasedatabase.app',
      'Teacher.json',
    );

    try {
      final response = await https.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Clear previous data
        teachers.clear();

        // Iterate through the map and add teachers to the list
        data.forEach((key, value) {
          teachers.add(Teacher(
            teacher: key,
            id: value['id'],
            name: value['name'],
            subject: value['subject'],
          ));
        });

        setState(() {});
      } else {
        print('Error loading teachers: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _AddTeacher() async {
    final url = Uri.https(
      'school-management-app-9ccc8-default-rtdb.asia-southeast1.firebasedatabase.app',
      'Teacher.json',
    );

    final Map<String, dynamic> userData = {
      'id': _idController.text,
      'name': _nameController.text,
      'subject': _subjectController.text,
    };

    try {
      final response = await https.post(
        url,
        body: json.encode(userData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Successful registration
        print('User registered successfully');

        await _loadTeacher();
      } else {
        // Handle errors
        print('Error registering user: ${response.statusCode}');
      }
    } catch (error) {
      // Handle exceptions
      print('Error: $error');
    }
  }

  Future<void> _updateTeacher(int index) async {
    TextEditingController _updateIdController =
        TextEditingController(text: teachers[index].id);
    TextEditingController _updateNameController =
        TextEditingController(text: teachers[index].name);
    TextEditingController _updateSubjectController =
        TextEditingController(text: teachers[index].subject);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Teacher'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _updateIdController,
                decoration: InputDecoration(labelText: 'Id: '),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _updateNameController,
                decoration: InputDecoration(labelText: 'Name: '),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _updateSubjectController,
                decoration: InputDecoration(labelText: 'Subject: '),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Teacher updatedTeacher = Teacher(
                id: _updateIdController.text,
                name: _updateNameController.text,
                subject: _updateSubjectController.text,
                teacher: teachers[index].teacher,
              );

              teachers[index] = updatedTeacher;

              final url = Uri.https(
                'school-management-app-9ccc8-default-rtdb.asia-southeast1.firebasedatabase.app',
                'Teacher/${teachers[index].teacher}.json',
              );

              try {
                final response = await https.patch(
                  url,
                  headers: {'Content-Type': 'application/json'},
                  body: json.encode({
                    'id': updatedTeacher.id,
                    'name': updatedTeacher.name,
                    'subject': updatedTeacher.subject,
                  }),
                );

                if (response.statusCode == 200) {
                  print('Teacher updated successfully');
                } else {
                  print('Error updating teacher: ${response.statusCode}');
                }
              } catch (error) {
                print('Error: $error');
              }

              setState(() {});
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.lime,
              onPrimary: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text('Update'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.lime,
              onPrimary: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTeacher(int index) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Teacher'),
        content: Text('Are you sure you want to delete this teacher?'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              final url = Uri.https(
                'school-management-app-9ccc8-default-rtdb.asia-southeast1.firebasedatabase.app',
                'Teacher/${teachers[index].teacher}.json',
              );

              try {
                final response = await https.delete(url);
                print(index);
                if (response.statusCode == 200) {
                  print('Teacher deleted successfully');
                } else {
                  print('Error deleting teacher: ${response.statusCode}');
                }
              } catch (error) {
                print('Error: $error');
              }

              teachers.removeAt(index);
              setState(() {});
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.lime,
              onPrimary: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text('Delete'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.lime,
              onPrimary: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Teacher'),
          centerTitle: true,
          backgroundColor: Colors.amber,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  'Add Teacher',
                  style: TextStyle(fontSize: 20),
                ),
                content: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _idController,
                        decoration: InputDecoration(
                            labelText: 'Id: ',
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.brown),
                            )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the id...!";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                            labelText: 'Name: ',
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.brown),
                            )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the name...!";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _subjectController,
                        decoration: InputDecoration(
                            labelText: 'Subject: ',
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.brown),
                            )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the subject...!";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 32,
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _AddTeacher();
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.lime,
                        onPrimary: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6))),
                    child: Text('Add'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.lime,
                        onPrimary: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6))),
                    child: Text('Cancel'),
                  ),
                ],
              ),
            );
          },
          backgroundColor: Colors.lime,
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/aesthetic.jpg'), fit: BoxFit.cover),
          ),
          height: 800,
          child: SingleChildScrollView(
            child: Column(
              children: [
                teachers.isEmpty
                    ? Center(child: Text('No teacher added yet'))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: teachers.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: BorderSide(color: Colors.amberAccent),
                              ),
                              elevation: 1.0,
                              margin: EdgeInsets.symmetric(vertical: 15),
                              child: ExpansionTile(
                                title: Text(
                                  'Teacher: ${teachers[index].id}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      Icons.person,
                                      color: Colors.amberAccent,
                                    ),
                                    title: Text(
                                      'ID: ${teachers[index].id}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.account_circle,
                                      color: Colors.amberAccent,
                                    ),
                                    title: Text(
                                      'Name: ${teachers[index].name}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.book,
                                      color: Colors.amberAccent,
                                    ),
                                    title: Text(
                                      'Subject: ${teachers[index].subject}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () => _updateTeacher(index),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () => _deleteTeacher(index),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
              ],
            ),
          ),
        ));
  }
}
