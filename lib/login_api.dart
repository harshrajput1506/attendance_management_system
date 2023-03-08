import 'dart:convert';
import 'package:attendance_management_system/semesterpage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> login(
  BuildContext context, 
  String instructorId, 
  String password
) async {
  final url = Uri.parse('https://sdcusarattendance.onrender.com/api/v1/loginApp');
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'instructor_id': instructorId,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final success = jsonResponse['success'];
      final token = jsonResponse['token'];
      final result = jsonResponse['result'];
      if (success) {
        // Save token to Shared Preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        // Convert the object to a JSON string
        final jsonDataString = json.encode(result);
        // Save result_json_data to Shared Preferences
        await prefs.setString('jsonData', jsonDataString);
        // Navigate to the next screen
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => SemesterPage())
        );
      } 
    } else {
      throw Exception('Failed to login');
    }
  } catch (e) {
    // Display an error message
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Login Error'),
        content: Text('Incorrect ID or password.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
