import 'package:flutter/material.dart';
import 'package:library_room_booking/booking.dart';
import 'package:library_room_booking/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Homepage(),
        '/bookingDetails': (context) => Booking()
      },
    );
  }
}
