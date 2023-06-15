import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'attendancepage.dart';
import 'loginpage.dart';
import 'token_manager.dart';

class SemesterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SemesterPageState();
}

class SemesterPageState extends State<SemesterPage> {
  late List<String> schools = [];
  late List<String> streams = [];
  late List<String> semesters = [];
  late List<String> subjects = [];
  late List<Map<String, dynamic>> batches = [];
  String? _selectedSchool;
  String? _selectedStream;
  String? _selectedSemester;
  String? _selectedSubject;
  String? _selectedBatchID;
  bool _isLoading = false;
  late String name = '';
  final storage = FlutterSecureStorage(); // Initialize storage
  final tokenManager = TokenManager(); // Create an instance of TokenManager

  bool get isContinueButtonEnabled =>
      _selectedSchool != null &&
      _selectedStream != null &&
      _selectedSemester != null &&
      _selectedSubject != null;

  Future<void> fetchData(BuildContext context) async {
    try {
      final token =
          await tokenManager.getToken(); // Get token using TokenManager

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('https://sdcusarattendance.onrender.com/api/v1/getClasses'),
        headers: {
          'Authorization':
              token, // Include the token in the Authorization header
        },
      );
      print('Token : ${token}');
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          name = jsonData['data']['name'];
          _selectedSchool =
              jsonData['data'] != null && jsonData['data']['school'] != null
                  ? jsonData['data']['school'].toString()
                  : null;
          List<dynamic> batchesData =
              jsonData['data'] != null && jsonData['data']['batches'] != null
                  ? jsonData['data']['batches']
                  : [];
          updateStateWithBatches(batchesData);
        });
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception details: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred while fetching data.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Navigate back to LoginPage
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  String? getSubjectCode(String subjectName) {
    final Map<String, String> subjectCodeMap = {
      'Software Engineering': 'ARD201',
      'Convex Optimisation': 'ABS212',
      'Introduction to Machine Learning': 'ARM206',
      'Operating System': 'ARD204',
      'Design and Analysis of Algorithms': 'ARM208',
      'Maths': 'ICT207',
      'DSA': 'ICT204',
      'Data Mining': 'ARM207',
    };
    // ignore: avoid_print
    print(subjectCodeMap[subjectName]);
    return subjectCodeMap[subjectName];
  }

  void updateStateWithBatches(List<dynamic> batchesData) {
    Set<String> uniqueSchools = Set<String>();
    Set<String> uniqueStreams = Set<String>();
    Set<String> uniqueSemesters = Set<String>();
    Set<String> uniqueSubjects = Set<String>();
    List<Map<String, dynamic>> batchesList = [];
    for (var batch in batchesData) {
      if (batch['school'] != null && batch['school'] != _selectedSchool) {
        uniqueSchools.add(batch['school']);
      }
      if (batch['stream'] != null && batch['stream'] != _selectedStream) {
        uniqueStreams.add(batch['stream']);
      }
      if (batch['semester'] != null && batch['semester'] != _selectedSemester) {
        uniqueSemesters.add(batch['semester']);
      }
      if (batch['subject_name'] != null &&
          batch['subject_name'] != _selectedSubject) {
        uniqueSubjects.add(batch['subject_name']);
      }
      batchesList.add(batch);
    }
    schools = uniqueSchools.toList();
    streams = uniqueStreams.toList();
    semesters = uniqueSemesters.toList();
    subjects = uniqueSubjects.toList();
    batches = batchesList;
    if (_selectedSchool != null && !schools.contains(_selectedSchool!)) {
      schools.add(_selectedSchool!);
    }
    if (_selectedStream != null && !streams.contains(_selectedStream!)) {
      streams.add(_selectedStream!);
    }
    if (_selectedSemester != null && !semesters.contains(_selectedSemester!)) {
      semesters.add(_selectedSemester!);
    }
    if (_selectedSubject != null && !subjects.contains(_selectedSubject!)) {
      subjects.add(_selectedSubject!);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: tokenManager.isTokenValid(), // Check if token is valid
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data == true) {
          return Scaffold(
            backgroundColor: Color.fromRGBO(255, 255, 255, 1),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      color: Color.fromRGBO(255, 255, 255, 1),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await tokenManager.deleteToken();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (route) => false,
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(4, 29, 83, 1),
                          ),
                        ),
                        icon: Icon(
                          Icons.logout_sharp,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Logout',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 10,
                    child: Center(
                      child: Icon(
                        Icons.person_rounded,
                        size: 60,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Center(
                            child: Text(
                              name ?? '', // Display the name variable
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            "Professor",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Container(
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                _selectedSchool == null
                                    ? CircularProgressIndicator()
                                    : Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Color.fromRGBO(4, 29, 83, 1),
                                          ),
                                          margin: EdgeInsets.all(10.0),
                                          width: 320,
                                          alignment: Alignment.center,
                                          child: DropdownButton<String>(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            isExpanded: true,
                                            iconEnabledColor: Colors.white,
                                            value: _selectedSchool,
                                            underline: SizedBox(),
                                            items: schools.map((school) {
                                              print(school);
                                              return DropdownMenuItem<String>(
                                                value: school,
                                                child: Center(
                                                  child: Text(
                                                    school,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) async {
                                              setState(() {
                                                _selectedSchool = newValue;
                                                _selectedStream =
                                                    null; // Reset selected stream
                                                _selectedSemester =
                                                    null; // Reset selected semester
                                                _selectedSubject =
                                                    null; // Reset selected subject
                                              });
                                            },
                                            hint: _selectedSchool == null
                                                ? Center(
                                                    child: Text(
                                                      "Select School",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  )
                                                : null,
                                            dropdownColor:
                                                Color.fromRGBO(0, 70, 121, 1),
                                          ),
                                        ),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    margin: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromRGBO(4, 29, 83, 1),
                                    ),
                                    width: 320,
                                    alignment: Alignment.center,
                                    child: _selectedSchool == null
                                        ? null
                                        : Container(
                                            child: DropdownButton<String>(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              isExpanded: true,
                                              iconEnabledColor: Colors.white,
                                              underline: SizedBox(),
                                              value: _selectedStream,
                                              items: streams.map((stream) {
                                                return DropdownMenuItem<String>(
                                                  value: stream,
                                                  child: Center(
                                                    child: Text(
                                                      stream,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  _selectedStream = newValue;
                                                  _selectedSemester = null;
                                                });
                                              },
                                              hint: _selectedStream == null
                                                  ? Center(
                                                      child: Text(
                                                        'Select Branch',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    )
                                                  : null,
                                              dropdownColor:
                                                  Color.fromRGBO(0, 70, 121, 1),
                                            ),
                                          ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    margin: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromRGBO(4, 29, 83, 1),
                                    ),
                                    width: 320,
                                    alignment: Alignment.center,
                                    child: _selectedSchool == null
                                        ? null
                                        : Container(
                                            child: DropdownButton<String>(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              isExpanded: true,
                                              iconEnabledColor: Colors.white,
                                              value: _selectedSemester,
                                              underline: SizedBox(),
                                              items: semesters.map((semester) {
                                                return DropdownMenuItem<String>(
                                                  value: semester,
                                                  child: Center(
                                                    child: Text(
                                                      semester,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  _selectedSemester = newValue;
                                                });
                                              },
                                              hint: _selectedSemester == null
                                                  ? Center(
                                                      child: Text(
                                                        'Select Semester',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    )
                                                  : null,
                                              dropdownColor:
                                                  Color.fromRGBO(0, 70, 121, 1),
                                            ),
                                          ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    margin: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromRGBO(4, 29, 83, 1),
                                    ),
                                    width: 320,
                                    alignment: Alignment.center,
                                    child: _selectedSchool == null
                                        ? null
                                        : Container(
                                            child: DropdownButton<String>(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              isExpanded: true,
                                              iconEnabledColor: Colors.white,
                                              value: _selectedSubject,
                                              underline: SizedBox(),
                                              items: subjects.map((subject) {
                                                return DropdownMenuItem<String>(
                                                  value: subject,
                                                  child: Center(
                                                    child: Text(
                                                      subject,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  _selectedSubject = newValue;
                                                });
                                              },
                                              hint: _selectedSubject == null
                                                  ? Center(
                                                      child: Text(
                                                        'Select Subject',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    )
                                                  : null,
                                              dropdownColor:
                                                  Color.fromRGBO(0, 70, 121, 1),
                                            ),
                                          ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(28.0),
                                  child: Container(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(320, 50),
                                        backgroundColor:
                                            Color.fromRGBO(0, 70, 121, 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                      ),
                                      child: _isLoading
                                          ? Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.blue,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 3,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.white),
                                                ),
                                              ),
                                            ): Text(
                                              "Continue",
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                      onPressed: isContinueButtonEnabled
                                          ? () async {
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              try {
                                                final token = await tokenManager
                                                    .getToken(); // Get token using TokenManager
                                                if (token == null) {
                                                  throw Exception(
                                                      'Token not found');
                                                }

                                                final batchIdValue =
                                                    await getBatchId();
                                                if (batchIdValue != null) {
                                                  final jsonData = jsonEncode({
                                                    'code': getSubjectCode(
                                                        _selectedSubject!),
                                                    'batchId': batchIdValue,
                                                  });
                                                  print(getSubjectCode(
                                                      _selectedSubject!));
                                                  print(batchIdValue);

                                                  final url = Uri.parse(
                                                      'https://sdcusarattendance.onrender.com/api/v1/generatePID');

                                                  final response =
                                                      await http.post(
                                                    url,
                                                    headers: {
                                                      'Authorization': token,
                                                      'Content-Type':
                                                          'application/json',
                                                    },
                                                    body: jsonData,
                                                  );

                                                  if (response.statusCode ==
                                                          200 ||
                                                      response.statusCode ==
                                                          201) {
                                                    final responseData =
                                                        jsonDecode(
                                                                response.body)
                                                            as Map<String,
                                                                dynamic>;
                                                    print(
                                                        'Response Data: $responseData');
                                                    // Process the response data as needed
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AttendancePage()),
                                                    );
                                                  } else {
                                                    print(
                                                        'Response Status Code: ${response.statusCode}');
                                                    print(
                                                        'Response Body: ${response.body}');
                                                    throw Exception(
                                                        'Failed to generate PID. Status code: ${response.statusCode}');
                                                  }
                                                } else {
                                                  print(
                                                      'Failed to retrieve batch ID');
                                                }
                                              } catch (e) {
                                                print('Exception details: $e');
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title: Text('Error'),
                                                    content: Text(
                                                        'An error occurred while generating PID.'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(); // Close the dialog
                                                          Navigator.of(context)
                                                              .pop(); // Navigate back to LoginPage
                                                        },
                                                        child: Text('OK'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            }
                                          : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Color.fromRGBO(255, 255, 255, 1),
            body: Center(child: Text('Not Authenticated')),
          );
        }
      },
    );
  }

  Future<String?> getBatchId() async {
    final url =
        Uri.parse('https://sdcusarattendance.onrender.com/api/v1/getClasses');

    try {
      final token = await tokenManager.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        url,
        headers: {
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['success'] == true) {
          final data = jsonResponse['data'];
          final batches = data['batches'] as List<dynamic>;

          if (batches.isNotEmpty) {
            final batch = batches.first;
            final batchId = batch['batch_id'] as String;
            return batchId;
          }
        } else {
          print('API request failed: ${jsonResponse['message']}');
        }
      } else {
        print('API request failed with status code: ${response.statusCode}');
      }

      return null; // Return null if the API response is invalid or no batch ID found
    } catch (e) {
      print('Exception in getBatchId(): $e');
      return null; // Return null in case of any exception
    }
  }
}
