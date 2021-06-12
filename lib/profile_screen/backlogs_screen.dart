import 'package:flutter/material.dart';
import 'package:student_app/profile_screen/backlog_content.dart';
import '../keep_alive.dart';

class BacklogsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        addAutomaticKeepAlives: true,
        shrinkWrap: true,
        children: <Widget>[
          KeepAliveWidget(
            child: SingleChildScrollView(
              child: BacklogContent(),
            ),
          ),
        ],
      ),
    );
  }
}
