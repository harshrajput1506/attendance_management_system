import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'lastpage.dart';
import 'token_manager.dart';

class AttendanceModel {
  final String name;
  final int enrollmentNo;

  AttendanceModel({
    required this.name,
    required this.enrollmentNo,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      name: json['name'] as String,
      enrollmentNo: json['enrollment_no'] as int,
    );
  }

  @override
  String toString() {
    return 'AttendanceModel(name: $name, enrollmentNo: $enrollmentNo)';
  }
}

class AttendancePage extends StatefulWidget {
  final responseData;
  AttendancePage(this.responseData);

  @override
  State<StatefulWidget> createState() => AttendancePageState();
}

class AttendancePageState extends State<AttendancePage> {
  List<AttendanceModel> studentsList = [];
  final tokenManager = TokenManager();
  String courseName = '';
  String stream = '';
  String comment = '';
  List<bool> isSelected = [];
  List<AttendanceModel> selectedStudents = [];
  bool _isMounted = false;
  bool markAllPresent = false;

  @override
  void initState() {
    print(widget.responseData);
    super.initState();
    _isMounted = true;

    getStudentsDataApi(widget.responseData[1][0], widget.responseData[1][2])
        .then((students) {
      if (_isMounted) {
        setState(() {
          studentsList = students;
          isSelected = List.generate(studentsList.length, (_) => false);
        });
      }
    }).catchError((error) {
      print('Error fetching students data: $error');
    });
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<List<AttendanceModel>> getStudentsDataApi(
      int batchId, int semester) async {
    try {
      final token = await tokenManager.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final headers = {
        'Authorization': token,
        'Content-Type': 'application/json',
      };

      final url = Uri.parse(
          'https://attendancesdcusar.onrender.com/api/v1/getStudents');

      final body = {
        'batchId': batchId,
        'semster': semester,
      };

      final response =
          await http.post(url, headers: headers, body: json.encode(body));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;

        if (responseData['success']) {
          final students = responseData['result'] as List;
          studentsList =
              students.map((json) => AttendanceModel.fromJson(json)).toList();
          setState(() {
            isSelected = List.generate(studentsList.length, (_) => false);
          });
          return studentsList;
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 100,
                  child: Center(
                    child: Column(
                      children: [
                        // Text(
                        //   widget.responseData[1][5],
                        //   style: TextStyle(
                        //     fontSize: 18,
                        //     fontFamily: "Poppins",
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        //   textAlign: TextAlign.center,
                        // ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.responseData[1][3],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                widget.responseData[1][4],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          widget.responseData[1][5],
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
                        // Text(
                        //   // widget.responseData[1][1],
                        //   style: TextStyle(
                        //     fontSize: 18,
                        //     fontFamily: "Poppins",
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        //   textAlign: TextAlign.center,
                        // ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Mark all as Present",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 60,
                    ),
                    Switch(
                      value: markAllPresent,
                      activeColor: Color.fromRGBO(4, 29, 83, 1),
                      inactiveThumbColor: Colors.grey,
                      onChanged: (newValue) {
                        setState(() {
                          markAllPresent = newValue;

                          if (markAllPresent) {
                            selectedStudents = List.from(studentsList);
                          } else {
                            selectedStudents.clear();
                          }

                          isSelected = List.generate(
                            studentsList.length,
                            (index) =>
                                markAllPresent ||
                                selectedStudents.contains(studentsList[index]),
                          );
                        });
                      },
                    )
                  ],
                ),
                Container(
                  child: Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: studentsList.length,
                      itemBuilder: (context, index) {
                        final student = studentsList[index];
                        final bool isChecked = isSelected[index];
                        print(index);
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          shadowColor: Colors.blue,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isChecked
                                  ? Colors.green.shade900
                                  : Colors.red,
                              child: Icon(
                                Icons.person_outline_outlined,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              student.name,
                              style: TextStyle(
                                color: isChecked
                                    ? Colors.green.shade900
                                    : Colors.red,
                              ),
                            ),
                            subtitle: Text(student.enrollmentNo.toString()),
                            trailing: GestureDetector(
                              onTap: () {
                                setState(() {
                                  final isChecked = isSelected[index];

                                  if (isChecked) {
                                    selectedStudents.remove(student);
                                  } else {
                                    selectedStudents.add(student);
                                  }

                                  isSelected[index] = !isChecked;
                                  markAllPresent =
                                      isSelected.every((value) => value) &&
                                          selectedStudents.isNotEmpty;
                                });
                              },
                              child: Icon(
                                isSelected[index]
                                    ? Icons.check_circle
                                    : Icons.circle,
                                color: isSelected[index]
                                    ? Colors.green.shade900
                                    : Colors.grey,
                                size: 40,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                SizedBox(
                  height: 50,
                  width: 320,
                  child: SlideAction(
                    outerColor: Color.fromRGBO(0, 70, 121, 1),
                    innerColor: Colors.white,
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    onSubmit: () {
                      // markAttendance(selectedStudents, widget.responseData);
                      int totalStudentsPresent = selectedStudents.length;
                      int totalStudents = studentsList.length;

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          TextEditingController commentController =
                              TextEditingController();

                          return AlertDialog(
                            title: Text('Info'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Total students present: $totalStudentsPresent'
                                  "\n"
                                  'Out of : $totalStudents',
                                ),
                                SizedBox(height: 20),
                                TextField(
                                  controller: commentController,
                                  maxLength: 30,
                                  decoration: InputDecoration(
                                    labelText: 'Add a comment (max 30 words)',
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines:
                                      null, // Allow multiple lines of text
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Cancel',
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 70, 121, 1))),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 70, 121, 1)),
                                ),
                                onPressed: () {
                                  comment = commentController.text;
                                  markAttendance(
                                      selectedStudents, widget.responseData);
                                  // Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.all(15))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> markAttendance(
      List<AttendanceModel> selectedStudents, dynamic resposeData) async {
    // try {
    final token = await tokenManager.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final headers = {
      'Authorization': token,
      'Content-Type': 'application/json',
    };

    final url = Uri.parse(
        'https://attendancesdcusar.onrender.com/api/v1/markingattendance');

    final List<Map<String, dynamic>> attendanceList = selectedStudents
        .map((student) => {
              'enrollment_no': student.enrollmentNo,
              'attendancestatus': 1,
            })
        .toList();
    // print(attendanceList);
    Map<String, dynamic> Mydata = {
      'data': attendanceList,
      'period_id': resposeData[0]["period_id"],
      'comment': comment
    };
    final jsonData = jsonEncode(Mydata);
    print(jsonData);
    final response = await http.post(url, headers: headers, body: jsonData);

    if (response.statusCode == 200) {
      // final result = jsonDecode(response.body) as Map<String, dynamic>;
      // Process the response if needed
      print('Attendance marked successfully');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SubmitPage()));
    } else {
      throw Exception(
          'Failed to mark attendance. Status code: ${response.statusCode}');
    }
  }
}
