import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_management/main.dart';
import 'package:http/http.dart' as https;

void main() => runApp(MyApp());

class DisciplineRecord {
  String studentId;
  String description;
  String actionTaken;

  DisciplineRecord({
    required this.studentId,
    required this.description,
    required this.actionTaken,
  });
}

class RecordDiscipline extends StatefulWidget {
  @override
  _RecordDisciplineState createState() => _RecordDisciplineState();
}

class _RecordDisciplineState extends State<RecordDiscipline> {
  List<DisciplineRecord> disciplineRecords = [];
  TextEditingController _studentIdController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _actionTakenController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _loadRecord();
  }

  Future<void> _loadRecord() async {
    final url = Uri.https(
      'school-management-app-9ccc8-default-rtdb.asia-southeast1.firebasedatabase.app',
      'RecordDiscipline.json',
    );
    try {
      final response = await https.get(url);
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);

        if (data != null && data is Map<String, dynamic>) {
          disciplineRecords.clear();

          data.forEach((key, value) {
            if (value != null && value is Map<String, dynamic>) {
              // Check if the required fields are present before adding to the list
              if (value.containsKey('id') &&
                  value.containsKey('description') &&
                  value.containsKey('action taken')) {
                disciplineRecords.add(DisciplineRecord(
                  studentId: value['id'],
                  description: value['description'],
                  actionTaken: value['action taken'],
                ));
              } else {
                print('Invalid data format for key $key');
              }
            } else {
              print('Invalid data format for key $key');
            }
          });

          setState(() {});
        } else {
          print('Invalid data format');
        }
      } else {
        print('Error loading record discipline: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _recordDisciplineCase() async {
    final url = Uri.https(
      'school-management-app-9ccc8-default-rtdb.asia-southeast1.firebasedatabase.app',
      'RecordDiscipline.json',
    );

    final Map<String, dynamic> userData = {
      'id': _studentIdController.text,
      'description': _descriptionController.text,
      'action taken': _actionTakenController.text,
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

        await _loadRecord();
      } else {
        // Handle errors
        print('Error registering user: ${response.statusCode}');
      }
    } catch (error) {
      // Handle exceptions
      print('Error: $error');
    }
  }

  Future<void> _updateDisciplineRecord(int index) async {
    TextEditingController _updateIdController =
        TextEditingController(text: disciplineRecords[index].studentId);
    TextEditingController _updateDescriptionController =
        TextEditingController(text: disciplineRecords[index].description);
    TextEditingController _updateActionTakenController =
        TextEditingController(text: disciplineRecords[index].actionTaken);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Discipline Record'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _updateIdController,
                decoration: InputDecoration(labelText: 'Student Id: '),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _updateDescriptionController,
                decoration: InputDecoration(labelText: 'Description: '),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _updateActionTakenController,
                decoration: InputDecoration(labelText: 'Action Taken: '),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              DisciplineRecord updatedRecord = DisciplineRecord(
                studentId: _updateIdController.text,
                description: _updateDescriptionController.text,
                actionTaken: _updateActionTakenController.text,
              );

              disciplineRecords[index] = updatedRecord;

              final url = Uri.https(
                'school-management-app-9ccc8-default-rtdb.asia-southeast1.firebasedatabase.app',
                'RecordDiscipline/${disciplineRecords[index].studentId}.json',
              );

              try {
                final response = await https.patch(
                  url,
                  headers: {'Content-Type': 'application/json'},
                  body: json.encode({
                    'studentId': updatedRecord.studentId,
                    'description': updatedRecord.description,
                    'action taken': updatedRecord.actionTaken,
                  }),
                );

                if (response.statusCode == 200) {
                  print('Record updated successfully');
                } else {
                  print('Error updating records: ${response.statusCode}');
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

  void _deleteDisciplineCase(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Record Discipline'),
        content: Text('Are you sure you want to delete this record?'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              final url = Uri.https(
                'school-management-app-9ccc8-default-rtdb.asia-southeast1.firebasedatabase.app',
                'RecordDiscipline/${disciplineRecords[index].studentId}.json',
              );

              try {
                final response = await https.delete(url);
                print(index);
                if (response.statusCode == 200) {
                  print('Records deleted successfully');
                } else {
                  print('Error deleting Records: ${response.statusCode}');
                }
              } catch (error) {
                print('Error: $error');
              }

              disciplineRecords.removeAt(index);
              setState(() {});
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                primary: Colors.lime,
                onPrimary: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6))),
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
                    borderRadius: BorderRadius.circular(6))),
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
          title: Text('Record Discipline'),
          centerTitle: true,
          backgroundColor: Colors.amber,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  'Add Record Discipline',
                  style: TextStyle(fontSize: 20),
                ),
                content: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _studentIdController,
                        decoration: InputDecoration(
                            labelText: 'Student ID: ',
                            hintText: 'Student ID:',
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
                        controller: _descriptionController,
                        decoration: InputDecoration(
                            labelText: 'Description: ',
                            hintText: 'Description:',
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.brown),
                            )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the description...!";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _actionTakenController,
                        decoration: InputDecoration(
                            labelText: 'Action Taken: ',
                            hintText: 'Action Taken:',
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.brown),
                            )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the action taken...!";
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
                        _recordDisciplineCase();
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
                      child: Text('Cancel')),
                  SizedBox(height: 32),
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
                disciplineRecords.isEmpty
                    ? Center(child: Text('No Discipline Records'))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: disciplineRecords.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: BorderSide(color: Colors.amberAccent)),
                              elevation: 1.0,
                              margin: EdgeInsets.symmetric(vertical: 15),
                              child: ExpansionTile(
                                title: Text(
                                  'Records: ${disciplineRecords[index].studentId}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      Icons.person,
                                      color: Colors.amberAccent,
                                    ),
                                    title: Text(
                                      'Student ID: ${disciplineRecords[index].studentId}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.description,
                                      color: Colors.amberAccent,
                                    ),
                                    title: Text(
                                      'Description: ${disciplineRecords[index].description}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.rule,
                                      color: Colors.amberAccent,
                                    ),
                                    title: Text(
                                      'Action Taken: ${disciplineRecords[index].actionTaken}',
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
                                        onPressed: () =>
                                            _updateDisciplineRecord(index),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () =>
                                            _deleteDisciplineCase(index),
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
