/*import 'package:flutter/material.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  String selectedRoom = ' ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text('Choose your Room'),
        ),
        body: Center(
          child: Column(children: <Widget>[
            Text('Wetland'),
            ListTile(
              title: Text('Wetland 1'),
              leading: Radio(
                  value: '1',
                  groupValue: selectedRoom,
                  onChanged: (value) {
                    setState(() {
                      selectedRoom = '1';
                    });
                  }),
            ),
            ListTile(
              title: Text('Wetland 2'),
              leading: Radio(
                  value: '2',
                  groupValue: selectedRoom,
                  onChanged: (value) {
                    setState(() {
                      selectedRoom = '2';
                    });
                  }),
            ),
            ListTile(
              title: Text('Wetland 3'),
              leading: Radio(
                  value: '3',
                  groupValue: selectedRoom,
                  onChanged: (value) {
                    setState(() {
                      selectedRoom = '3';
                    });
                  }),
            ),
            Text('Mangrove'),
            ListTile(
              title: Text('Mangrove 1'),
              leading: Radio(
                  value: '4',
                  groupValue: selectedRoom,
                  onChanged: (value) {
                    setState(() {
                      selectedRoom = '4';
                    });
                  }),
            ),
            ListTile(
              title: Text('Mangrove 2'),
              leading: Radio(
                  value: '5',
                  groupValue: selectedRoom,
                  onChanged: (value) {
                    setState(() {
                      selectedRoom = '5';
                    });
                  }),
            ),
            ListTile(
              title: Text('Mangrove 3'),
              leading: Radio(
                  value: '6',
                  groupValue: selectedRoom,
                  onChanged: (value) {
                    setState(() {
                      selectedRoom = '6';
                    });
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ]),
        ));
  }
}*/