import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'staff_login_page.dart';
import 'student_login_page.dart';
import 'package:student_app/Animation/FadeAnimation.dart';

class StudentOrStaff extends StatefulWidget {
  @override
  _StudentOrStaffState createState() => _StudentOrStaffState();
}

class _StudentOrStaffState extends State<StudentOrStaff> {
  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.all(20),
            title: Text('Are you sure ?'),
            content: Text('You are about exit from the app'),
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
                        borderRadius: BorderRadius.circular(10),
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {
                        SystemNavigator.pop();
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: _onBackPressed, child: Screen2());
  }
}

class Screen2 extends StatelessWidget {
  final String staffButton = 'STAFF LOGIN';
  final String studentButton = 'STUDENT LOGIN';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100.0,
                width: 100.0,
                margin: EdgeInsets.all(10.0),
                child: Image(
                  image: AssetImage('images/panimalar_logo.png'),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
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
              SizedBox(
                height: 45.0,
              ),
              Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FadeAnimation(
                      0.8,
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return StudentLogin(); //StaffChoose();
                              },
                            ),
                          );
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
                              "STUDENT",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )),
                  FadeAnimation(
                      0.8,
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return StaffLogin(); //StaffChoose();
                              },
                            ),
                          );
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
                              "STAFF",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
