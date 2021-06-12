import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:student_app/features_single/single_page.dart';
import 'package:student_app/features_modal/modal_shape.dart';
import 'package:student_app/features_tile/tile_builder.dart';
import '../features_header.dart';
import '../keep_alive.dart';

class NotifyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        addAutomaticKeepAlives: true,
        children: <Widget>[
          KeepAliveWidget(
            child: StickyHeader(
              header: const FeaturesHeader(
                  'Send notification to students with backlog'),
              content: FeaturesTileBuilder(),
            ),
          ),
        ],
      ),
    );
  }
}
