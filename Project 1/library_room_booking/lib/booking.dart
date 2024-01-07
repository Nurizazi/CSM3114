import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Booking(),
  ));
}

class Booking extends StatefulWidget {
  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  DateTime? selectedDate;
  final matricNoController = TextEditingController();
  final fullNameController = TextEditingController();
  String selectedRoom = ' ';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('Booking Detail'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('image/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        height: 800,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: matricNoController,
                decoration: InputDecoration(
                  labelText: 'Matric No: ',
                  labelStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name: ',
                  labelStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                onTap: () {
                  _selectDate(context);
                },
                controller: TextEditingController(
                  text: selectedDate != null
                      ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                      : '',
                ),
                decoration: InputDecoration(
                  labelText: 'Date:',
                  labelStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              const Text(
                'Choose your Room: ',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              ListTile(
                title: Text(
                  'Wetland 1',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                leading: Radio(
                    value: 'Wetland 1',
                    groupValue: selectedRoom,
                    onChanged: (value) {
                      setState(() {
                        selectedRoom = 'Wetland 1';
                      });
                    }),
              ),
              ListTile(
                title: Text(
                  'Wetland 2',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                leading: Radio(
                    value: 'Wetland 2',
                    groupValue: selectedRoom,
                    onChanged: (value) {
                      setState(() {
                        selectedRoom = 'Wetland 2';
                      });
                    }),
              ),
              ListTile(
                title: Text(
                  'Wetland 3',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                leading: Radio(
                    value: 'Wetland 3',
                    groupValue: selectedRoom,
                    onChanged: (value) {
                      setState(() {
                        selectedRoom = 'Wetland 3';
                      });
                    }),
              ),
              ListTile(
                title: Text(
                  'Mangrove 4',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                leading: Radio(
                    value: 'Mangrove 4',
                    groupValue: selectedRoom,
                    onChanged: (value) {
                      setState(() {
                        selectedRoom = 'Mangrove 4';
                      });
                    }),
              ),
              ListTile(
                title: Text(
                  'Mangrove 5',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                leading: Radio(
                    value: 'Mangrove 5',
                    groupValue: selectedRoom,
                    onChanged: (value) {
                      setState(() {
                        selectedRoom = 'Mangrove 5';
                      });
                    }),
              ),
              ListTile(
                title: Text(
                  'Mangrove 6',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                leading: Radio(
                    value: 'Mangrove 6',
                    groupValue: selectedRoom,
                    onChanged: (value) {
                      setState(() {
                        selectedRoom = 'Mangrove 6';
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      _showDialog(context);
                    },
                    child: Text('Submit'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Booking Details: ',
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: Column(
            children: [
              Text(
                'Matric No: ${matricNoController.text}',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Full Name: ${fullNameController.text}',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Date: ${selectedDate != null ? selectedDate!.toString() : 'Not selected'}',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Selected Room: $selectedRoom',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK')),
          ],
        );
      },
    );
  }
}
