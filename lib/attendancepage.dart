import 'package:attendance_management_system/attendanceModel.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

import 'lastpage.dart';

class AttendancePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AttendancePageState();
}

class AttendancePageState extends State<AttendancePage> {

  List<AttendanceModel> students = [
    AttendanceModel("Shubh", "03519011721", true),
    AttendanceModel("Ayush", "09919011721", true),
    AttendanceModel("Priyanshu", "13919011721", true),
    AttendanceModel("Harsh", "20219011721", true),
    AttendanceModel("Lakshay", "03719011721", true),
    AttendanceModel("Sarthak", "05517011721", true),
    AttendanceModel("Chaitanya", "10519011721", true),
    AttendanceModel("Parth", "00519011721", true),
    AttendanceModel("Fraz", "07519011721", true),
    AttendanceModel("Babbar", "07519011721", true),
    AttendanceModel("Nishant", "09519011721", true),
    AttendanceModel("Yash", "08519011721", true),
    AttendanceModel("Sahil", "04519011721", true),
  ];

  List<AttendanceModel> selectionStudents = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        return StudentItem(
                            students[index].name,
                            students[index].enrollmentNo,
                            students[index].isSelected,
                            index);
                      }),
                ),
              ),
              Padding(padding: EdgeInsets.all(15)),
              SizedBox(
                height: 50,
                width: 320,
                child: SlideAction(
                    outerColor: Color.fromRGBO(0, 70, 121, 1),
                    innerColor: Colors.white,
                    child: Text("Submit",
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        )),
                    onSubmit: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubmitPage()));
                    }),
              ),
              Padding(padding: EdgeInsets.all(15)),
            ],
          ),
        ),
      ),
    );
  }

  Widget StudentItem(
      String name, String enrollmentNo, bool isSelected, int index) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Color.fromRGBO(4, 29, 83, 1),
        child: Icon(
          Icons.person_outline_outlined,
          color: Colors.white,
        ),
      ),
      title: Text(
        name,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(enrollmentNo),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: Color.fromRGBO(4, 29, 83, 1),
            )
          : Icon(Icons.check_circle_outline_outlined, color: Colors.grey),
      onTap: () {
        setState(() {
          students[index].isSelected = !students[index].isSelected;
          if (students[index].isSelected == true) {
            selectionStudents.add(AttendanceModel(name, enrollmentNo, false));
          } else if (students[index].isSelected == false) {
            selectionStudents
                .removeWhere((element) => element.name == students[index].name);
          }
        });
      },
    );
  }
}
