import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_app/Animation/FadeAnimation.dart';
import 'package:smart_select/smart_select.dart';
import 'package:student_app/google_account_link.dart';
import 'choices.dart' as choices;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StudentRegister extends StatefulWidget {
  @override
  _StudentRegisterState createState() => _StudentRegisterState();
}

class _StudentRegisterState extends State<StudentRegister> {
  int subjectnum;
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;
  User loggedInUser;
  String studentID;
  String name;
  String email;
  String password;
  String department;
  String classID;
  String rollno;
  String regno;
  String recoveryMail;
  int year = 1;
  int sem;
  bool backlog = false;
  int backlognumber;
  List<String> _subjectcode = [];

  // addBacklogDetails(String stuid) async {
  //   DocumentReference docref =
  //       FirebaseFirestore.instance.collection('students').doc(stuid);
  //   DocumentSnapshot doc = await docref.get();
  //   List backlogs = doc.data()['backlogs'];
  //   if (backlogs.contains(_subjectcode) == true) {
  //     FirebaseFirestore.instance
  //         .collection('students')
  //         .doc(stuid)
  //         .update({"data": FieldValue.arrayUnion(_subjectcode)});
  //
  //     docref.update({
  //       'backlogs': FieldValue.arrayRemove([_subjectcode])
  //     });
  //   } else {
  //     docref.update({
  //       'backlogs': FieldValue.arrayUnion([_subjectcode])
  //     });
  //   }
  // }

  // Map data;
  // addData() async {
  //   final student = await _auth.currentUser;
  //   loggedInUser = student;
  //   studentID = loggedInUser.uid;
  //   final students = await _store.collection('students').get();
  //   DocumentReference documentReference =
  //       FirebaseFirestore.instance.collection('students').doc(studentID);
  //   for (var stucheck in students.docs) {
  //     final email = stucheck.data()['email'];
  //     if (studentID == email) {
  //       setState(() {
  //         for (var i = 0; i <= _subjectcode.length; i++) {
  //           Map<String, dynamic> demodata = {
  //             "subject$subjectnum": "$_subjectcode[$subjectnum]",
  //           };
  //           documentReference.set(demodata);
  //         }
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                                          'STUDENT REGISTER',
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
                                            hintText: "@ pecstudent.com",
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
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
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
                                              color: Color.fromRGBO(
                                                  143, 148, 251, .2),
                                              blurRadius: 20.0,
                                              offset: Offset(0, 10))
                                        ]),
                                    child: Column(
                                      children: <Widget>[
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
                                                    color:
                                                        Colors.deepPurple[200]),
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
                                              classID = value;
                                              //Do something with the user input.
                                            },
                                            decoration: InputDecoration(
                                                labelText: "Class ID",
                                                labelStyle: TextStyle(
                                                    color:
                                                        Colors.deepPurple[200]),
                                                border: InputBorder.none,
                                                hintText: "for eg., 17CSED",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey[400])),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(8.0),
                                          child: TextField(
                                            onChanged: (value) {
                                              rollno = value;
                                              //Do something with the user input.
                                            },
                                            decoration: InputDecoration(
                                                labelText: "Roll No.",
                                                labelStyle: TextStyle(
                                                    color:
                                                        Colors.deepPurple[200]),
                                                border: InputBorder.none,
                                                hintText:
                                                    "for eg., 2017PECCS258",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey[400])),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(8.0),
                                          child: TextField(
                                            onChanged: (value) {
                                              regno = value;
                                              //Do something with the user input.
                                            },
                                            decoration: InputDecoration(
                                                labelText: "Reg No.",
                                                labelStyle: TextStyle(
                                                    color:
                                                        Colors.deepPurple[200]),
                                                border: InputBorder.none,
                                                hintText:
                                                    "for eg., 211417104243",
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
                                                    color:
                                                        Colors.deepPurple[200]),
                                                border: InputBorder.none,
                                                hintText: "Your personal email",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey[400])),
                                          ),
                                        )
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
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
                                            color: Color.fromRGBO(
                                                143, 148, 251, .2),
                                            blurRadius: 20.0,
                                            offset: Offset(0, 10))
                                      ]),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, top: 8, right: 8),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: Text(
                                                "Backlogs",
                                                style: TextStyle(
                                                  //fontFamily: 'Montserrat',
                                                  fontSize: 20.0,
                                                  //color: Colors.black54,
                                                  //fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 5),
                                              child: Switch(
                                                value: backlog,
                                                onChanged: (value) {
                                                  setState(() {
                                                    backlog = value;
                                                    print(backlog);
                                                  });
                                                },
                                                activeTrackColor:
                                                    Color.fromRGBO(
                                                        143, 148, 251, 1),
                                                activeColor: Color.fromRGBO(
                                                    143, 148, 251, .6),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 0),
                                        child: Text(
                                            'Click on + icon to add or search for subjects'),
                                      ),
                                      Container(
                                        child: Column(
                                          children: [
                                            Card(
                                              elevation: 3,
                                              margin: const EdgeInsets.all(5),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.0)),
                                              ),
                                            ),
                                            SmartSelect<String>.multiple(
                                              title: 'Choose subject',
                                              value: _subjectcode,
                                              choiceItems: S2Choice.listFrom<
                                                  String, Map>(
                                                source: choices.subjectcode,
                                                value: (index, item) =>
                                                    item['value'],
                                                title: (index, item) =>
                                                    item['title'],
                                                group: (index, item) =>
                                                    item['department'],
                                              ),
                                              onChange: (state) {
                                                setState(() {
                                                  _subjectcode = state.value;
                                                  backlognumber =
                                                      _subjectcode.length;
                                                  print(backlognumber);
                                                });
                                              },
                                              modalType:
                                                  S2ModalType.bottomSheet,
                                              modalConfirm: true,
                                              modalFilter: true,
                                              choiceGrouped: true,
                                              tileBuilder: (context, state) {
                                                return Card(
                                                  elevation: 3,
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.0)),
                                                  ),
                                                  child: S2Tile.fromState(
                                                    state,
                                                    hideValue: true,
                                                    title: const Text(
                                                        'Choose Subject'),
                                                    trailing: const Icon(Icons
                                                        .add_circle_outline),
                                                    body: S2TileChips(
                                                      chipLength: state
                                                          .valueObject.length,
                                                      chipLabelBuilder:
                                                          (context, i) {
                                                        return Text(state
                                                            .valueObject[i]
                                                            .title);
                                                      },
                                                      chipOnDelete: (i) {
                                                        setState(() {
                                                          _subjectcode.remove(
                                                              state
                                                                  .valueObject[
                                                                      i]
                                                                  .value);
                                                          backlognumber =
                                                              _subjectcode
                                                                      .length -
                                                                  1;
                                                          print(backlognumber);
                                                        });
                                                      },
                                                      chipColor: Colors
                                                          .deepPurple[200],
                                                      chipRaised: true,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          FadeAnimation(
                              1.0,
                              GestureDetector(
                                onTap: () async {
                                  final SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  sharedPreferences.setString(
                                      'studentemail', email);
                                  sharedPreferences.setString(
                                      'studentpassword', password);
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  if (_subjectcode.length >= 1 &&
                                      backlog == false) {
                                    return showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            contentPadding: EdgeInsets.all(20),
                                            title: Text(
                                                'Please switch on the backlogs'),
                                            content: Text(
                                                'You must check the backlogs switch button if you have backlogs. If you dont have backlogs please switch it back off.'),
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
                                  }
                                  try {
                                    if (email != null &&
                                        password != null &&
                                        department.length == 3 &&
                                        classID.length == 6 &&
                                        recoveryMail != null) {
                                      if (email.length > 15 &&
                                          email
                                                  .split('')
                                                  .reversed
                                                  .join()
                                                  .substring(0, 15) ==
                                              'moc.tnedutscep@') {
                                        final newStudent = await _auth
                                            .createUserWithEmailAndPassword(
                                                email: email,
                                                password: password);
                                        User student = newStudent.user;
                                        String stuid = student.uid;
                                        _store
                                            .collection('students')
                                            .doc(stuid)
                                            .set({
                                          'name': name,
                                          'department': department,
                                          'email': email,
                                          'classID': classID,
                                          'regno': regno,
                                          'rollno': rollno,
                                          'backlogs': backlog,
                                          'backlognumber': backlognumber,
                                          "backlogsubs": _subjectcode,
                                          "recoveryMail": recoveryMail,
                                        });
                                        //addBacklogDetails(stuid);
                                        //addData();
                                        if (newStudent != null) {
                                          studentID = _auth.currentUser.uid;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return GoogleAccountLink(
                                                  studentOrStaff: 'student',
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
                                            title: Text(e.toString()),
                                            // content: Text(
                                            //     'You must include @pecstudent.com'),
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
