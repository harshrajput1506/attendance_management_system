import 'dart:async';
import 'package:flutter/material.dart';
import 'login_api.dart';
import 'semesterpage.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final instructorIdController = TextEditingController();
  final _streamController = StreamController<String>();

  var instructor_id = "";

  @override
  void initState() {
    super.initState();
    instructorIdController.addListener(_checkInput);
  }

  @override
  void dispose() {
    instructorIdController.dispose();
    _streamController.close();
    super.dispose();
  }

  void _checkInput() {
    String value = instructorIdController.text.trim();
    RegExp regExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%$#@!]+');
    if (regExp.hasMatch(value)) {
      _streamController.add('Input must not contain special characters');
    } else {
      _streamController.add('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text("Forgot Password"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                        margin: const EdgeInsets.fromLTRB(43, 5, 43, 0),
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
                        margin: const EdgeInsets.fromLTRB(43, 10, 43, 0),
                        child: Text(
                          "East Delhi Campus",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.fromLTRB(43, 10, 43, 0),
                              child: Text(
                                "Reset Your Password",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 24,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.all(15),
                              child: SizedBox(
                                height: 400,
                                width: 364,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  color: Color.fromRGBO(4, 29, 83, 1),
                                  child: Form(
                                      key: _formKey,
                                      child: Column(children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20, top: 50),
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                          ),
                                          alignment: Alignment.center,
                                          child: TextFormField(
                                            cursorColor: Colors.black,
                                            decoration: InputDecoration(
                                              icon: Icon(
                                                Icons.email,
                                              ),
                                              hintText: "Enter ID",
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                            ),
                                            controller: instructorIdController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Enter your ID";
                                              } else if (value != null) {
                                                RegExp regExp = RegExp(
                                                    r'[!@#<>?":_`~;[\]\\|=+)(*&^%$#@!]+');
                                                if (regExp.hasMatch(value)) {
                                                  return 'Input must not contain special characters';
                                                }
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                instructor_id = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        StreamBuilder<String>(
                                          stream: _streamController.stream,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData &&
                                                snapshot.data!.isNotEmpty) {
                                              return Icon(
                                                Icons.error,
                                                color: Colors.red,
                                              );
                                            } else {
                                              return Container();
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: 20, right: 20, top: 10),
                                            padding: EdgeInsets.only(
                                                left: 20, right: 20),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1),
                                            ),
                                            alignment: Alignment.center,
                                            child: TextFormField(
                                                cursorColor: Colors.black,
                                                decoration: InputDecoration(
                                                  icon: Icon(
                                                    Icons.vpn_key,
                                                  ),
                                                  hintText: "Reset Password ",
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                ))),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20, top: 10),
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                          ),
                                          alignment: Alignment.center,
                                          child: TextFormField(
                                            cursorColor: Colors.black,
                                            decoration: InputDecoration(
                                              icon: Icon(
                                                Icons.vpn_key,
                                              ),
                                              hintText: "Confirm Password",
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20, top: 30),
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: Size(327, 69),
                                                backgroundColor: Color.fromRGBO(
                                                    0, 70, 121, 1),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                              ),
                                              child: Text(
                                                "Reset Password",
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              onPressed: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  // Perform reset password logic here
                                                }
                                              }),
                                        ),
                                      ])),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
