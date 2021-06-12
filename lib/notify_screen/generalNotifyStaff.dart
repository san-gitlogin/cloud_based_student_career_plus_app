import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';
import '../choices.dart' as choices;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

TextEditingController _textEditingController;

class GeneralfeaturesTileBuilder extends StatefulWidget {
  @override
  _GeneralfeaturesTileBuilderState createState() =>
      _GeneralfeaturesTileBuilderState();
}

class _GeneralfeaturesTileBuilderState
    extends State<GeneralfeaturesTileBuilder> {
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;
  bool showSpinner = false;
  List<String> _classid = [];
  String Department;
  String Semester;
  String MessageTitle;
  String MessageContent;
  int backlognumber;
  List<String> _categories = [];
  String _sort = 'department';
  Color get primaryColor => Theme.of(context).primaryColor;
  DateTime now = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  const SizedBox(height: 7),
                  SmartSelect<String>.single(
                    title: 'Department',
                    value: Department,
                    choiceItems: choices.department,
                    onChange: (state) =>
                        setState(() => Department = state.value),
                  ),
                  const Divider(indent: 20),
                  SmartSelect<String>.single(
                    title: 'Semester',
                    value: Semester,
                    choiceItems: choices.semester,
                    onChange: (state) => setState(() => Semester = state.value),
                  ),
                  const SizedBox(height: 7),
                ],
              ),
              const SizedBox(height: 7),
              Card(
                elevation: 3,
                margin: const EdgeInsets.all(5),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              SmartSelect<String>.multiple(
                title: 'Choose classes',
                value: _classid,
                choiceItems: S2Choice.listFrom<String, Map>(
                  source: choices.classid,
                  value: (index, item) => item['value'],
                  title: (index, item) => item['title'],
                  group: (index, item) => item['department'],
                ),
                onChange: (state) => setState(() => _classid = state.value),
                modalType: S2ModalType.bottomSheet,
                modalConfirm: true,
                modalFilter: true,
                choiceGrouped: true,
                tileBuilder: (context, state) {
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.all(5),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: S2Tile.fromState(
                      state,
                      hideValue: true,
                      title: const Text('Choose class'),
                      trailing: const Icon(Icons.add_circle_outline),
                      body: S2TileChips(
                        chipLength: state.valueObject.length,
                        chipLabelBuilder: (context, i) {
                          return Text(state.valueObject[i].title);
                        },
                        chipOnDelete: (i) {
                          setState(() =>
                              _classid.remove(state.valueObject[i].value));
                        },
                        chipColor: Colors.deepPurple[200],
                        chipRaised: true,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 7),
              Card(
                elevation: 3,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(Icons.message),
                      title: Text('Enter message to be sent'),
                      subtitle: Text('Common to classes chosen'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              decoration: new InputDecoration(
                                labelText: 'Title',
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(8.0),
                                  borderSide: new BorderSide(),
                                ),
//fillColor: Colors.green
                              ),
                              onChanged: (value) {
                                if (value.length != 0) {
                                  MessageTitle = value;
                                }
                                //Do something with the user input.
                              },
                              style: new TextStyle(
                                fontFamily: "Roboto",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: _textEditingController,
                              decoration: new InputDecoration(
                                labelText: 'Message',
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(8.0),
                                  borderSide: new BorderSide(),
                                ),
//fillColor: Colors.green
                              ),
                              onChanged: (value) {
                                if (value.length != 0) {
                                  MessageContent = value;
                                }
                                //Do something with the user input.
                              },
                              style: new TextStyle(
                                fontFamily: "Roboto",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 2, 20, 10),
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.deepPurple[400],
                            shape: StadiumBorder(),
                            onPressed: () async {
                              setState(() {
                                showSpinner = true;
                              });
                              try {
                                if (Department != null && Semester != null) {
                                  if (_classid.length != 0) {
                                    if (MessageContent != null) {
                                      String staffID = _auth.currentUser.uid;
                                      String staffMail =
                                          _auth.currentUser.email;
                                      String selectedDepartment = Department;
                                      String selectedSemester = Semester;
                                      String messageContent = MessageContent;
                                      String time = now.toString();
                                      _store
                                          .collection('generalNotifyStudents')
                                          .add({
                                        'email': staffMail,
                                        'department': selectedDepartment,
                                        'semester': selectedSemester,
                                        "classID": _classid,
                                        "messageTitle": MessageTitle,
                                        "message": messageContent,
                                        "dateAndTime": time,
                                        // "sendToAll": allStuOption,
                                      }).whenComplete(
                                        () => showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                contentPadding:
                                                    EdgeInsets.all(20),
                                                title: Text(
                                                    'Notification sent successfully'),
                                                // content: Text(
                                                //     'Please check your request details under View Certificates tab.'),
                                                actions: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        RaisedButton(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      10.0,
                                                                  horizontal:
                                                                      20.0),
                                                          color:
                                                              Color(0xFFFFFFFF),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false);
                                                            setState(() {
                                                              showSpinner =
                                                                  false;
                                                            });
                                                          },
                                                          child: Text(
                                                            "OK",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 17.0,
                                                              color: Color(
                                                                  0xFFEE6666),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              );
                                            }),
                                      );
                                      setState(() {
                                        showSpinner = false;
                                        // _textEditingController.clear();
                                      });
                                    } else {
                                      return showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.all(20),
                                              title: Text(
                                                  'Message cannot be empty'),
                                              // content: Text(
                                              //     'You must include the message with '),
                                              actions: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      RaisedButton(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 10.0,
                                                                horizontal:
                                                                    20.0),
                                                        color:
                                                            Color(0xFFFFFFFF),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(false);
                                                          setState(() {
                                                            showSpinner = false;
                                                          });
                                                        },
                                                        child: Text(
                                                          "OK",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: 17.0,
                                                            color: Color(
                                                                0xFFEE6666),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            );
                                          });
                                    }
                                  } else {
                                    return showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            contentPadding: EdgeInsets.all(20),
                                            title: Text('Choose valid classes'),
                                            content: Text(
                                                'Please choose classes you wish to send notifications to.'),
                                            actions: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    RaisedButton(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10.0,
                                                              horizontal: 20.0),
                                                      color: Color(0xFFFFFFFF),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(false);
                                                        setState(() {
                                                          showSpinner = false;
                                                        });
                                                      },
                                                      child: Text(
                                                        "OK",
                                                        style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontSize: 17.0,
                                                          color:
                                                              Color(0xFFEE6666),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          );
                                        });
                                  }
                                } else {
                                  return showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          contentPadding: EdgeInsets.all(20),
                                          title: Text('Choose valid details'),
                                          content:
                                              Text('Please choose Department'),
                                          actions: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  RaisedButton(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10.0,
                                                            horizontal: 20.0),
                                                    color: Color(0xFFFFFFFF),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(false);
                                                      setState(() {
                                                        showSpinner = false;
                                                      });
                                                    },
                                                    child: Text(
                                                      "OK",
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 17.0,
                                                        color:
                                                            Color(0xFFEE6666),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        );
                                      });
                                }
                              } catch (e) {
                                return showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        contentPadding: EdgeInsets.all(20),
                                        title: Text(e.toString()),
                                        actions: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                RaisedButton(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 20.0),
                                                  color: Color(0xFFFFFFFF),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(false);
                                                    setState(() {
                                                      showSpinner = false;
                                                    });
                                                  },
                                                  child: Text(
                                                    "OK",
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: 17.0,
                                                      color: Color(0xFFEE6666),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    });
                                // print(e);
                              }
                            },
                            child: Text("SEND MESSAGE"),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
