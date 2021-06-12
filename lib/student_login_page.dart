import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_app/password_change.dart';
import 'package:student_app/student_main_screen.dart';
import 'student_register_page.dart';
import 'package:student_app/Animation/FadeAnimation.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';

TextEditingController _textEditingController;

String FinalStudentEmail;
String FinalStudentPassword;
bool FinalStuLoggedinCheck;
final emailController = TextEditingController();
final passwordController = TextEditingController();

class StudentLogin extends StatefulWidget {
  @override
  _StudentLoginState createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {
  bool KeepMeLoggedIn = true;

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedStudentEmail = sharedPreferences.getString('studentemail');
    var obtainedStudentPassword =
        sharedPreferences.getString('studentpassword');
    bool KeepMeLoggedInCheck = sharedPreferences.getBool('keepStudentLoggedIn');
    setState(() {
      FinalStudentEmail = obtainedStudentEmail;
      FinalStudentPassword = obtainedStudentPassword;
      FinalStuLoggedinCheck = KeepMeLoggedInCheck;
    });
  }

  bool showSpinner = false;

  final _auth = FirebaseAuth.instance;

  String email;

  String password;

  String studentID;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SingleChildScrollView(
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeAnimation(
                      0.8,
                      Container(
                        height: 100.0,
                        width: 100.0,
                        margin: EdgeInsets.all(10.0),
                        child: Image(
                          image: AssetImage('images/panimalar_logo.png'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    FadeAnimation(
                      0.8,
                      Container(
                        margin: EdgeInsets.all(5.0),
                        child: Text(
                          'PANIMALAR ENGINEERING COLLEGE',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 10.0,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    FadeAnimation(
                      0.8,
                      Container(
                        margin: EdgeInsets.all(5.0),
                        child: Text(
                          'STUDENT LOGIN',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20.0,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Column(
                        children: <Widget>[
                          FadeAnimation(
                              0.8,
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Color.fromRGBO(143, 148, 251, .2),
                                          blurRadius: 20.0,
                                          offset: Offset(0, 10))
                                    ]),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[100]))),
                                      child: TextField(
                                        // controller: emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        onChanged: (value) {
                                          email = value;
                                          // value != null
                                          //     ? email = value
                                          //     : email = emailController.text;
                                          //Do something with the user input.
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'Email',
                                            labelStyle: TextStyle(
                                                color: Colors.deepPurple[200]),
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400])),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextField(
                                        controller: _textEditingController,
                                        obscureText: true,
                                        onChanged: (value) {
                                          password = value;
                                          // value != null
                                          //     ? password = value
                                          //     : password =
                                          //         passwordController.text;
                                          //Do something with the user input.
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'Password',
                                            labelStyle: TextStyle(
                                                color: Colors.deepPurple[200]),
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400])),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FadeAnimation(
                              2,
                              GestureDetector(
                                onTap: () async {
                                  if (KeepMeLoggedIn == true) {
                                    final SharedPreferences sharedPreferences =
                                        await SharedPreferences.getInstance();
                                    sharedPreferences.setString(
                                        'studentemail', email);
                                    sharedPreferences.setString(
                                        'studentpassword', password);
                                    sharedPreferences.setBool(
                                        'keepStudentLoggedIn', KeepMeLoggedIn);
                                    setState(() {
                                      showSpinner = true;
                                    });
                                  }
                                  try {
                                    if (email != null && password != null) {
                                      if (email.length > 13 &&
                                          email
                                                  .split('')
                                                  .reversed
                                                  .join()
                                                  .substring(0, 15) ==
                                              'moc.tnedutscep@') {
                                        final newStudent = await _auth
                                            .signInWithEmailAndPassword(
                                                email: email,
                                                password: password);
                                        if (newStudent != null) {
                                          studentID = _auth.currentUser.uid;
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
                                          // _textEditingController.clear();
                                          showSpinner = false;
                                        });
                                      } else {
                                        return showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                contentPadding:
                                                    EdgeInsets.all(20),
                                                title: Text(
                                                    'Please check your email'),
                                                content: Text(
                                                    'You must include @pecstudent.com'),
                                                actions: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        RaisedButton(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      10.0,
                                                                  horizontal:
                                                                      20.0),
                                                          color:
                                                              Color(0xFFFFFFFF),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false);
                                                            setState(() {
                                                              showSpinner =
                                                                  false;
                                                            });
                                                          },
                                                          child: Text(
                                                            "OK",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 17.0,
                                                              color: Color(
                                                                  0xFFEE6666),
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
                                    } else {
                                      return showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.all(20),
                                              title: Text(
                                                  'Please enter valid details'),
                                              // content: Text(
                                              //     'You must include @pecstudent.com'),
                                              actions: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      RaisedButton(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 10.0,
                                                                horizontal:
                                                                    20.0),
                                                        color:
                                                            Color(0xFFFFFFFF),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(false);
                                                          setState(() {
                                                            showSpinner = false;
                                                          });
                                                        },
                                                        child: Text(
                                                          "OK",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: 17.0,
                                                            color: Color(
                                                                0xFFEE6666),
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
                                    setState(() {
                                      showSpinner = false;
                                    });
                                  } catch (e) {
                                    return showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            contentPadding: EdgeInsets.all(20),
                                            title: Text('Login error!'),
                                            content: Text(e.toString()),
                                            actions: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    RaisedButton(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10.0,
                                                              horizontal: 20.0),
                                                      color: Color(0xFFFFFFFF),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(false);
                                                        setState(() {
                                                          showSpinner = false;
                                                        });
                                                      },
                                                      child: Text(
                                                        "OK",
                                                        style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontSize: 17.0,
                                                          color:
                                                              Color(0xFFEE6666),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          );
                                        });
                                    // print(e);
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(colors: [
                                        Color.fromRGBO(143, 148, 251, 1),
                                        Color.fromRGBO(143, 148, 251, .6),
                                      ])),
                                  child: Center(
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          FadeAnimation(
                              2,
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return StudentRegister(); //StaffChoose();
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(colors: [
                                        Color.fromRGBO(143, 148, 251, 1),
                                        Color.fromRGBO(143, 148, 251, .6),
                                      ])),
                                  child: Center(
                                    child: Text(
                                      "Register",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )),
                          SizedBox(
                            height: 70,
                          ),
                          FadeAnimation(
                              1.5,
                              TextButton(
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                      color: Color.fromRGBO(143, 148, 251, 1)),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return PasswordChangeScreen();
                                      },
                                    ),
                                  );
                                },
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
