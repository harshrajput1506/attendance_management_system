import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'semesterpage.dart';
import 'token_manager.dart';

String? result_token;

Future<void> login(
    BuildContext context, String instructorId, String password) async {
    // String? responseMessage;
  final url =
      Uri.parse('https://newsdcattendance.onrender.com/loginApp');
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
        print(token);
        result_token = token;
        print('Text') ;
        await tokenManager.setToken(token); // save token using TokenManager
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SemesterPage()),
        );
      } else {
        throw Exception('Failed to login: ${jsonResponse['message']}');
      }
    } else if(response.statusCode == 404){
      final responseMessage = json.decode(response.body);
      final message = responseMessage['message'];
      showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(message.toString()),
        // content: Text('If you don\'t remember the Password Please, Reset it'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
    }else {
      final responseMessage = json.decode(response.body);
      final message = responseMessage['message'];
      showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(message.toString()),
        content: Text('If you don\'t remember the Password Please, Reset it'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
    }
  } catch (e) {
    print(e);
  }
}

String? token(){
  // print("*********** $result_token");
  return result_token;
}
