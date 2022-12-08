import 'package:flutter/material.dart';

import 'homepage.dart';

class SemesterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SemesterPageState();
}

class SemesterPageState extends State<SemesterPage> {
  //String value = " ";
  final List<String> _schools = [
    'USAR',
    'USDI',
  ];
  String? _dropDownValueOne;
  final List<String> _courses = ['AIDS', 'AIML', 'IIOT', 'AR'];
  String? _dropDownValueTwo;
  final List<String> _batch = ['B1', 'B2'];
  String? _dropDownValueThree;
  final List<String> _semester = ['1', '2', '3'];
  String? _dropDownValueFour;
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
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Container(
                              decoration:BoxDecoration(borderRadius: BorderRadius.circular(5),color: Color.fromRGBO(4, 29, 83, 1),),
                              margin: EdgeInsets.all(10.0),                              
                              width: 320,
                              alignment: Alignment.center,
                              child: DropdownButton<String>(
                                borderRadius: BorderRadius.circular(5),
                                isExpanded: true,
                                iconEnabledColor: Colors.white,
                                value: _dropDownValueOne,
                                underline: SizedBox(),
                                items: _schools
                                    .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Center(
                                          child: Text(
                                              item,
                                              style: TextStyle(
                                                fontSize: 18,
                                                color:Colors.white,
                                                ),
                                          ),
                                        ),
                                            ))
                                    .toList(),
                                onChanged: (item) =>
                                    setState(() => _dropDownValueOne = item!),
                                hint: Center(
                                  child: Text(
                                    "Select School",
                                    style: TextStyle(color: Colors.white,fontSize: 18,),
                                  ),
                                ),
                                dropdownColor: Color.fromRGBO(0, 70, 121, 1),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Container(
                              margin: EdgeInsets.all(10.0),
                              decoration:BoxDecoration(borderRadius: BorderRadius.circular(5),color: Color.fromRGBO(4, 29, 83, 1),),
                              width: 320,
                              alignment: Alignment.center,
                              child: DropdownButton<String>(
                                borderRadius: BorderRadius.circular(5),
                                isExpanded: true,
                                iconEnabledColor: Colors.white,
                                underline: SizedBox(),
                                value: _dropDownValueTwo,
                                items: _courses
                                    .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Center(
                                          child: Text(item,
                                              style: TextStyle(fontSize: 18,color:Colors.white,)),
                                        )))
                                    .toList(),
                                onChanged: (item) =>
                                    setState(() => _dropDownValueTwo = item!),
                                hint: Center(
                                  child: Text(
                                    "Select Branch",
                                    style: TextStyle(color: Colors.white,fontSize: 18,),
                                  ),
                                ),
                                dropdownColor: Color.fromRGBO(0, 70, 121, 1),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Container(
                              margin: EdgeInsets.all(10.0),
                              decoration:BoxDecoration(borderRadius: BorderRadius.circular(5),color: Color.fromRGBO(4, 29, 83, 1),),
                              width: 320,
                              alignment: Alignment.center,
                              child: DropdownButton<String>(
                                borderRadius: BorderRadius.circular(5),
                                isExpanded: true,
                                iconEnabledColor: Colors.white,
                                underline: SizedBox(),
                                value: _dropDownValueThree,
                                items: _batch
                                    .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Center(
                                          child: Text(item,
                                              style: TextStyle(fontSize: 18, color:Colors.white,)),
                                        )))
                                    .toList(),
                                onChanged: (item) =>
                                    setState(() => _dropDownValueThree = item!),
                                hint: Center(
                                  child: Text(
                                    "Select Batch",
                                    style: TextStyle(color: Colors.white,fontSize: 18,),
                                  ),
                                ),
                                dropdownColor: Color.fromRGBO(0, 70, 121, 1),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Container(
                              margin: EdgeInsets.all(10.0),
                              decoration:BoxDecoration(borderRadius: BorderRadius.circular(5),color: Color.fromRGBO(4, 29, 83, 1),),
                              width: 320,
                              alignment: Alignment.center,
                              child: DropdownButton<String>(
                                borderRadius: BorderRadius.circular(5),
                                isExpanded: true,
                                iconEnabledColor: Colors.white,
                                underline: SizedBox(),
                                value: _dropDownValueFour,
                                items: _semester
                                    .map((item) => DropdownMenuItem<String>(
                                        value: item, 
                                        child: Center(
                                          child: Text(item,
                                              style: TextStyle(fontSize: 18, color:Colors.white,)),
                                        )))
                                    .toList(),
                                onChanged: (item) =>
                                    setState(() => _dropDownValueFour = item!),
                                hint: Center(
                                  child: Text(
                                    "Select Semester",
                                    style: TextStyle(color: Colors.white,fontSize: 18,),
                                  ),
                                ),
                                dropdownColor: Color.fromRGBO(0, 70, 121, 1),
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
