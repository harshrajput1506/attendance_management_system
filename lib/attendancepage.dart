import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'token_manager.dart';

class AttendanceModel {
  final String name;
  final String enrollmentNo;

  AttendanceModel({
    required this.name,
    required this.enrollmentNo,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      name: json['name'] as String,
      enrollmentNo: json['enrollment_no'] as String,
    );
  }
}

class AttendancePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AttendancePageState();
}

class AttendancePageState extends State<AttendancePage> {
  List<AttendanceModel> studentsList = [];
  final tokenManager = TokenManager(); // Create an instance of TokenManager

 Future<List<AttendanceModel>> getStudentsDataApi(String batchId, String semster) async {
  try {
    final token = await tokenManager.getToken(); // Retrieve the token using TokenManager
    if (token == null) {
      throw Exception('Token not found');
    }

    final headers = {
      'Authorization': token, // Include the token in the Authorization header as a Bearer token
      'Content-Type': 'application/json',
    };

    final url = Uri.parse('https://sdcusarattendance.onrender.com/api/v1/getStudents');

    final body = {
      'batchId': batchId,
      'semster': semster,
    };

    final response = await http.post(url, headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (responseData['success']) {
        final students = responseData['result'] as List;
        List<AttendanceModel> studentsList =
            students.map((json) => AttendanceModel.fromJson(json)).toList();
        print("Fetched students: $studentsList");
        return studentsList;
      } else {
        throw Exception(responseData['message']);
      }
    } else {
      throw Exception('Failed to load data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print(e);
    throw e;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<AttendanceModel>>(
              future: getStudentsDataApi("23", "4"),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  print("Snapshot data: ${snapshot.data}");
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final student = snapshot.data![index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color.fromRGBO(4, 29, 83, 1),
                          child: Icon(
                            Icons.person_outline_outlined,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(student.name),
                        subtitle: Text(student.enrollmentNo),
                        trailing: Icon(
                          Icons.check_circle,
                          color: Color.fromRGBO(4, 29, 83, 1),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return AlertDialog(
                    title: Text('Welcome'),
                    content: Text('${snapshot.error}'),
                    actions: [],
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
