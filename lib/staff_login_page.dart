import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_app/password_change.dart';
import 'package:student_app/staff_main_screen.dart';
import 'staff_register_page.dart';
import 'package:student_app/Animation/FadeAnimation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

TextEditingController _textEditingController;

String FinalStaffEmail;
String FinalStaffPassword;
bool FinalStaffLoggedinCheck;
final emailController = TextEditingController();
final passwordController = TextEditingController();

class StaffLogin extends StatefulWidget {
  @override
  _StaffLoginState createState() => _StaffLoginState();
}

class _StaffLoginState extends State<StaffLogin> {
  bool KeepMeLoggedIn = true;

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedStaffEmail = sharedPreferences.getString('staffemail');
    var obtainedStaffPassword = sharedPreferences.getString('staffpassword');
    bool KeepMeLoggedInCheck = sharedPreferences.getBool('keepStaffLoggedIn');
    setState(() {
      FinalStaffEmail = obtainedStaffEmail;
      FinalStaffPassword = obtainedStaffPassword;
      FinalStaffLoggedinCheck = KeepMeLoggedInCheck;
    });
  }

  bool showSpinner = false;

  final _auth = FirebaseAuth.instance;

  String email;

  String password;

  String staffID;

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
                          'STAFF LOGIN',
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
                                  final SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  sharedPreferences.setString(
                                      'staffemail', email);
                                  sharedPreferences.setString(
                                      'staffpassword', password);
                                  sharedPreferences.setBool(
                                      'keepStaffLoggedIn', KeepMeLoggedIn);
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  // print(name);
                                  // print(email);
                                  // print(password);
                                  try {
                                    if (email != null && password != null) {
                                      if (email.length > 13 &&
                                          email
                                                  .split('')
                                                  .reversed
                                                  .join()
                                                  .substring(0, 13) ==
                                              'moc.ffatscep@') {
                                        final newStaff = await _auth
                                            .signInWithEmailAndPassword(
                                                email: email,
                                                password: password);
                                        if (newStaff != null) {
                                          staffID = _auth.currentUser.uid;
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
                                                    'You must include @pecstaff.com'),
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
                                              //     'You must include @pecstaff.com'),
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
                                        return StaffRegister(); //StaffChoose();
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
