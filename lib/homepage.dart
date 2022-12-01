import 'package:flutter/material.dart';

import 'attendancepage.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String value = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: 50,
              child: Center(
                child: Icon(
                  Icons.person_rounded,
                  size: 60,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.fromLTRB(43, 0, 43, 0),
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
                            color: Color.fromRGBO(4, 29, 83, 1),
                            width: 320,
                            alignment: Alignment.center,
                            child: DropdownButton<String>(
                              underline: SizedBox(),
                              items: [
                                DropdownMenuItem<String>(
                                  value: "Computer Networks",
                                  child: Center(
                                    child: Text("Computer Networks"),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: "AI & its applications",
                                  child: Center(
                                    child: Text("AI & its Applications"),
                                  ),
                                ),
                              ],
                              onChanged: (_value) => {
                                print(_value.toString()),
                                setState(() {
                                  value = _value!;
                                }),
                              },
                              hint: Text(
                                "Select Subject",
                                style: TextStyle(color: Colors.white),
                                ),
                            ),
                          ),
                        ),
                        Text(
                          "$value",
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
