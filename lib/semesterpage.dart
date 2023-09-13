import 'dart:convert';
import 'package:attendance_management_system/reset_pass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:time_range_picker/time_range_picker.dart';
import 'attendancepage.dart';
import 'loginpage.dart';
// import 'package:intl/intl.dart';
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
  late List<String> batchs = [];
  late List<dynamic> batchesList = [];
  late List<dynamic> classDetails = [];
  late List<Map<String, dynamic>> batchData = [];
  late String selectedTime = "Select Time";

  String? _selectedSchool;
  String? _selectedStream;
  String? _selectedSemester;
  String? _selectedSubject;
  String? _selectedBatchID;
  // String? _selectedTimestamp;
  String? _selectedBatch;
  String? selectedSubjectType;
  String? selectedBatchGroup;
  int? _startTimestamp;
  int? _endTimeStamp;
  // String? timestamp = getCurrentDateTimeFormatted();

  List<String> batchGroups = ['A & B', 'A', 'B'];

  List<String> batchOptions = [];

  void fetchBatchOptions() {
    if (selectedSubjectType == "lab") {
      setState(() {
        batchOptions = ["A", "B"];
        selectedBatchGroup = null;
      });
    } else if (selectedSubjectType == "theory") {
      setState(() {
        batchOptions = ["A & B"];
        selectedBatchGroup = "A & B";
      });
    }
  }

  bool _isLoading = false;
  late String name = '';
  final storage = FlutterSecureStorage(); // Initialize storage
  final tokenManager = TokenManager(); // Create an instance of TokenManager

  bool get isContinueButtonEnabled =>
      _selectedSchool != null &&
      _selectedStream != null &&
      _selectedSemester != null &&
      _selectedSubject != null &&
      _selectedBatch != null;

  Future<void> fetchData(BuildContext context) async {
    try {
      final token =
          await tokenManager.getToken(); // Get token using TokenManager

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('https://newsdcattendance.onrender.com/generateClasses'),
        headers: {
          'Authorization':
              token, // Include the token in the Authorization header
        },
      );

      print('Token : ${token}');
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // print(jsonData);

        print(jsonData['data']['user']);
        print(jsonData['data']['school']);
        print(jsonData['data']['user']);
        print(jsonData['data']['batchData']);
        print('batchData'.runtimeType);
        List<dynamic> batchesInfo =
            List<dynamic>.from(jsonData['data']['batchData']);
        print(batchesInfo.runtimeType);
        setState(() {
          name = jsonData['data']['user'];
          _selectedSchool =
              jsonData['data'] != null && jsonData['data']['school'] != null
                  ? jsonData['data']['school'].toString()
                  : null;
          batchesList = jsonData['data'] != null && jsonData['data']['batchData'] != null
              ? batchesInfo
              : [];
          //refreshData("school", "", "");
          updateStateWithBatches(batchesList);

        });
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception details: $e');
      print(e);
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


/*  void refreshData(String selection, String key ,String value) {
    Set<String> unique = Set<String>();
    if(selection == "school"){
      unique.add(_selectedSchool!);
    }
    for(var batch in batchesList!) {
      if(batch[selection] != null){
        if(selection == "semester") {
          unique.add(batch[selection]);
        }
        else {
          if(key != "" && value != ""){
            if(batch[key] == value) {
              unique.add(batch[selection]);
            }
          }

        }

      }
    }
    if(selection == "school"){
      schools = unique.toList();
    }
    if(selection == "semester"){
      semesters = unique.toList();
    }
    else if(selection == "stream"){
      streams = unique.toList();
    }else if(selection == "subject"){
      subjects = unique.toList();
    }if(selection == "batch"){
      batchs = unique.toList();
    }

  }*/

  void updateStateWithBatches(List<dynamic> batchesData) {
    Set<String> uniqueSchools = Set<String>();
    Set<String> uniqueStreams = Set<String>();
    Set<String> uniqueSemesters = Set<String>();
    Set<String> uniqueSubjects = Set<String>();
    Set<String> uniqueBatch = Set<String>();
    List<Map<String, dynamic>> batchesList = [];
    for (var batch in batchesData) {
      // if (batch['school'] != null && batch['school'] != _selectedSchool) {
      //   uniqueSchools.add(batch['school']);
      // }
      if (batch['stream'] != null && batch['stream'] != _selectedStream) {
        uniqueStreams.add(batch['stream']);
      }
      if (batch['semester'] != null && batch['semester'] != _selectedSemester) {
        uniqueSemesters.add(batch['semester']);
      }
      if (batch['batch'] != null && batch['batch'] != _selectedBatch) {
        uniqueBatch.add(batch['batch']);
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
    batchs = uniqueBatch.toList();
    batchData = batchesList;
    if (_selectedSchool != null && !schools.contains(_selectedSchool!)) {
      schools.add(_selectedSchool!);
    }
    if (_selectedStream != null && !streams.contains(_selectedStream!)) {
      streams.add(_selectedStream!);
    }
    if (_selectedSemester != null && !semesters.contains(_selectedSemester!)) {
      semesters.add(_selectedSemester!);
    }
    if (_selectedBatch != null && !batchs.contains(_selectedBatch!)) {
      batchs.add(_selectedBatch!);
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
                backgroundColor: Color.fromRGBO(255, 255, 255, 1)),
            drawer: Drawer(
              child: Container(
                child: ListView(
                  children: [
                    DrawerHeader(
                        child: CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/images/img_ggsipulogo1.png"),
                      radius: 50,
                    )),
                    ListTile(
                      leading: Icon(Icons.reset_tv_outlined),
                      title: Text("Reset Password"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgetPasswordPage(),
                            ));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout_outlined),
                      title: Text("Logout"),
                      onTap: () async {
                        await tokenManager.deleteToken();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                          (route) => false,
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
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
                      height: 60,
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Center(
                              child: Text(
                                name, // Display the name variable
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 20,
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
                              child: Column(children: <Widget>[
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
                                                _selectedBatch = null;
                                                _selectedSubject =
                                                    null; // Reset selected subject
                                                //refreshData("semester", "school", _selectedSchool!);
                                              });
                                            },
                                            disabledHint: Center(
                                              child: Text(
                                                "Select School",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
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
                                              value: _selectedSemester,
                                              underline: SizedBox(),
                                              items: semesters != null ? semesters!.map((semester) {
                                                return DropdownMenuItem<String>(
                                                  value: semester,
                                                  child: Center(
                                                    child: Text(
                                                      semester.toString(),
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList() : null,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  _selectedSemester = newValue;
                                                  //refreshData("stream", "semester", newValue!);
                                                  _selectedBatch = null;
                                                  _selectedSubject = null;
                                                  selectedBatchGroup = null;
                                                  selectedSubjectType = null;
                                                });
                                              },
                                              disabledHint: Center(
                                                child: Text(
                                                  'Select Semester',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
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
                                              items: streams != null ? streams!.map((stream) {
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
                                              }).toList() : null,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  _selectedStream = newValue;
                                                  //refreshData("subject", "stream", _selectedStream!);
                                                  _selectedBatch = null;
                                                  selectedBatchGroup = null;
                                                  selectedSubjectType = null;
                                                  _selectedSubject = null;
                                                });
                                              },
                                              disabledHint: Center(
                                                child: Text(
                                                  'Select Branch',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
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
                                              value: _selectedSubject,
                                              underline: SizedBox(),
                                              items: subjects!=null ? subjects!.map((subject) {
                                                return DropdownMenuItem<String>(
                                                  value: subject,
                                                  child: Center(
                                                      child: Text(
                                                        subject,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                  ),
                                                );
                                              }).toList() : null,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  _selectedSubject = newValue;
                                                  //refreshData("batch", "subject", _selectedBatch!);
                                                  _selectedBatch = null;
                                                  selectedBatchGroup = null;
                                                });
                                              },
                                              disabledHint: Center(
                                                child: Text(
                                                  'Select Subject',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,

                                                  ),
                                                ),
                                              ),
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
                                              value: _selectedBatch,
                                              items: batchs != null ? batchs!.map((batch) {
                                                return DropdownMenuItem<String>(
                                                  value: batch,
                                                  child: Center(
                                                    child: Text(
                                                      batch,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList() : null,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  _selectedBatch = newValue;
                                                  selectedBatchGroup = null;
                                                });
                                              },
                                              disabledHint: Center(
                                                child: Text(
                                                  'Select Batch Group',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                              hint: _selectedBatch == null
                                                  ? Center(
                                                      child: Text(
                                                        'Select Batch Group',
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
                                // if (selectedSubjectType != "theory")
                                //   Padding(
                                //     padding: const EdgeInsets.all(2.0),
                                //     child: Container(
                                //       margin: EdgeInsets.all(10.0),
                                //       decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(10),
                                //         color: Color.fromRGBO(4, 29, 83, 1),
                                //       ),
                                //       width: 320,
                                //       alignment: Alignment.center,
                                //       child: _selectedSchool == null
                                //           ? null
                                //           : Container(
                                //               child: DropdownButton<String>(
                                //                 value: selectedBatchGroup,
                                //                 onChanged: (newValue) {
                                //                   setState(() {
                                //                     selectedBatchGroup =
                                //                         newValue!;
                                //                   });
                                //                 },
                                //                 items: batchGroups.map<
                                //                         DropdownMenuItem<
                                //                             String>>(
                                //                     (String value) {
                                //                   return DropdownMenuItem<
                                //                       String>(
                                //                     value: value,
                                //                     child: Text(value, style: TextStyle(color: Colors.white),),
                                //                   );
                                //                 }).toList(),
                                //                 hint: selectedBatchGroup == null
                                //                     ? Center(
                                //                         child: Text(
                                //                           'Select Batch Group',
                                //                           style: TextStyle(
                                //                             color: Colors.white,
                                //                             fontSize: 18,
                                //                           ),
                                //                         ),
                                //                       )
                                //                     : null,
                                //                 dropdownColor: Color.fromRGBO(
                                //                     0, 70, 121, 1),
                                //               ),
                                //             ),
                                //     ),
                                //   ),
                                Padding(
                                  padding: const EdgeInsets.all(28.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(320, 50),
                                          backgroundColor:
                                              Color.fromRGBO(0, 70, 121, 1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                        ),
                                        onPressed: () async {
                                          TimeRange result =
                                              await showTimeRangePicker(
                                            context: context,
                                          );
                                          DateTime now = new DateTime.now();
                                          String month = "00";
                                          String day = "00";
                                          String startHours = "00";
                                          String startMinutes = "00";
                                          String endMinutes = "00";
                                          String endHours = "00";
                                          if (now.month.toString().length ==
                                              1) {
                                            month = "0${now.month}";
                                          } else {
                                            month = now.month.toString();
                                          }
                                          if (now.day.toString().length == 1) {
                                            day = "0${now.day}";
                                          } else {
                                            day = now.day.toString();
                                          }

                                          if (result.startTime.hour
                                                  .toString()
                                                  .length ==
                                              1) {
                                            startHours =
                                                "0${result.startTime.hour}";
                                          } else {
                                            startHours = result.startTime.hour
                                                .toString();
                                          }
                                          if (result.startTime.minute
                                                  .toString()
                                                  .length ==
                                              1) {
                                            startMinutes =
                                                "0${result.startTime.minute}";
                                          } else {
                                            startMinutes = result
                                                .startTime.minute
                                                .toString();
                                          }
                                          if (result.endTime.minute
                                                  .toString()
                                                  .length ==
                                              1) {
                                            endMinutes =
                                                "0${result.endTime.minute}";
                                          } else {
                                            endMinutes = result.endTime.minute
                                                .toString();
                                          }
                                          if (result.endTime.hour
                                                  .toString()
                                                  .length ==
                                              1) {
                                            endHours =
                                                "0${result.endTime.hour}";
                                          } else {
                                            endHours =
                                                result.endTime.hour.toString();
                                          }
                                          String startDateTimeString =
                                              "${now.year}-${month}-${day} ${startHours}:${startMinutes}:00";
                                          String endDateTimeString =
                                              "${now.year}-${month}-${day} ${endHours}:${endMinutes}:00";
                                          DateTime startDateTime =
                                              DateTime.parse(
                                                  startDateTimeString);
                                          DateTime endDateTime =
                                              DateTime.parse(endDateTimeString);

                                          _endTimeStamp = endDateTime
                                              .millisecondsSinceEpoch;
                                          _startTimestamp = startDateTime
                                              .millisecondsSinceEpoch;

                                          print("result " +
                                              startDateTime.toString() +
                                              " " +
                                              endDateTime.toString());

                                          setState(() {
                                            selectedTime = "$startHours:$startMinutes - $endHours:$endMinutes";
                                          });
                                        },
                                        child: Text(
                                          selectedTime,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
                                            )
                                          : Text(
                                              "Continue",
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                      onPressed: isContinueButtonEnabled
                                          ? () async {
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              try {
                                                // Find the selected batch data
                                                final selectedBatchData =
                                                    batchData.firstWhere(
                                                  (batch) =>
                                                      batch["subject_name"] ==
                                                          _selectedSubject &&
                                                      batch["batch"] ==
                                                          _selectedBatch,
                                                );

                                                if (selectedBatchData != null) {
                                                  final batchId =
                                                      selectedBatchData[
                                                          "batch_id"];
                                                  final periodId =
                                                      selectedBatchData[
                                                          "period_id"];
                                                  print("Batch ID: $batchId");
                                                  print("Period ID: $periodId");

                                                  // Now, you have batchId and periodId. Send them to the backend as needed.
                                                  final idData = {
                                                    "batchId": batchId,
                                                    "periodId": periodId
                                                  };
                                                  final timeData = {
                                                    "startTime":
                                                        _startTimestamp,
                                                    "endTime": _endTimeStamp
                                                  };
                                                  final List<dynamic>
                                                      responseData = <dynamic>[
                                                    idData,
                                                    selectedBatchData,
                                                    timeData
                                                  ];
                                                  print("List $responseData");
                                                  _navigateToAttendancePage(
                                                      responseData, context);
                                                  // You can use a network request library like http package to send a POST request.
                                                } else {
                                                  print(
                                                      "Selected subject and batch combination not found.");
                                                }
                                              } catch (e) {
                                                print('An error occurred: $e');
                                              }
                                              setState(() {
                                                _isLoading = false;
                                              });
                                            }
                                          : null,
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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


  /*Future<dynamic> getBatchDetails() async {
    final url =
        Uri.parse('https://newsdcattendance.onrender.com/generateClasses');

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
        print(jsonResponse);

        if (jsonResponse['success'] == true) {
          final data = jsonResponse['data'];
          final batchData = data['batchData'] as List<dynamic>;

          if (batchData.isNotEmpty) {
            dynamic data;

            for (final batch in batchData) {
              if (batch["stream"] == _selectedStream &&
                  batch["semester"] == _selectedSemester &&
                  batch["batch"] == _selectedBatch) {
                final batchId = batch['batch_id'] as int;
                final subjCode = batch['subject_code'];

                data = [
                  batchId,
                  subjCode,
                  _selectedSemester,
                  _selectedStream,
                  _selectedBatch,
                  batch["subject_name"],
                  batch["course"]
                ];
                break;
              } else {
                print('No class found');
              }
            }

            print(data);
            return data;
          }
        } else {
          print('API request failed: ${jsonResponse['message']}');
        }
      } else {
        print('API request failed with status code: ${response.statusCode}');
      }

      return null; // Return null if the API response is invalid or no batch ID found
    } catch (e) {
      print('Exception in getBatchDetails(): $e');
      return null; // Return null in case of any exception
    }
  }*/
}

// String getCurrentDateTimeFormatted() {
//   DateTime now = DateTime.now();
//   String formattedDate = DateFormat('MM/dd/yyyy h:mm:ss a').format(now);
//   print(formattedDate);
//   return formattedDate;
// }

void _navigateToAttendancePage(
    List<dynamic> responseData, BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AttendancePage(responseData),
    ),
  );
}
