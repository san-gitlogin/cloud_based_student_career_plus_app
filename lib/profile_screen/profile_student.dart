import 'package:carousel_slider/carousel_slider.dart';
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
String Department;
String stuMail;
String stuID;
String stuName;
String stuRoll;
String stuReg;
String stuClassID;
String stuBatch;
String stuBacklogNum;
User loggedInUser;
String userDocumentID;
String fcmToken;
List providerdata;
bool hasGoogle = false;

class ProfileStudent extends StatefulWidget {
  @override
  _ProfileStudentState createState() => _ProfileStudentState();
}

class _ProfileStudentState extends State<ProfileStudent> {
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

  Future getValidationData(bool LogOut, deviceToken) async {
    bool FinalStuLoggedinCheck = LogOut;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString('studentemail', null);
    sharedPreferences.setString('studentpassword', null);
    sharedPreferences.setBool('keepStudentLoggedIn', FinalStuLoggedinCheck);
    await _store
        .collection('students')
        .doc(userDocumentID)
        .collection('tokens')
        .doc(deviceToken)
        .delete();
  }

  @override
  void initState() {
    // TODO: implement initState
    loggedInUser = _auth.currentUser;
    providerdata = loggedInUser.providerData;
    if (providerdata.length > 1) {
      hasGoogle = true;
    }
    print(providerdata);
    getCurrentUser();
    super.initState();
    setState(() {
      StudentStream();
    });
  }

  Color get primaryColor => Theme.of(context).primaryColor;

  void getCurrentUser() async {
    try {
      final student = await _auth.currentUser;
      if (student != null) {
        loggedInUser = student;
        userDocumentID = loggedInUser.uid;
        fcmToken = await _fcm.getToken();
        stuID = loggedInUser.email;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        height: 550,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StudentStream(),
            // Flexible(),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                                        borderRadius: BorderRadius.circular(10),
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
                                                      BorderRadius.circular(10),
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
                                                      BorderRadius.circular(10),
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
                                      studentOrStaff: 'student',
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
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
                              title:
                                  Text('You are about to logout permanently!'),
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
                                            // deleteDeviceToken(fcmToken);
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
                    child: Flexible(
                      child: Text(
                        "LOGOUT",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 17.0,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.collection('students').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot?.hasData ?? true) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
              // ignore: missing_return
            ),
          );
        }

        final studentDetails = snapshot.data.docs;
        List<StudentSearchCard> displayCards = [];
        for (var students in studentDetails) {
          final studName = students.data()['name'];
          final studentEmail = students.data()['email'];
          final rollNum = students.data()['rollno'];
          final department = students.data()['department'];
          final regNum = students.data()['regno'];
          final ClassID = students.data()['classID'];
          List<String> backlogsubjects =
              List.castFrom(students.data()['backlogsubs'] as List ?? []);
          if (stuID == studentEmail) {
            Department = department;
            print(Department);
            stuName = studName;
            stuMail = studentEmail;
            stuRoll = rollNum;
            stuReg = regNum;
            stuBacklogNum = backlogsubjects.length.toString();
            stuClassID = ClassID;
            stuBatch = stuClassID.substring(0, 2);
            final studentBubble = StudentSearchCard(
              studentName: stuName,
              studentMail: stuMail,
              studentBatch: stuBatch,
              //studentEvents: ,
              studentReg: stuReg,
              studentRoll: stuRoll,
              classID: stuClassID,
              backlogNum: stuBacklogNum,
              department: Department,
            );
            displayCards.add(studentBubble);
          }
        }
        return ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          reverse: false,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          children: displayCards != null
              ? displayCards
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      backgroundColor: Colors.lightBlueAccent,
                      // ignore: missing_return
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class StudentSearchCard extends StatefulWidget {
  StudentSearchCard({
    this.studentName,
    this.studentMail,
    this.studentReg,
    this.studentRoll,
    this.studentBatch,
    this.department,
    this.classID,
    //this.studentEvents,
    this.backlogNum,
    //this.rollNumber,
  });
  final String studentMail;
  final String studentName;
  final String studentRoll;
  final String studentReg;
  final String department;
  final String studentBatch;
  final String classID;
  final String backlogNum;
  //final String studentEvents;
  @override
  _StudentSearchCardState createState() =>
      _StudentSearchCardState(mailCheck: studentMail);
}

class _StudentSearchCardState extends State<StudentSearchCard> {
  _StudentSearchCardState({
    this.mailCheck,
  });
  final String mailCheck;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // setState(() {
    //   EventStream();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0x00000000),
                    radius: 25,
                    backgroundImage: AssetImage('images/panimalar_logo.png'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name : ',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                        Text(widget.studentName != Null
                            ? widget.studentName
                            : 'NIL'),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Roll No : ',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                        Text(widget.studentRoll != Null
                            ? widget.studentRoll
                            : 'NIL'),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Register No : ',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                        Text(widget.studentReg != Null
                            ? widget.studentReg
                            : 'NIL'),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Department : ',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                        Text(widget.department != Null
                            ? widget.department
                            : 'NIL'),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'ClassID : ',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                        Text(widget.classID != Null ? widget.classID : 'NIL'),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Batch : ',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                        Text(widget.studentBatch != Null
                            ? widget.studentBatch
                            : 'NIL'),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   width: 20,
                  // ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      width: 90,
                      child: Card(
                        elevation: 5,
                        color: Colors.deepPurple[200],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Backlogs',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              widget.backlogNum != Null
                                  ? widget.backlogNum
                                  : 'NIL',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                                fontSize: 50,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 25, 10, 10),
                    child: Text(
                      'EVENTS',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              EventStream(
                MailCheck: mailCheck,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventStream extends StatelessWidget {
  EventStream({this.MailCheck});
  final String MailCheck;
  String semNumber;
  String Title;
  String Location;
  String Date;

  List<Widget> nilEvents = [
    ListView(
      children: [
        Center(
            child: Text(
                'Student has not attended/requested for OD on any events yet')),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.collection('odRequests').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot?.hasData ?? true) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
              // ignore: missing_return
            ),
          );
        }
        final eventDetails = snapshot.data.docs;
        List<EventCards> eventDetailsList = [];
        print(MailCheck);
        for (var details in eventDetails) {
          final studentEmail = details.data()['email'];
          final semesterNumber = details.data()['semester'];
          final titleEvent = details.data()['eventTitle'];
          final locationEvent = details.data()['eventLocation'];
          final dateEvent = details.data()['date'];
          final ODApproval = details.data()['ODApproval'];
          if (MailCheck == studentEmail) {
            if (ODApproval == true) {
              semNumber = semesterNumber;
              print(semNumber);
              Title = titleEvent;
              print(Title);
              Location = locationEvent;
              print(Location);
              Date = dateEvent;
              print(Date);
              final eventBubble = EventCards(
                semNum: semNumber,
                title: Title,
                location: Location,
                date: Date,
              );
              eventBubble != Null
                  ? eventDetailsList.add(eventBubble)
                  : print('NULL');
            }
          }
        }
        return Container(
          height: 120,
          child: eventDetailsList.length > 1
              ? CarouselSlider(
                  options: CarouselOptions(
                    height: 400,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    // enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: eventDetailsList.length > 1 ? true : false,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    // onPageChanged: callbackFunction,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: eventDetailsList != null
                      ? eventDetailsList
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                              backgroundColor: Colors.lightBlueAccent,
                              // ignore: missing_return
                            ),
                          ),
                        ),
                )
              : Container(
                  height: 100,
                  child: ListWheelScrollView(
                      physics: BouncingScrollPhysics(),
                      itemExtent: 100,
                      diameterRatio: 2,
                      // shrinkWrap: true,
                      // reverse: false,
                      // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      children: eventDetailsList.length == 1
                          ? eventDetailsList
                          : nilEvents),
                ),
        );
      },
    );
  }
}

class EventCards extends StatefulWidget {
  EventCards({
    this.semNum,
    this.title,
    this.location,
    this.date,
  });
  final String semNum;
  final String title;
  final String location;
  final String date;

  @override
  _EventCardsState createState() => _EventCardsState();
}

class _EventCardsState extends State<EventCards> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Column(
          children: [
            Text(
              'SEM',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
            Text(
              widget.semNum != null ? widget.semNum : 'NIL',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
                fontSize: 35,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        title: Text(
          widget.title != null ? widget.title : 'NIL',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            // fontSize: 25,
          ),
        ),
        subtitle: Text(
          widget.location != null
              ? widget.location +
                  ' ' +
                  'on ' +
                  ' ' +
                  widget.date.substring(8, 10) +
                  '-' +
                  widget.date.substring(5, 7) +
                  '-' +
                  widget.date.substring(0, 4)
              : 'NIL',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 10,
            // fontSize: 20,
          ),
        ),
      ),
    );
  }
}
