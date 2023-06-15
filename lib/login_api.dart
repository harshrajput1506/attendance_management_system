import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'semesterpage.dart';
import 'token_manager.dart';

Future<void> login(BuildContext context, String instructorId, String password) async {
  final url = Uri.parse('https://sdcusarattendance.onrender.com/api/v1/loginApp');
  final tokenManager = TokenManager(); // create an instance of TokenManager

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
        await tokenManager.setToken(token); // save token using TokenManager
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SemesterPage()),
        );
      } else {
        throw Exception('Failed to login: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  } catch (e) {
    print(e);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Login Error'),
        content: Text('An error occurred while logging in.'),
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
