import 'package:flutter/material.dart';
import 'package:student_app/notify_screen/generalNotifyStudents.dart';
import '../keep_alive.dart';

class GeneralNotifyStudentScreen extends StatefulWidget {
  @override
  _GeneralNotifyStudentScreenState createState() =>
      _GeneralNotifyStudentScreenState();
}

class _GeneralNotifyStudentScreenState
    extends State<GeneralNotifyStudentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        addAutomaticKeepAlives: true,
        children: <Widget>[
          KeepAliveWidget(
            child: GeneralNotificationContent(),
          ),
        ],
      ),
    );
  }
}
