import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:student_app/overlay_screens/certificate_list_content.dart';
import 'package:student_app/features_single/single_page.dart';
import 'package:student_app/features_modal/modal_shape.dart';
import 'package:student_app/features_tile/tile_builder.dart';
import 'package:student_app/features_tile/tile_for_upload.dart';
import 'package:student_app/notify_screen/notification_content.dart';
import 'package:student_app/profile_screen/backlog_content.dart';
import '../features_header.dart';
import '../keep_alive.dart';

class CertificateListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        addAutomaticKeepAlives: true,
        children: <Widget>[
          KeepAliveWidget(
            child: CertificateContent(),
          ),
        ],
      ),
    );
  }
}
