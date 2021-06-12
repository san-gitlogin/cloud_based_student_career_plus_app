import 'dart:io';
import 'package:student_app/notify_screen/generalNotifyStudentMain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:student_app/notes_screen/view_notes.dart';

import 'package:student_app/notify_screen/view_notifications.dart';

import 'package:student_app/profile_screen/StudentProfile.dart';
import 'package:student_app/profile_screen/backlogs_screen.dart';
import 'package:student_app/od_screen/request_od.dart';
import 'package:student_app/overlay_screens/certificate_list.dart';
import 'features_brightness.dart';
import 'keep_alive.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging _fcm = FirebaseMessaging();
final _auth = FirebaseAuth.instance;
final _store = FirebaseFirestore.instance;
String docID;

class StudentTab extends StatefulWidget {
  @override
  _StudentTabState createState() => _StudentTabState();
}

class _StudentTabState extends State<StudentTab> {
  @override
  void initState() {
    _saveDeviceToken();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(
                message['notification']['title'],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(message['notification']['body']),
            ),
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
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _setMessage(message);
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _setMessage(message);
        // TODO optional
      },
    );
    _fcm.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );
  }

  _setMessage(Map<String, dynamic> message) {
    final notification = message['notification'];
    final data = message['data'];
    final String title = notification['title'];
    final String body = notification['body'];
    String mMessage = data['message'];
    print("Title: $title, body: $body, message: $mMessage");
  }

  _saveDeviceToken() async {
    // Get the current user
    User loggedInUser;
    final student = await _auth.currentUser;
    if (student != null) {
      loggedInUser = student;
      docID = loggedInUser.uid;
      print(loggedInUser.uid);
    }
    // Get the token for this device
    String fcmToken = await _fcm.getToken();
    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = _store
          .collection('students')
          .doc(docID)
          .collection('tokens')
          .doc(fcmToken);

      await tokens.set({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 8),
            child: Image(
              image: AssetImage('images/Main Screen.png'),
              width: 20,
              height: 20,
            ),
          ),
          title: Text('STUDENT CAREER +'),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: 'Profile'),
              Tab(text: 'General Notifications'),
              Tab(text: 'Backlog Details'),
              Tab(text: 'Backlog Notifications'),
              Tab(text: 'View Notes'),
              Tab(text: 'Request OD'),
              Tab(text: 'View Requests'),
            ],
          ),
          actions: <Widget>[
            FeaturesBrightness(),
            //FeaturesColor(),
            IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () => _about(context),
            )
          ],
        ),
        body: TabBarView(
          children: [
            KeepAliveWidget(
              child: StudentProfile(),
            ),
            KeepAliveWidget(
              child: GeneralNotifyStudentScreen(),
            ),
            KeepAliveWidget(
              child: BacklogsScreen(),
            ),
            KeepAliveWidget(
              child: NotificationsScreen(),
            ),
            KeepAliveWidget(
              child: ViewNotesScreen(),
            ),
            KeepAliveWidget(
              child: RequestOD(),
            ),
            KeepAliveWidget(
              child: CertificateListScreen(),
            ),
          ],
        ),
      ),
    );
  }

  void _about(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.all(20),
            title: Column(
              children: [
                Text('PEC STUDENT APP'),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Santhosh, Suresh Kannan, Pradeep. ',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.deepPurpleAccent[100],
                  ),
                ),
              ],
            ),
            content: Text(
                'This application would enhance the study experience of a student, especially a student with backlog would find it very easy to study and organize his/her time. Students will gain confidence once the right advice on organizing their study process becomes handy. As like students, teachers will also be able to provide task to backlog students with ease'),
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
                        "CLOSE",
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
  }
}
