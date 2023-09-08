import 'package:attendance_management_system/getstartedpage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GetStartedPage(),
       theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white, // Change app bar background color to white
          iconTheme: IconThemeData(color: Color.fromRGBO(4, 29, 83, 1),) // Change app bar icon color to blue
        ),
      ),
    );
  }
}
