import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;
import 'package:school_management/main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Register(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> registerUser() async {
    if (_validateInputs()) {
      final url = Uri.https(
        'school-management-app-9ccc8-default-rtdb.asia-southeast1.firebasedatabase.app',
        'school-management.json',
      );

      final Map<String, dynamic> userData = {
        'username': usernameController.text,
        'email': emailController.text,
        'password': passwordController.text,
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

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          // Handle errors
          print('Error registering user: ${response.statusCode}');
        }
      } catch (error) {
        // Handle exceptions
        print('Error: $error');
      }
    }
  }

  bool _validateInputs() {
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(
                  'Please fill in all fields',
                  style: TextStyle(fontSize: 15),
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.amberAccent,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      child: Text('OK'))
                ],
              ));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Screen'),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                  labelText: 'Username',
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.lime),
                      borderRadius: BorderRadius.circular(50.0))),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: 'Email',
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.lime),
                      borderRadius: BorderRadius.circular(50.0))),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: 'Password',
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.lime),
                      borderRadius: BorderRadius.circular(50.0))),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.lime),
                      borderRadius: BorderRadius.circular(50.0))),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: registerUser,
                  style: ElevatedButton.styleFrom(
                      primary: Colors.amber,
                      onPrimary: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      )),
                  child: Text('Register'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.amber,
                      onPrimary: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      )),
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
