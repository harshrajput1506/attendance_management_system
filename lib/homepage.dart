import 'package:flutter/material.dart';

import 'attendancepage.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final List<String> _subjects = [
    'Computer Networks',
    'AI & its applications',
  ];
  String? _dropDownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: 2,
              child: Center(
                child: Icon(
                  Icons.person_rounded,
                  size: 60,
                ),
              ),
            ),
            Container(
              // alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Container(
                    // margin: const EdgeInsets.fromLTRB(43, 0, 43, 0),
                    child: Text(
                      "Rahul Johari",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(43, 24, 43, 0),
                    child: Text(
                      "Professor",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Container(
                            margin: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromRGBO(4, 29, 83, 1),
                            ),
                            width: 320,
                            alignment: Alignment.center,
                            child: DropdownButton<String>(
                              borderRadius: BorderRadius.circular(5),
                              isExpanded: true,
                              underline: SizedBox(),
                              value: _dropDownValue,
                              items: _subjects
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Center(
                                          child: Text(
                                            item,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (item) =>
                                  setState(() => _dropDownValue = item!),
                              hint: Center(
                                child: Text(
                                  "Select Subject",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              dropdownColor: Color.fromRGBO(0, 70, 121, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(327, 50),
                    backgroundColor: Color.fromRGBO(0, 70, 121, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  child: Text("Start Class",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AttendancePage()));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
