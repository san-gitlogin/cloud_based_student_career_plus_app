import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _auth = FirebaseAuth.instance;
final _store = FirebaseFirestore.instance;
User loggedInUser;
String studentID;
String Date;
String Department;
String Semester;
String EventName;
String EventLocation;
String uploadedFileURL;
String uploadedFilePath;
String Backlogs;
List<String> BackLogSubjects;
String UserCLassID;
String UserRollNo;
String reqDocID;
bool approvalOD;
bool showSpinner = false;

class CertificateContent extends StatefulWidget {
  @override
  _CertificateContentState createState() => _CertificateContentState();
}

class _CertificateContentState extends State<CertificateContent> {
  @override
  void initState() {
    super.initState();
    setState(() {
      getCurrentUser();
      odRequestSnapshot();
      RequestStream();
    });
  }

  void getCurrentUser() async {
    setState(() async {
      try {
        final student = await _auth.currentUser;
        if (student != null) {
          loggedInUser = student;
          studentID = loggedInUser.email;
          print(loggedInUser.email);
          final students = await _store.collection('students').get();
          for (var details in students.docs) {
            final email = details.data()['email'];
            final classID = details.data()['classID'];
            final backlog = details.data()['backlogs'];
            final rollNum = details.data()['rollno'];
            List<String> backlogsubjects =
                List.castFrom(details.data()['backlogsubs'] as List ?? []);
            if (studentID == email) {
              setState(() {
                Backlogs = backlog;
                print(Backlogs);
                BackLogSubjects = backlogsubjects;
                print(BackLogSubjects);
                UserCLassID = classID;
                print(UserCLassID);
                UserRollNo = rollNum;
                print(UserRollNo);
              });
            }
          }
        }
      } catch (e) {
        print(e);
      }
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
    return RequestStream();
  }
}

class RequestStream extends StatelessWidget {
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
        List<ODRequestCard> requestCards = [];
        for (var requests in odRequests) {
          final studentEmail = requests.data()['email'];
          final semNum = requests.data()['semester'];
          final department = requests.data()['department'];
          final eventTitle = requests.data()['eventTitle'];
          final eventLocation = requests.data()['eventLocation'];
          final eventDate = requests.data()['date'];
          final certificateURL = requests.data()['certificateURL'];
          final certificatePath = requests.data()['certificatePath'];
          final ODApproval = requests.data()['ODApproval'];
          final ClassID = requests.data()['classID'];
          final currentUser = loggedInUser.email;
          if (studentEmail == currentUser) {
            reqDocID = requests.id;
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
            uploadedFilePath = certificatePath;
            print(uploadedFilePath);
            UserCLassID = ClassID;
            print(UserCLassID);
            final requestBubble = ODRequestCard(
              docID: reqDocID,
              date: Date,
              studentMail: studentID,
              semNum: Semester,
              department: Department,
              odApproval: approvalOD,
              title: eventTitle,
              location: eventLocation,
              classID: UserCLassID,
              certificateURL: uploadedFileURL,
              certificatePath: uploadedFilePath,
              rollNumber: UserRollNo,
            );
            requestCards.add(requestBubble);
          }
        }
        return ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
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

class ODRequestCard extends StatefulWidget {
  ODRequestCard({
    this.docID,
    this.semNum,
    this.studentMail,
    this.date,
    this.title,
    this.location,
    this.department,
    this.classID,
    this.odApproval,
    this.requestID,
    this.certificatePath,
    this.certificateURL,
    this.rollNumber,
  });
  final String docID;
  final String studentMail;
  final String semNum;
  final String title;
  final String location;
  final String department;
  final String date;
  final String classID;
  final bool odApproval;
  final String certificateURL;
  final String certificatePath;
  final String rollNumber;
  final String requestID;

  @override
  _ODRequestCardState createState() => _ODRequestCardState();
}

class _ODRequestCardState extends State<ODRequestCard> {
  Future removeUploadedRequest(imagePath, docID) async {
    showSpinner = true;
    if (imagePath != null) {
      print(imagePath);
      FirebaseStorage storageReference = FirebaseStorage.instance;
      Reference ref = storageReference.ref().child(imagePath);
      await ref.delete().whenComplete(() {
        _store.collection('odRequests').doc(docID).delete();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.all(20),
                title: Text('Request cancelled successfully'),
                // content: Text(
                //     'Specify the Event Name, Location and Date in respective fields'),
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
        showSpinner = false;
      });
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
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.studentMail,
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
                          'CLASS : ${widget.classID}',
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
                ),
                Flexible(
                  child: Container(
                    width: 110,
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
                            '${widget.date.substring(8, 10)}-${widget.date.substring(5, 7)}-${widget.date.substring(0, 4)}',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
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
                    widget.semNum,
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
                widget.title,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                ),
              ),
              subtitle: Text(widget.location),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  !widget.odApproval
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              child: Text('CANCEL REQUEST',
                                  style: TextStyle(
                                    color: Colors.red,
                                  )),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        contentPadding: EdgeInsets.all(20),
                                        title: Text(
                                            'Are you sure willing to cancel your request?'),
                                        content: Text(
                                            'Your request for approval is pending.'),
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
                                                  onPressed: () async {
                                                    Navigator.of(context)
                                                        .pop(false);
                                                    await removeUploadedRequest(
                                                        widget.certificatePath,
                                                        widget.docID);
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
                            ),
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
