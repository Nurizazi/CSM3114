import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_management/widgets/Register.dart';
import 'package:http/http.dart' as https;
import 'package:school_management/widgets/homescreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'School Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String loginUser = " ";
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late FocusNode currentFocus;

  void _login() async {
    final url = Uri.https(
        'school-management-app-9ccc8-default-rtdb.asia-southeast1.firebasedatabase.app',
        'school-management.json');
    final response = await https.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = json.decode(response.body);

      bool isUserFound = false;

      for (var userId in userData.keys) {
        if (userData[userId]['username'] == usernameController.text &&
            userData[userId]['password'] == passwordController.text) {
          isUserFound = true;

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
          break;
        }
      }
      if (!isUserFound) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Incorrect username or password'),
          duration: Duration(seconds: 2),
        ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    currentFocus = FocusNode();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();

    currentFocus.dispose();
    super.dispose();

    @override
    Widget build(BuildContext context) {
      throw UnimplementedError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('School Management App'),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Padding(
              padding: const EdgeInsets.all(15),
              child: Column(children: <Widget>[
                const SizedBox(
                  height: 80,
                ),
                Image.asset(
                  'images/logo.jpg',
                  height: 200,
                  width: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                  height: 25,
                ),
              ])),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Username',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the username...!";
                    }
                    return null;
                  },
                  focusNode: currentFocus,
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Password',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        width: 3,
                        color: Colors.blueGrey,
                      ))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the username...!";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _login();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.amber,
                          onPrimary: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Register()),
                        );
                      },
                      child: Text(
                        "Don't have account yet, Sign Up here!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.amber),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ])));
  }
}
