import 'dart:convert';
import 'package:attendance_management_system/semesterpage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'token_manager.dart';

Future<void> login(
    BuildContext context, String instructorId, String password) async {
  final url =
      Uri.parse('https://sdcusarattendance.onrender.com/api/v1/loginApp');
  final storage = FlutterSecureStorage(); // initialize storage
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
        final jsonDataString = json.encode(result);
        await storage.write(key: 'jsonData', value: jsonDataString);
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


Future<http.Response> fetchData(String endpoint) async {
  final storage = FlutterSecureStorage(); // initialize storage
  try {
    String? token = await storage.read(key: 'token'); // read token from storage
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.get(
      Uri.parse('https://sdcusarattendance.onrender.com/api/v1/' + endpoint),
      // Send authorization headers to the backend.
      headers: {
        'Cookie': 'token=$token',
      },
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  } catch (e) {
    // Handle token or network-related errors
    print(e);
    throw Exception('Failed to fetch data: $e');
  }
}
