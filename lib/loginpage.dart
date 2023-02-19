import 'package:flutter/material.dart';

import 'semesterpage.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
          // leading: IconButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          //   icon: Icon(
          //     Icons.arrow_back_ios,
          //     size: 20,
          //     color: Colors.black,
          //   ),
          // )
        ),
        body: Container(
          key: _formkey,
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
                          child: Column(
                            children: <Widget>[
                              // container 1
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
                                      hintText: "Enter Email",
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    controller: emailController,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return "Please Enter email";
                                      }

                                      if (!RegExp(
                                              "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                          .hasMatch(value)) {
                                        return "Please enter valid email";
                                      }

                                      return null;
                                    }),
                              ),
                              // container 2
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
                                    obscureText: true,
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      icon: Icon(
                                        Icons.vpn_key,
                                      ),
                                      hintText: "Enter Password",
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    controller: passwordController,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return "Please Enter password";
                                      }
                                      return null;
                                    }),
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
                                    onPressed: () {
                                      if (_formkey.currentState != null) {
                                        _formkey.currentState?.validate();
                                        print("Successfully logged in");
                                      } else {
                                        print("Unsuccessful login");
                                      }
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SemesterPage()));
                                    }),
                              ),
                            ],
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
