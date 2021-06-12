import 'package:flutter/material.dart';
import 'package:student_app/profile_screen/profile_main.dart';
import '../keep_alive.dart';

class StaffProfile extends StatefulWidget {
  @override
  _StaffProfileState createState() => _StaffProfileState();
}

class _StaffProfileState extends State<StaffProfile> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        addAutomaticKeepAlives: true,
        children: <Widget>[
          KeepAliveWidget(
            child: ProfileScreen(),
          ),
        ],
      ),
    );
  }
}
