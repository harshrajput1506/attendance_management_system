import 'package:flutter/material.dart';

class SemesterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SemesterPageState();
}

class SemesterPageState extends State<SemesterPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Color.fromRGBO(255, 255, 255, 1),
       body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Center(
                  child: Image.asset(
                    "assets/images/img_ggsipulogo1.png",
                    height: 132.00,
                    width: 150.00,
                  ), 
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.fromLTRB(43, 0, 43, 0),
                      child: Text(
                        "Guru Gobind Singh Indraprastha University",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(43, 24, 43, 0),
                      child: Text(
                        "East Delhi Campus",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(327, 69),
                      backgroundColor: Color.fromRGBO(0, 70, 121, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                      ),
                    ),
                    child: Text("Get Started",
                        style: TextStyle(
                            fontSize: 22,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600)),
                            
                    onPressed: () {}
               ),
              ),
            ],
          ),
        ),
    );
  }
}
