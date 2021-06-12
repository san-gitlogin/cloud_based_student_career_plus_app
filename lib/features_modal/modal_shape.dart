import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';
import '../choices.dart' as choices;

class FeaturesModalShape extends StatefulWidget {
  @override
  _FeaturesModalShapeState createState() => _FeaturesModalShapeState();
}

class _FeaturesModalShapeState extends State<FeaturesModalShape> {
  String _department = 'CSE';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 7),
        SmartSelect<String>.single(
            title: 'Department',
            value: _department,
            onChange: (state) => setState(() => _department = state.value),
            choiceType: S2ChoiceType.radios,
            choiceItems: choices.department,
            modalType: S2ModalType.popupDialog,
            modalHeader: false,
            modalConfig: const S2ModalConfig(
              style: S2ModalStyle(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
              ),
            ),
            tileBuilder: (context, state) {
              return S2Tile.fromState(
                state,
                isTwoLine: true,
                leading: CircleAvatar(
                  child: Text('${state.valueDisplay[0]}',
                      style: TextStyle(color: Colors.white)),
                ),
              );
            }),
        Divider(indent: 20),
        const SizedBox(height: 7),
      ],
    );
  }
}
