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
  List<bool> isSelected = [];
  List<AttendanceModel> selectedStudents = [];
  bool _isMounted = false;
  bool markAllPresent = false;

  // Future<String> getCourseName() async {
  //   try {
  //     final token = await tokenManager.getToken();
  //     if (token == null) {
  //       throw Exception('Token not found');
  //     }

  //     final headers = {
  //       'Authorization': token,
  //       'Content-Type': 'application/json',
  //     };

  //     final url =
  //         Uri.parse('https://sdcusarattendance.onrender.com/api/v1/getClasses');

  //     final response = await http.get(url, headers: headers);

  //     if (response.statusCode == 200) {
  //       final responseData = jsonDecode(response.body) as Map<String, dynamic>;
  //       final data = responseData['data'] as Map<String, dynamic>;
  //       final batches = data['batches'] as List<dynamic>;
  //       final subjectName = batches[0]['subject_name'] as String;
  //       final stream = batches[0]['stream'] as String;
  //       setState(() {
  //         courseName = subjectName;
  //         this.stream = stream;
  //       });
  //       return subjectName;
  //     } else {
  //       throw Exception('Failed to fetch subject name');
  //     }
  //   } catch (e) {
  //     print(e);
  //     throw e;
  //   }
  // }

  @override
  void initState() {
    print(widget.responseData);
    super.initState();
    _isMounted = true;

    // getCourseName().then((name) {
    //   if (_isMounted) {
    //     setState(() {
    //       courseName = name;
    //     });
    //   }
    // }).catchError((error) {
    //   print('Error fetching course name: $error');
    // });

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
          'https://sdcusarattendance.onrender.com/api/v1/getStudents');

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
                        Row(
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
                        Text(
                          widget.responseData[1][1],
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
                      onChanged: (newValue) {
                        setState(() {
                          markAllPresent = newValue;
                          if (markAllPresent) {
                            selectedStudents = List.from(studentsList);
                          } else {
                            selectedStudents.clear();
                          }

                          // Update the checkbox state based on the switch state
                          isSelected = List.generate(
                            studentsList.length,
                            (index) =>
                                markAllPresent ||
                                selectedStudents.contains(studentsList[index]),
                          );
                          if (!isSelected.every((value) => value) ||
                              selectedStudents.isEmpty) {
                            markAllPresent = false;
                          }
                        });
                      },
                    ),
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

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                isChecked ? Colors.green.shade900 : Colors.red,
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
                                if (isChecked) {
                                  markAllPresent = false;
                                  selectedStudents.remove(student);
                                } else {
                                  selectedStudents.add(student);
                                }
                                isSelected[index] = !isChecked;
                                print('Selected Students: $selectedStudents');
                              });
                            },
                            child: Icon(
                              isChecked ? Icons.check_circle : Icons.circle,
                              color: isChecked
                                  ? Colors.green.shade900
                                  : Colors.grey,
                              size: 40,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(15)),
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
                      markAttendance(selectedStudents, widget.responseData);
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.all(15)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> markAttendance(
      List<AttendanceModel> selectedStudents, final resposeData) async {
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
          'https://sdcusarattendance.onrender.com/api/v1/markingattendance');

      final List<Map<String, dynamic>> attendanceList = selectedStudents
          .map((student) => {
                'enrollment_no': student.enrollmentNo,
                'attendancestatus': 1,
              })
          .toList();

      final body = {
        'data': attendanceList,
        'period_id': resposeData["period_id"]
      };

      final response =
          await http.post(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        // Process the response if needed
        print('Attendance marked successfully');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SubmitPage()));
      } else {
        throw Exception(
            'Failed to mark attendance. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      print("Failed to Marked Attendace");
      throw e;
    }
  }
}

// void main()  {
//   runApp(MaterialApp(
//     home: AttendancePage(),
//   ));
// }
