import 'package:flutter/material.dart';
import 'package:student_app/profile_screen/profile_student.dart';
import '../keep_alive.dart';

class StudentProfile extends StatefulWidget {
  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        addAutomaticKeepAlives: true,
        children: <Widget>[
          KeepAliveWidget(
            child: ProfileStudent(),
          ),
        ],
      ),
    );
  }
}
