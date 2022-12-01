import 'package:flutter/material.dart';

import 'homepage.dart';

class SemesterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SemesterPageState();
}

class SemesterPageState extends State<SemesterPage> {
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
              child: Column(
                children: <Widget>[
                  Container(
                    // margin: const EdgeInsets.fromLTRB(120, 251, 0, 0),
                    // padding: const EdgeInsets.fromLTRB(120, 251, 0, 0),
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
                    // margin: const EdgeInsets.fromLTRB(43, 24, 43, 0),
                    child: Text(
                      "Professor",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    // color: Color.fromRGBO(4, 29, 83, 1),
                    // width: 320,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Container(
                            margin: EdgeInsets.all(10.0),
                            color: Color.fromRGBO(4, 29, 83, 1),
                            width: 320,
                            alignment: Alignment.center,
                            child: DropdownButton<String>(
                              underline: SizedBox(),
                              items: [
                                DropdownMenuItem<String>(
                                  value: "usar",
                                  child: Center(
                                    child: Text("USAR"),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: "usdi",
                                  child: Center(
                                    child: Text("USDI"),
                                  ),
                                ),
                              ],
                              onChanged: (_value) => {
                                print(_value.toString()),
                              },
                              hint: Text(
                                "Select School",
                                style: TextStyle(color: Colors.white),
                                ),
                            ),
                          ),
                        ),
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
                                  value: "aids",
                                  child: Center(
                                    child: Text("AIDS"),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: "aiml",
                                  child: Center(
                                    child: Text("AIML"),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: "iiot",
                                  child: Center(
                                    child: Text("IIOT"),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: "ar",
                                  child: Center(
                                    child: Text("AR"),
                                  ),
                                ),
                              ],
                              onChanged: (_value) => {
                                print(_value.toString()),
                              },
                              hint: Text(
                                "Select Course",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
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
                                  value: "b1",
                                  child: Center(
                                    child: Text("B1"),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: "b2",
                                  child: Center(
                                    child: Text("B2"),
                                  ),
                                ),
                              ],
                              onChanged: (_value) => {
                                print(_value.toString()),
                              },
                              hint: Text(
                                "Select Batch",
                                style: TextStyle(color: Colors.white),
                                ),
                            ),
                          ),
                        ),
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
                                  value: "one",
                                  child: Center(
                                    child: Text("1"),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: "two",
                                  child: Center(
                                    child: Text("2"),
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
                                "Select Semester",
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
                    minimumSize: Size(320, 50),
                    backgroundColor: Color.fromRGBO(0, 70, 121, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  child: Text("Continue",
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
