import 'package:flutter/material.dart';
import 'package:student_app/features_modal/od_provide.dart';

import '../keep_alive.dart';

class ProvideOD extends StatefulWidget {
  @override
  _ProvideODState createState() => _ProvideODState();
}

class _ProvideODState extends State<ProvideOD> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        addAutomaticKeepAlives: true,
        children: <Widget>[
          KeepAliveWidget(
            child: ProvideODContent(),
          ),
        ],
      ),
    );
  }
}
