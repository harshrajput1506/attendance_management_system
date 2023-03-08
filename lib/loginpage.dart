// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';

import 'login_api.dart';
import 'semesterpage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final instructorIdController = TextEditingController();
  final passwordController = TextEditingController();
  final _streamController = StreamController<String>();

  bool _isObscure = true;

  var instructor_id = "";
  var password = "";

  @override
  void initState() {
    super.initState();
    instructorIdController.addListener(_checkInput);
  }

  @override
  void dispose() {
    instructorIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _checkInput() {
    String value = instructorIdController.text.trim();
    RegExp regExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%$#@!]+');
    if (regExp.hasMatch(value)) {
      _streamController.add('Input must not contain special characters');
    } else {
      return;
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
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.all(15),
                      child: SizedBox(
                        height: 430,
                        width: 364,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          color: Color.fromRGBO(4, 29, 83, 1),
                          child: Form(
                            key: _formkey,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, top: 100),
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Color.fromRGBO(255, 255, 255, 1),
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
                                      if (value == null || value.isEmpty) {
                                        return "Enter your ID";
                                      } else if (value != null) {
                                        RegExp regExp = RegExp(
                                            r'[!@#<>?":_`~;[\]\\|=+)(*&^%$#@!]+');
                                        if (regExp.hasMatch(value)) {
                                          return 'Input must not contain special characters';
                                        }
                                      } else {
                                        return null;
                                      }
                                    },
                                    onChanged: (value) {
                                      instructor_id = value;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                StreamBuilder<String>(
                                  stream: _streamController.stream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, top: 30),
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                  alignment: Alignment.center,
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    obscureText: _isObscure,
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      icon: Icon(
                                        Icons.vpn_key,
                                      ),
                                      suffixIcon: IconButton(
                                          onPressed: (() {
                                            setState(() {
                                              _isObscure = !_isObscure;
                                            });
                                          }),
                                          icon: Icon(_isObscure
                                              ? Icons.visibility_off
                                              : Icons.visibility)),
                                      hintText: "Enter Password",
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    controller: passwordController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please Enter password";
                                      } else if (value.length < 4) {
                                        return "atleast 4 characters";
                                      }
                                    },
                                    onChanged: (value) {
                                      password = value;
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, top: 30),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(327, 69),
                                      backgroundColor:
                                          Color.fromRGBO(0, 70, 121, 1),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                    child: Text("Login",
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w600)),
                                    onPressed: () async {
                                      if (_formkey.currentState!.validate()) {
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             SemesterPage()));
                                        await login(
                                            context, instructor_id, password);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
        ));
  }
}
