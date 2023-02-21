// // import 'dart:async';
// import 'package:attendance_management_system/semesterpage.dart';
// import 'package:flutter/material.dart';
// import 'loginpage.dart';

// class GetStartedPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => InitState();
// }

// class InitState extends State<GetStartedPage> {
//   @override
//   Widget build(BuildContext context) {
//     return initWidget();

//   }
//   }
//   Widget initWidget() {
//     return SafeArea(

//       child: Scaffold(
//         backgroundColor: Color.fromRGBO(255, 255, 255, 1),
//         body: Container(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Container(
//                 child: Center(
//                   child: Image.asset(
//                     "assets/images/img_ggsipulogo1.png",
//                     height: 132.00,
//                     width: 150.00,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 30,
//               ),
//               Container(
//                 child: Column(
//                   children: <Widget>[
//                     Container(
//                       margin: const EdgeInsets.fromLTRB(43, 0, 43, 0),
//                       child: Text(
//                         "Guru Gobind Singh Indraprastha University",
//                         style: TextStyle(
//                           fontFamily: "Poppins",
//                           fontSize: 24,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     Container(
//                       margin: const EdgeInsets.fromLTRB(43, 24, 43, 0),
//                       child: Text(
//                         "East Delhi Campus",
//                         style: TextStyle(
//                           fontFamily: "Poppins",
//                           fontSize: 20,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Container(
//               //   child: ElevatedButton(
//               //       style: ElevatedButton.styleFrom(
//               //         minimumSize: Size(327, 69),
//               //         backgroundColor: Color.fromRGBO(0, 70, 121, 1),
//               //         shape: RoundedRectangleBorder(
//               //             borderRadius: BorderRadius.circular(50)),
//               //       ),
//               //       child: Text("Get Started",
//               //           style: TextStyle(
//               //               fontSize: 22,
//               //               fontFamily: "Poppins",
//               //               fontWeight: FontWeight.w600)),
//               //       onPressed: () {
//               //         Navigator.push(
//               //             context,
//               //             MaterialPageRoute(
//               //                 builder: (context) => LoginScreen()));
//               //       }),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:attendance_management_system/homepage.dart';
import 'package:attendance_management_system/loginpage.dart';
import 'package:flutter/material.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({super.key});

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => LoginScreen(),
        ),
      );
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/img_ggsipulogo1.png",
            height: 132.00,
            width: 150.00,
          ),
          SizedBox(
            height: 30,
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
        ],
      ),
    ));
  }
}
