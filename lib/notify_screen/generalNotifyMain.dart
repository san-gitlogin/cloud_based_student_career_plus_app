import 'package:flutter/material.dart';
import 'package:student_app/notify_screen/generalNotifyStaff.dart';
import '../keep_alive.dart';

class GeneralNotify extends StatefulWidget {
  @override
  _GeneralNotifyState createState() => _GeneralNotifyState();
}

class _GeneralNotifyState extends State<GeneralNotify> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        addAutomaticKeepAlives: true,
        children: <Widget>[
          KeepAliveWidget(
            child: GeneralfeaturesTileBuilder(),
          ),
        ],
      ),
    );
  }
}
