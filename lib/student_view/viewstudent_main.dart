import 'package:flutter/material.dart';
import 'package:student_app/features_modal/student_search.dart';
import '../keep_alive.dart';

class ViewStudent extends StatefulWidget {
  @override
  _ViewStudentState createState() => _ViewStudentState();
}

class _ViewStudentState extends State<ViewStudent> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      // radius: Radius.circular(20),
      controller: _scrollController,
      child: ListView(
        controller: _scrollController,
        shrinkWrap: true,
        addAutomaticKeepAlives: true,
        children: <Widget>[
          KeepAliveWidget(
            child: FeaturesTileStudent(),
          ),
        ],
      ),
    );
  }
}
