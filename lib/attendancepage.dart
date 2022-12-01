import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

import 'lastpage.dart';

class AttendancePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AttendancePageState();
}

class AttendancePageState extends State<AttendancePage> {
  final List students = [
    "Ayush",
    "Shubh",
    "Priyanshu",
    "Ayush",
    "Shubh",
    "Priyanshu",
    "Ayush",
    "Shubh",
    "Priyanshu",
    "Ayush",
    "Shubh",
    "Priyanshu",
    "Ayush",
    "Shubh",
    "Priyanshu",
    "Ayush",
    "Shubh",
    "Priyanshu",
    "Ayush",
    "Shubh",
    "Priyanshu",
    "Ayush",
    "Shubh",
    "Priyanshu",
    "Ayush",
    "Shubh",
    "Priyanshu",
  ];
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 150,
              child: Center(
                child: Text(
                  "Computer Networks",
                  style: TextStyle(
                      fontSize: 27,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              child: Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: students.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.person),
                          title: Text(students[index]),
                          trailing: Container(
                            height: 50,
                            width: 80,
                            child: Center(
                              child: LiteRollingSwitch(
                                value: isSwitched,
                                textOn: "P",
                                textOff: "A",
                                colorOn: Colors.greenAccent,
                                colorOff: Colors.redAccent,
                                iconOn: Icons.done,
                                iconOff: Icons.alarm_off,
                                textSize: 15,
                                onTap: () {},
                                onDoubleTap: () {},
                                onSwipe: () {},
                                onChanged: (value) {
                                  print("the button is $value");
                                  setState(() {
                                    isSwitched = !isSwitched;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
            Padding(padding: EdgeInsets.all(15)),
            Container(
              height: 50,
              width: 320,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(320, 50),
                    backgroundColor: Color.fromRGBO(0, 70, 121, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  child: Text("Submit",
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SubmitPage()));
                  }),
            ),
            Padding(padding: EdgeInsets.all(15)),
          ],
        ),
      ),
    );
  }
}
