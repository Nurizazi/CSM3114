import 'dart:convert';
import 'package:http/http.dart' as https;
import 'package:flutter/material.dart';
import 'package:school_management/main.dart';

void main() => runApp(MyApp());

class StudentResult {
  final String studentId;
  final String subject;
  final String marks;

  StudentResult({
    required this.studentId,
    required this.subject,
    required this.marks,
  });
}

class ManageResults extends StatefulWidget {
  @override
  _ManageResultsState createState() => _ManageResultsState();
}

class _ManageResultsState extends State<ManageResults> {
  List<StudentResult> results = [];
  TextEditingController _studentIdController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _marksController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _addResult() async {
    final url = Uri.https(
      'school-management-app-9ccc8-default-rtdb.asia-southeast1.firebasedatabase.app',
      'Result.json',
    );

    final Map<String, dynamic> userData = {
      'id': _studentIdController.text,
      'subject': _subjectController.text,
      'marks': _marksController.text
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

        await _loadResult();
      } else {
        // Handle errors
        print('Error registering user: ${response.statusCode}');
      }
    } catch (error) {
      // Handle exceptions
      print('Error: $error');
    }
  }

  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    final url = Uri.https(
      'school-management-app-9ccc8-default-rtdb.asia-southeast1.firebasedatabase.app',
      'Result.json',
    );

    try {
      final response = await https.get(url);

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);

        if (data != null && data is Map<String, dynamic>) {
          // Clear previous data
          results.clear();

          // Iterate through the map and add teachers to the list
          data.forEach((key, value) {
            if (value != null && value is Map<String, dynamic>) {
              // Check for null values before accessing properties
              results.add(StudentResult(
                studentId: value['id'] ?? '',
                subject: value['subject'] ?? '',
                marks: value['marks'] ?? '',
              ));
            }
          });

          setState(() {});
        } else {
          print('Error loading results: Invalid data Format');
        }
      } else {
        print('Error loading results: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _updateResults(int index) async {
    TextEditingController _updateIdController =
        TextEditingController(text: results[index].studentId);
    TextEditingController _updateSubjectController =
        TextEditingController(text: results[index].subject);
    TextEditingController _updateMarksController =
        TextEditingController(text: results[index].marks);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Result'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _updateIdController,
                decoration: InputDecoration(labelText: 'Student Id: '),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _updateSubjectController,
                decoration: InputDecoration(labelText: 'Subject: '),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _updateMarksController,
                decoration: InputDecoration(labelText: 'Marks: '),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              StudentResult updatedResult = StudentResult(
                studentId: _updateIdController.text,
                subject: _updateSubjectController.text,
                marks: _updateMarksController.text,
              );

              results[index] = updatedResult;

              final url = Uri.https(
                'school-management-app-9ccc8-default-rtdb.asia-southeast1.firebasedatabase.app',
                'Result/${results[index].studentId}.json',
              );

              try {
                final response = await https.patch(
                  url,
                  headers: {'Content-Type': 'application/json'},
                  body: json.encode({
                    'id': updatedResult.studentId,
                    'Subject': updatedResult.subject,
                    'Marks': updatedResult.marks,
                  }),
                );

                if (response.statusCode == 200) {
                  print('Result updated successfully');
                } else {
                  print('Result updating teacher: ${response.statusCode}');
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

  Future<void> _deleteResult(int index) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Result'),
        content: Text('Are you sure you want to delete this results?'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              final url = Uri.https(
                'school-management-app-9ccc8-default-rtdb.asia-southeast1.firebasedatabase.app',
                'Result/${results[index].toString()}.json',
              );

              try {
                final response = await https.delete(url);
                print(index);
                if (response.statusCode == 200) {
                  print('Results deleted successfully');
                } else {
                  print('Error deleting Results: ${response.statusCode}');
                }
              } catch (error) {
                print('Error: $error');
              }

              results.removeAt(index);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Student Results'),
          centerTitle: true,
          backgroundColor: Colors.amber,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  'Add Results',
                  style: TextStyle(fontSize: 20),
                ),
                content: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _studentIdController,
                        decoration: InputDecoration(
                            labelText: 'Student Id',
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.brown),
                            )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the student id...!";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _subjectController,
                        decoration: InputDecoration(
                            labelText: 'Subject',
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
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _marksController,
                        decoration: InputDecoration(
                            labelText: 'Marks',
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.brown),
                            )),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the marks...!";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _addResult();
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
                  SizedBox(height: 16),
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
                results.isEmpty
                    ? Center(child: Text('No Result was added'))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: results.length,
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
                                  'Student: ${results[index].studentId}',
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
                                      'ID: ${results[index].studentId}',
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
                                      'Subject: ${results[index].subject}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.numbers,
                                      color: Colors.amberAccent,
                                    ),
                                    title: Text(
                                      'Marks: ${results[index].marks}',
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
                                        onPressed: () => _updateResults(index),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () => _deleteResult(index),
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
