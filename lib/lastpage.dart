import 'package:flutter/material.dart';

class SubmitPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SubmitPageState();
}

class SubmitPageState extends State<SubmitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.fromLTRB(43, 0, 43, 0),
                      child: CircleAvatar(
                          backgroundColor: Color.fromRGBO(0, 70, 121, 1),
                          child: Icon(
                            Icons.done_rounded,
                            size: 20,
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(43, 24, 43, 0),
                      child: Text(
                        "Attendance Submitted",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 30,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height: 100,
        color: Color.fromRGBO(0, 70, 121, 1),
        child: Center(
          child: Text('For any queries, mail us at sdc.usict@gmail.com',style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
