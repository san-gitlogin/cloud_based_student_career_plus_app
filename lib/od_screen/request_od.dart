import 'package:flutter/material.dart';
import 'package:student_app/od_screen/request_od_content.dart';
import '../keep_alive.dart';

class RequestOD extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        addAutomaticKeepAlives: true,
        children: <Widget>[
          KeepAliveWidget(
            child: FeaturesTileODRequest(),
          ),
        ],
      ),
    );
  }
}
