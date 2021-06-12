import 'dart:ffi';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_app/google_account_link.dart';
import 'package:student_app/student_or_staff.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseMessaging _fcm = FirebaseMessaging();
final _auth = FirebaseAuth.instance;
final _store = FirebaseFirestore.instance;
User loggedInUser;
String userDocumentID;
String fcmToken;
List providerdata;
bool hasGoogle = false;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Color get primaryColor => Theme.of(context).primaryColor;
  String staffID;
  String NameOfStaff;
  String IdOfStaff;
  String DepartmentOfStaff;
  String DesignationOfStaff;

  Future unlinkAccount() async {
    try {
      await loggedInUser.unlink("google.com").whenComplete(() {
        setState(() {
          hasGoogle = false;
        });
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.all(20),
          title: Text('Account unlinked successfully'),
          content: Text(
              'The google account linked with this profile is unlinked successfully, please link an account by logging out and loggin in'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  RaisedButton(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    color: Color(0xFFFFFFFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      setState(() {
                        showSpinner = false;
                      });
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 17.0,
                        color: Color(0xFFEE6666),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      });
    } catch (e) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.all(20),
        title: Text('Error occurred !'),
        content: Text(e.toString()),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                RaisedButton(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  color: Color(0xFFFFFFFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    setState(() {
                      showSpinner = false;
                    });
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 17.0,
                      color: Color(0xFFEE6666),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      );
    }
  }

  Future getValidationData(bool LogOut, String deviceToken) async {
    bool FinalStaffLoggedinCheck = LogOut;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString('staffemail', null);
    sharedPreferences.setString('staffpassword', null);
    sharedPreferences.setBool('keepStaffLoggedIn', FinalStaffLoggedinCheck);
    await _store
        .collection('staffs')
        .doc(userDocumentID)
        .collection('tokens')
        .doc(deviceToken)
        .delete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loggedInUser = _auth.currentUser;
    providerdata = loggedInUser.providerData;
    if (providerdata.length > 1) {
      hasGoogle = true;
    }
    print(providerdata);
    setState(() {
      getCurrentUser();
    });
  }

  void getCurrentUser() async {
    setState(() async {
      try {
        final staff = await _auth.currentUser;
        if (staff != null) {
          loggedInUser = staff;
          userDocumentID = loggedInUser.uid;
          fcmToken = await _fcm.getToken();
          staffID = loggedInUser.email;
          print(loggedInUser.email);
          final staffs = await _store.collection('staffs').get();
          for (var details in staffs.docs) {
            final name = details.data()['Name'];
            final email = details.data()['email'];
            final department = details.data()['department'];
            final designation = details.data()['designation'];
            if (staffID == email) {
              setState(() {
                NameOfStaff = name;
                print(NameOfStaff);
                IdOfStaff = email;
                print(IdOfStaff);
                DepartmentOfStaff = department;
                print(DepartmentOfStaff);
                DesignationOfStaff = designation;
                print(DesignationOfStaff);
              });
            }
          }
        }
      } catch (e) {
        print(e);
      }
    });
    List providerdata = loggedInUser.providerData;
    print(providerdata);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Color(0x00000000),
                                    radius: 50,
                                    backgroundImage:
                                        AssetImage('images/panimalar_logo.png'),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$NameOfStaff',
                                      style: TextStyle(
                                        // color: Colors.black38,
                                        fontFamily: 'Roboto',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '$IdOfStaff',
                                      style: TextStyle(
                                        // color: Colors.black38,
                                        fontFamily: 'Roboto',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$DesignationOfStaff - ',
                        style: TextStyle(
                          // color: Colors.black38,
                          fontFamily: 'Roboto',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '$DepartmentOfStaff',
                        style: TextStyle(
                          // color: Colors.black38,
                          fontFamily: 'Roboto',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    hasGoogle
                        ? TextButton(
                            child: Text('RESET LINKED ACCOUNT'),
                            onPressed: () {
                              setState(() {
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
                                            'You are about to remove your linked account!'),
                                        content: Text(
                                            'You will have to link your google mail again for better support and services.'),
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
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(false);
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
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(false);
                                                    setState(() {
                                                      showSpinner = true;
                                                      unlinkAccount()
                                                          .whenComplete(() {
                                                        showSpinner = false;
                                                      });
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
                              });
                            },
                          )
                        : TextButton(
                            child: Text(
                              'LINK GOOGLE ACCOUNT',
                              style: TextStyle(
                                  color: Color.fromRGBO(143, 148, 251, 1)),
                            ),
                            onPressed: () {
                              setState(() {
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
                              });
                            },
                          ),
                    SizedBox(
                      width: 20,
                    ),
                    RaisedButton(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      color: Color(0xFFEE6666),
                      shape: StadiumBorder(),
                      onPressed: () {
                        return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: EdgeInsets.all(20),
                                title: Text(
                                    'You are about to logout permanently!'),
                                content: Text(
                                    'You will have to login again once reopening the app'),
                                actions: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        RaisedButton(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                          color: Color(0xFFFFFFFF),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
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
                                              vertical: 10.0, horizontal: 20.0),
                                          color: Color(0xFFEE6666),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          onPressed: () {
                                            getValidationData(false, fcmToken)
                                                .whenComplete(() {
                                              _auth.signOut();
                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Screen2()),
                                                      (Route<dynamic> route) =>
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
                      },
                      child: Text(
                        "LOGOUT",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 17.0,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ReusableCard extends StatefulWidget {
  ReusableCard({@required this.colour, this.cardChild});

  final Color colour;
  final Widget cardChild;

  @override
  _ReusableCardState createState() => _ReusableCardState();
}

class _ReusableCardState extends State<ReusableCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.cardChild,
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: widget.colour,
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
