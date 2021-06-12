import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';
import '../choices.dart' as choices;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _store = FirebaseFirestore.instance;
User loggedInUser;
String studentID;

String Date;
String Department;
String Semester;
String EventName;
String EventLocation;
String uploadedFileURL;
String UserCLassID;
bool showSpinner = false;
bool isSwitched = false;
bool approvalOD;
List<String> _classid = [];
List<String> _docID = [];

class ProvideODContent extends StatefulWidget {
  @override
  _ProvideODContentState createState() => _ProvideODContentState();
}

class _ProvideODContentState extends State<ProvideODContent> {
  Color get primaryColor => Theme.of(context).primaryColor;
  @override
  void initState() {
    super.initState();
    setState(() {
      odRequestSnapshot();
      ProvideStream();
    });
  }

  void odRequestSnapshot() async {
    await for (var snapshot in _store.collection('odRequests').snapshots()) {
      for (var requests in snapshot.docs) {
        print(requests.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 7),
        SmartSelect<String>.single(
          title: 'Department',
          value: Department,
          choiceItems: choices.department,
          onChange: (state) => setState(() => Department = state.value),
        ),
        const Divider(indent: 20),
        SmartSelect<String>.single(
          title: 'Semester',
          value: Semester,
          choiceItems: choices.semester,
          onChange: (state) => setState(() => Semester = state.value),
        ),
        Card(
          elevation: 3,
          margin: const EdgeInsets.all(5),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
        SmartSelect<String>.multiple(
          title: 'Choose classes',
          value: _classid,
          choiceItems: S2Choice.listFrom<String, Map>(
            source: choices.classid,
            value: (index, item) => item['value'],
            title: (index, item) => item['title'],
            group: (index, item) => item['department'],
          ),
          onChange: (state) => setState(() => _classid = state.value),
          modalType: S2ModalType.bottomSheet,
          modalConfirm: true,
          modalFilter: true,
          choiceGrouped: true,
          tileBuilder: (context, state) {
            return Card(
              elevation: 3,
              margin: const EdgeInsets.all(5),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: S2Tile.fromState(
                state,
                hideValue: true,
                title: const Text('Choose class'),
                trailing: const Icon(Icons.add_circle_outline),
                body: S2TileChips(
                  chipLength: state.valueObject.length,
                  chipLabelBuilder: (context, i) {
                    return Text(state.valueObject[i].title);
                  },
                  chipOnDelete: (i) {
                    setState(() => _classid.remove(state.valueObject[i].value));
                  },
                  chipColor: Colors.deepPurple[200],
                  chipRaised: true,
                ),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: Row(
            children: [
              Text('Include Approved OD Requests'),
              SizedBox(
                width: 20,
              ),
              Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                    print(isSwitched);
                  });
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        Flexible(
          child: _classid.isNotEmpty
              ? ProvideStream()
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Please choose a class to view OD requests'),
                ),
        ),
      ],
    );
  }
}

class ProvideStream extends StatelessWidget {
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
        final odRequests = snapshot.data.docs;
        List<ODProvideCard> requestCards = [];
        for (var requests in odRequests) {
          final studentEmail = requests.data()['email'];
          final semNum = requests.data()['semester'];
          final department = requests.data()['department'];
          final eventTitle = requests.data()['eventTitle'];
          final eventLocation = requests.data()['eventLocation'];
          final eventDate = requests.data()['date'];
          final certificateURL = requests.data()['certificateURL'];
          final ODApproval = requests.data()['ODApproval'];
          final ClassID = requests.data()['classID'];
          for (var classes in _classid) {
            if (semNum == Semester) {
              if (classes == ClassID) {
                for (int i = 0; i < odRequests.length; i++) {
                  String docID = odRequests[i].id;
                  _docID.add(docID);
                  print(docID);
                  studentID = studentEmail;
                  print(studentID);
                  Semester = semNum;
                  print(Semester);
                  Department = department;
                  print(Department);
                  Date = eventDate;
                  print(Date);
                  approvalOD = ODApproval;
                  print(approvalOD);
                  EventName = eventTitle;
                  print(EventName);
                  EventLocation = eventLocation;
                  print(EventLocation);
                  uploadedFileURL = certificateURL;
                  print(uploadedFileURL);
                  UserCLassID = ClassID;
                  print(UserCLassID);
                }
                final requestBubble = ODProvideCard(
                  date: Date,
                  studentMail: studentID,
                  semNum: Semester,
                  department: Department,
                  odApproval: approvalOD,
                  title: eventTitle,
                  location: eventLocation,
                  classID: UserCLassID,
                  certificateURL: uploadedFileURL,
                  //rollNumber: UserRollNo,
                );
                isSwitched
                    ? requestCards.add(requestBubble)
                    : !approvalOD
                        ? requestCards.add(requestBubble)
                        : Padding(
                            padding: const EdgeInsets.all(12.0),
                            child:
                                Text('Please wait until all events get loaded'),
                          );
              }
            }
          }
        }
        return ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          reverse: false,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          children: requestCards != null
              ? requestCards
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

class ODProvideCard extends StatefulWidget {
  ODProvideCard({
    this.semNum,
    this.studentMail,
    this.date,
    this.title,
    this.location,
    this.department,
    this.classID,
    this.odApproval,
    this.certificateURL,
    //this.rollNumber,
  });
  final String studentMail;
  final String semNum;
  final String title;
  final String location;
  final String department;
  final String date;
  final String classID;
  final bool odApproval;
  final String certificateURL;
  //final String rollNumber;

  @override
  _ODProvideCardState createState() =>
      _ODProvideCardState(mailCheck: studentMail);
}

class _ODProvideCardState extends State<ODProvideCard> {
  _ODProvideCardState({
    this.mailCheck,
  });
  final String mailCheck;

  String studentName;
  String Backlogs;
  List<String> BackLogSubjects;
  String noOfBacklogs;
  String UserRollNo;
  String UserRegNo;
  String classIDStudent;
  String StudentID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getStudentDetails();
      //_ODProvideCardState();
    });
    print(mailCheck);
  }

  void getStudentDetails() async {
    try {
      showSpinner = true;
      //print(loggedInUser.email);
      final students = await _store.collection('students').get();
      for (var details in students.docs) {
        final name = details.data()['name'];
        final email = details.data()['email'];
        final classID = details.data()['classID'];
        final rollNum = details.data()['rollno'];
        final regNum = details.data()['regno'];
        List<String> backlogsubjects =
            List.castFrom(details.data()['backlogsubs'] as List ?? []);
        final backlogLength = backlogsubjects.length;
        if (mailCheck == email) {
          setState(() {
            studentName = name;
            print(studentName);
            BackLogSubjects = backlogsubjects;
            print(BackLogSubjects);
            noOfBacklogs = backlogLength.toString();
            print(noOfBacklogs);
            classIDStudent = classID;
            print(classIDStudent);
            UserRollNo = rollNum;
            print(UserRollNo);
            UserRegNo = regNum;
            print(UserRegNo);
          });
        }
      }
      showSpinner = false;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.studentMail != null ? widget.studentMail : 'NIL',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'CLASS : ${widget.classID != null ? widget.classID : 'NIL'}',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.grey[350],
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Container(
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'OD REQUEST ON',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                              color: Colors.grey[350],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${widget.date.substring(8, 10) != null ? widget.date.substring(8, 10) : 'NIL'}-${widget.date.substring(5, 7) != null ? widget.date.substring(5, 7) : 'NIL'}-${widget.date.substring(0, 4) != null ? widget.date.substring(0, 4) : 'NIL'}',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ListTile(
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
                  fontSize: 25,
                ),
              ),
              subtitle: Text(widget.location != null ? widget.location : 'NIL'),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Flexible(
                    child: Material(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                      elevation: 5,
                      color: Colors.red[400],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          widget.certificateURL != null
                              ? Image.network(
                                  widget.certificateURL,
                                  //height: 150,
                                )
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 3,
                margin: const EdgeInsets.all(5),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Flexible(
                    child: Container(
                      // width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text('Roll Number'),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  UserRollNo != null ? UserRollNo : 'NIL',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto'),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text('Register Number'),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  UserRegNo != null ? UserRegNo : 'NIL',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto'),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text('Backlogs'),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  noOfBacklogs != null ? noOfBacklogs : 'NIL',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto'),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  !widget.odApproval
                      ? Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Approval pending',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 2, 20, 10),
                                  child: RaisedButton(
                                    textColor: Colors.white,
                                    color: Colors.green,
                                    shape: StadiumBorder(),
                                    onPressed: () async {
                                      final requestsOD = await _store
                                          .collection('odRequests')
                                          .get();
                                      for (var certificate in requestsOD.docs) {
                                        String id = certificate.id;
                                        for (var Documents in _docID) {
                                          if (Documents == id) {
                                            final checkCertificateURL =
                                                certificate
                                                    .data()['certificateURL'];
                                            if (widget.certificateURL ==
                                                checkCertificateURL) {
                                              _store
                                                  .collection('odRequests')
                                                  .doc(Documents)
                                                  .update({'ODApproval': true});
                                            }
                                          }
                                        }
                                      }
                                    },
                                    child: Text("PROVIDE OD"),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.done,
                              color: Colors.green,
                              size: 18,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Approved',
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            )
                          ],
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
