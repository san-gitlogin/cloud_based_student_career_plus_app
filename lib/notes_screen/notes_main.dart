import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:student_app/features_single/single_page.dart';
import 'package:student_app/features_modal/modal_shape.dart';
import 'package:student_app/features_tile/tile_builder.dart';
import 'package:student_app/features_tile/tile_for_upload.dart';
import '../features_header.dart';
import '../keep_alive.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        addAutomaticKeepAlives: true,
        children: <Widget>[
          KeepAliveWidget(
            child: FeaturesTilePdf(),
          ),
        ],
      ),
    );
  }
}
