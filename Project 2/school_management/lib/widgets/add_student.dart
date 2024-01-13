import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_management/main.dart';
import 'package:http/http.dart' as https;

void main() => runApp(MyApp());

class Student {
  final String id;
  final String name;
  final String grade;

  Student({
    required this.id,
    required this.name,
    required this.grade,
  });
}

class AddStudent extends StatefulWidget {
  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _gradeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<Student> students = [];
  @override
  void initState() {
    super.initState();
    _loadStudent();
  }

  Future<void> _loadStudent() async {
    final url = Uri.https(
      'school-management-app-9ccc8-default-rtdb.asia-southeast1.firebasedatabase.app',
      'Student.json',
    );

    try {
      final response = await https.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Clear previous data
        students.clear();

        // Iterate through the map and add teachers to the list
        data.forEach((key, value) {
          if (value != null && value is Map<String, dynamic>) {
            // Check for null values before accessing properties
            students.add(Student(
              id: value['id'] ?? '',
              name: value['name'] ?? '',
              grade: value['grade'] ?? '',
            ));
          }
        });

        setState(() {});
      } else {
        print('Error loading students: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _AddStudent() async {
    final url = Uri.https(
      'school-management-app-9ccc8-default-rtdb.asia-southeast1.firebasedatabase.app',
      'Student.json',
    );

    final Map<String, dynamic> userData = {
      'id': _idController.text,
      'name': _nameController.text,
      'grade': _gradeController.text,
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

        await _loadStudent();
      } else {
        // Handle errors
        print('Error registering user: ${response.statusCode}');
      }
    } catch (error) {
      // Handle exceptions
      print('Error: $error');
    }
  }

  Future<void> _updateStudent(int index) async {
    TextEditingController _updateIdController =
        TextEditingController(text: students[index].id);
    TextEditingController _updateNameController =
        TextEditingController(text: students[index].name);
    TextEditingController _updateGradeController =
        TextEditingController(text: students[index].grade);

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
                controller: _updateGradeController,
                decoration: InputDecoration(labelText: 'Grade: '),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Student updatedStudent = Student(
                id: _updateIdController.text,
                name: _updateNameController.text,
                grade: _updateGradeController.text,
              );

              students[index] = updatedStudent;

              final url = Uri.https(
                'school-management-app-9ccc8-default-rtdb.asia-southeast1.firebasedatabase.app',
                'Student/${students[index].toString()}.json',
              );

              try {
                final response = await https.patch(
                  url,
                  headers: {'Content-Type': 'application/json'},
                  body: json.encode({
                    'id': updatedStudent.id,
                    'name': updatedStudent.name,
                    'grade': updatedStudent.grade,
                  }),
                );

                if (response.statusCode == 200) {
                  print('Student updated successfully');
                } else {
                  print('Error updating student: ${response.statusCode}');
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

  Future<void> _deleteStudent(int index) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Student'),
        content: Text('Are you sure you want to delete this student?'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              final url = Uri.https(
                'school-management-app-9ccc8-default-rtdb.asia-southeast1.firebasedatabase.app',
                'Student/${students[index].toString()}.json',
              );

              try {
                final response = await https.delete(url);
                print(index);
                if (response.statusCode == 200) {
                  print('Student deleted successfully');
                } else {
                  print('Error deleting student: ${response.statusCode}');
                }
              } catch (error) {
                print('Error: $error');
              }

              students.removeAt(index);
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
          title: Text('Add Student'),
          centerTitle: true,
          backgroundColor: Colors.amber,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  'Add Student',
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
                        controller: _gradeController,
                        decoration: InputDecoration(
                            labelText: 'Grade: ',
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.brown),
                            )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the grade...!";
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
                        _AddStudent();
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
                students.isEmpty
                    ? Center(child: Text('No student added yet'))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: students.length,
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
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: ExpansionTile(
                                title: Text(
                                  'Students: ${students[index].id}',
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
                                      'ID: ${students[index].id}',
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
                                      'Name: ${students[index].name}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.grade,
                                      color: Colors.amberAccent,
                                    ),
                                    title: Text(
                                      'Grade: ${students[index].grade}',
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
                                        onPressed: () => _updateStudent(index),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () => _deleteStudent(index),
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
