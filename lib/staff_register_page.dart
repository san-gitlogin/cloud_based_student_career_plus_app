import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_app/Animation/FadeAnimation.dart';
import 'package:student_app/google_account_link.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StaffRegister extends StatefulWidget {
  @override
  _StaffRegisterState createState() => _StaffRegisterState();
}

class _StaffRegisterState extends State<StaffRegister> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;
  String staffID;
  String name;
  String email;
  String password;
  String department;
  String designation;
  String recoveryMail;

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
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FadeAnimation(
                                0.8,
                                Flexible(
                                  child: Container(
                                    height: 70.0,
                                    width: 70.0,
                                    //margin: EdgeInsets.all(10.0),
                                    child: Image(
                                      image: AssetImage(
                                          'images/panimalar_logo.png'),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  FadeAnimation(
                                    0.8,
                                    Flexible(
                                      child: Container(
                                        margin: EdgeInsets.all(5.0),
                                        child: Text(
                                          'PANIMALAR ENGINEERING COLLEGE',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 12.0,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  FadeAnimation(
                                    0.8,
                                    Flexible(
                                      child: Container(
                                        margin: EdgeInsets.all(5.0),
                                        child: Text(
                                          'STAFF REGISTER',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 20.0,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: [
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
                                        onChanged: (value) {
                                          name = value;
                                          //Do something with the user input.
                                        },
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Name",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400])),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        onChanged: (value) {
                                          email = value;
                                          //Do something with the user input.
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'Email',
                                            labelStyle: TextStyle(
                                                color: Colors.deepPurple[200]),
                                            border: InputBorder.none,
                                            hintText: "@ pecstaff.com",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400])),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextField(
                                        obscureText: true,
                                        onChanged: (value) {
                                          password = value;
                                          //Do something with the user input.
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'Password',
                                            labelStyle: TextStyle(
                                                color: Colors.deepPurple[200]),
                                            border: InputBorder.none,
                                            hintText:
                                                "Password must be 6 characters or above",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400])),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextField(
                                        onChanged: (value) {
                                          department = value;
                                          //Do something with the user input.
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'Department',
                                            labelStyle: TextStyle(
                                                color: Colors.deepPurple[200]),
                                            border: InputBorder.none,
                                            hintText: "for eg., CSE ",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400])),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextField(
                                        onChanged: (value) {
                                          designation = value;
                                          //Do something with the user input.
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'Designation',
                                            labelStyle: TextStyle(
                                                color: Colors.deepPurple[200]),
                                            border: InputBorder.none,
                                            hintText:
                                                "for eg., Head Of Department ",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400])),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextField(
                                        onChanged: (value) {
                                          recoveryMail = value;
                                          //Do something with the user input.
                                        },
                                        decoration: InputDecoration(
                                            labelText: "Recovery email",
                                            labelStyle: TextStyle(
                                                color: Colors.deepPurple[200]),
                                            border: InputBorder.none,
                                            hintText: "Your personal email",
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
                          FadeAnimation(
                              1.0,
                              GestureDetector(
                                onTap: () async {
                                  final SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  sharedPreferences.setString(
                                      'staffemail', email);
                                  sharedPreferences.setString(
                                      'staffpassword', password);
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  // print(name);
                                  // print(email);
                                  // print(password);
                                  try {
                                    if (email != null &&
                                        password != null &&
                                        department.length == 3 &&
                                        designation != null &&
                                        recoveryMail != null) {
                                      if (email.length > 13 &&
                                          email
                                                  .split('')
                                                  .reversed
                                                  .join()
                                                  .substring(0, 13) ==
                                              'moc.ffatscep@') {
                                        final newStaff = await _auth
                                            .createUserWithEmailAndPassword(
                                                email: email,
                                                password: password);
                                        User staff = newStaff.user;
                                        String staffid = staff.uid;
                                        _store.collection('staffs')
                                          ..doc(staffid).set({
                                            'Name': name,
                                            'department': department,
                                            'email': email,
                                            'designation': designation,
                                            "recoveryMail": recoveryMail,
                                          });
                                        if (newStaff != null) {
                                          staffID = _auth.currentUser.uid;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return GoogleAccountLink(
                                                  studentOrStaff: 'staff',
                                                );
                                              },
                                            ),
                                          );
                                        }
                                        setState(() {
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
                                            title: Text(e.toString()),
                                            // content: Text(
                                            //     'You must include @pecstaff.com'),
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
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 1, vertical: 30),
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
                                ),
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
