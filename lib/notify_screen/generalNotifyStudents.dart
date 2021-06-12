import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';
import 'package:student_app/choices.dart' as choices;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _auth = FirebaseAuth.instance;
final _store = FirebaseFirestore.instance;
User loggedInUser;
String studentID;
String staffMail;
String semNumber;
String Department;
String UserCLassID;
String UserDepartment;
String NotifyClassID;
String NotifyMessageTitle;
String NotifyMessage;
List<String> ClassIDData;

class GeneralNotificationContent extends StatefulWidget {
  @override
  _GeneralNotificationContentState createState() =>
      _GeneralNotificationContentState();
}

class _GeneralNotificationContentState
    extends State<GeneralNotificationContent> {
  @override
  void initState() {
    super.initState();
    setState(() {
      getCurrentUser();
      notificationSnapshot();
      NotifyStream();
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
            final department = details.data()['department'];
            if (studentID == email) {
              setState(() {
                UserDepartment = department;
                UserCLassID = classID;
                print(UserCLassID);
              });
            }
          }
        }
      } catch (e) {
        print(e);
      }
    });
  }

  void notificationSnapshot() async {
    await for (var snapshot
        in _store.collection('generalNotifyStudents').snapshots()) {
      for (var notifications in snapshot.docs) {
        print(notifications.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotifyStream();
  }
}

class NotifyStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.collection('generalNotifyStudents').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot?.hasData ?? true) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
              // ignore: missing_return
            ),
          );
        }
        final notifications = snapshot.data.docs;
        List<NotificationCard> notificationCards = [];
        String Date;
        String Time;
        for (var notifies in notifications) {
          final staffEmail = notifies.data()['email'];
          final semNum = notifies.data()['semester'];
          final department = notifies.data()['department'];
          final notifyMessage = notifies.data()['message'];
          final notifyMessageTitle = notifies.data()['messageTitle'];
          final sentDateTime = notifies.data()['dateAndTime'];
          List<String> ListOfClassID =
              List.castFrom(notifies.data()['classID'] as List ?? []);
          for (int i = 0; i < ListOfClassID.length; i++) {
            if (ListOfClassID[i] == UserCLassID) {
              ClassIDData = ListOfClassID;
              NotifyClassID = ListOfClassID[i];
              staffMail = staffEmail;
              print(staffMail);
              semNumber = semNum;
              print(semNumber);
              Department = department;
              print(Department);
              NotifyMessage = notifyMessage;
              print(NotifyMessage);
              NotifyMessageTitle = notifyMessageTitle;
              print(NotifyMessageTitle);
              Date = sentDateTime;
              Time = Date = sentDateTime;
              for (int j = 0; j < ClassIDData.length; j++) {
                var myClass = ClassIDData[j];
                if (myClass == UserCLassID && department == UserDepartment) {
                  final notifyBubble = NotificationCard(
                    messageTitle: NotifyMessageTitle,
                    semNum: semNumber.toString(),
                    staffMail: staffMail,
                    notifyMessage: NotifyMessage,
                    ClassIDToNotify: NotifyClassID,
                    date: Date,
                    time: Time,
                  );
                  notificationCards.add(notifyBubble);
                }
              }
            }
          }
        }
        return ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          reverse: false,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          children: notificationCards,
        );
      },
    );
  }
}

class NotificationCard extends StatelessWidget {
  NotificationCard(
      {this.messageTitle,
      this.ClassIDToNotify,
      this.subNum,
      this.semNum,
      this.notifyMessage,
      this.staffMail,
      this.date,
      this.time});
  final String messageTitle;
  final String ClassIDToNotify;
  final String subNum;
  final String semNum;
  final String notifyMessage;
  final String staffMail;
  final String date;
  final String time;

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
                    child: Text(
                      staffMail != null ? staffMail : 'NIL',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
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
                          Text(
                            '${date.substring(8, 10)}-${date.substring(5, 7)}-${date.substring(0, 4)}' !=
                                    null
                                ? '${date.substring(8, 10)}-${date.substring(5, 7)}-${date.substring(0, 4)}'
                                : 'NIL',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            time.substring(11, 19) != null
                                ? time.substring(11, 19)
                                : 'NIL',
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
                    semNum != null ? semNum : 'NIL',
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
                messageTitle != null ? messageTitle : 'NIL',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                ),
              ),
              subtitle: Text(ClassIDToNotify != null ? ClassIDToNotify : 'NIL'),
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
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              notifyMessage != null ? notifyMessage : 'NIL',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.white,
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
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}
