import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_app/staff_login_page.dart';
import 'package:student_app/staff_main_screen.dart';
import 'package:student_app/student_main_screen.dart';
import 'package:student_app/tabs_staff.dart';
import 'student_or_staff.dart';
import 'package:student_app/Animation/FadeAnimation.dart';
import 'package:firebase_auth/firebase_auth.dart';

String FinalStudentEmail;
String FinalStudentPassword;
bool FinalStuLoggedinCheck;
String FinalStaffEmail;
String FinalStaffPassword;
bool FinalStaffLoggedinCheck;
final _auth = FirebaseAuth.instance;

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool showSpinner = false;

  initState() {
    setState(() {
      getValidationData();
    });
    super.initState();
  }

  Future deleteDependencies() async {
    bool deletekeep = false;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString('studentemail', null);
    sharedPreferences.setString('studentpassword', null);
    sharedPreferences.setBool('keepStudentLoggedIn', deletekeep);
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedStudentEmail = sharedPreferences.getString('studentemail');
    var obtainedStudentPassword =
        sharedPreferences.getString('studentpassword');
    bool KeepStuLoggedInCheck =
        sharedPreferences.getBool('keepStudentLoggedIn');
    setState(() {
      FinalStudentEmail = obtainedStudentEmail;
      FinalStudentPassword = obtainedStudentPassword;
      FinalStuLoggedinCheck = KeepStuLoggedInCheck;
    });
    var obtainedStaffEmail = sharedPreferences.getString('staffemail');
    var obtainedStaffPassword = sharedPreferences.getString('staffpassword');
    bool KeepStaffLoggedInCheck =
        sharedPreferences.getBool('keepStaffLoggedIn');
    setState(() {
      FinalStaffEmail = obtainedStaffEmail;
      FinalStaffPassword = obtainedStaffPassword;
      FinalStaffLoggedinCheck = KeepStaffLoggedInCheck;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  // height: 150.0,
                  // width: 150.0,
                  margin: EdgeInsets.all(10.0),
                  child: Image(
                    image: AssetImage('images/Main Screen.png'),
                    width: 300,
                    height: 300,
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              SizedBox(
                height: 15.0,
              ),
              Center(
                child: Container(
                  child: FadeAnimation(
                      0.8,
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          print(FinalStudentEmail);
                          try {
                            if (FinalStudentEmail != null ||
                                FinalStaffEmail != null) {
                              if (FinalStuLoggedinCheck == true ||
                                  FinalStaffLoggedinCheck == true) {
                                if (FinalStudentEmail != null) {
                                  final newStudent =
                                      await _auth.signInWithEmailAndPassword(
                                          email: FinalStudentEmail,
                                          password: FinalStudentPassword);
                                  if (newStudent != null) {
                                    var studentID = _auth.currentUser.uid;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return StudentMainScreen(); //StaffChoose();
                                        },
                                      ),
                                    );
                                  }
                                  setState(() {
                                    showSpinner = false;
                                  });
                                } else if (FinalStaffEmail != null) {
                                  final newStaff =
                                      await _auth.signInWithEmailAndPassword(
                                          email: FinalStaffEmail,
                                          password: FinalStaffPassword);
                                  if (newStaff != null) {
                                    var staffID = _auth.currentUser.uid;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return StaffMainScreen(); //StaffChoose();
                                        },
                                      ),
                                    );
                                  }
                                  setState(() {
                                    showSpinner = false;
                                  });
                                }
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return StudentOrStaff(); //StaffChoose();
                                    },
                                  ),
                                );
                              }
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return StudentOrStaff(); //StaffChoose();
                                  },
                                ),
                              );
                            }
                          } catch (e) {
                            return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    contentPadding: EdgeInsets.all(20),
                                    title: Text(
                                        'Error logging in ! Do you wish to login again ?'),
                                    content: Text(e.toString()),
                                    actions: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            RaisedButton(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 20.0),
                                              color: Color(0xFFFFFFFF),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              onPressed: () {
                                                SystemNavigator.pop();
                                              },
                                              child: Text(
                                                "NO",
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 17.0,
                                                  color: Color(0xFFEE6666),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            RaisedButton(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 20.0),
                                              color: Color(0xFFEE6666),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              onPressed: () {
                                                deleteDependencies()
                                                    .whenComplete(() {
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      Screen2()),
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false);
                                                });
                                              },
                                              child: Text(
                                                "YES",
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 17.0,
                                                  color: Color(0xFFFFFFFF),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                });
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(143, 148, 251, 1),
                                Color.fromRGBO(143, 148, 251, .6),
                              ])),
                          child: Center(
                            child: Text(
                              "CONTINUE",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
