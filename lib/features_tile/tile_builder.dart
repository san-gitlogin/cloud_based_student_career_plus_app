import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';
import '../choices.dart' as choices;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

TextEditingController _textEditingController;

class FeaturesTileBuilder extends StatefulWidget {
  @override
  _FeaturesTileBuilderState createState() => _FeaturesTileBuilderState();
}

class _FeaturesTileBuilderState extends State<FeaturesTileBuilder> {
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;
  bool showSpinner = false;
  List<String> _classid = [];
  List<String> _subjectcode = [];
  String Department;
  String Semester;
  String MessageContent;
  int backlognumber;
  Color get primaryColor => Theme.of(context).primaryColor;
  DateTime now = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
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
                  onChange: (state) => setState(() => Department = state.value),
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
            Container(
              child: Column(
                children: [
                  Card(
                    elevation: 3,
                    margin: const EdgeInsets.all(5),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  SmartSelect<String>.multiple(
                    title: 'Choose subject',
                    value: _subjectcode,
                    choiceItems: S2Choice.listFrom<String, Map>(
                      source: choices.subjectcode,
                      value: (index, item) => item['value'],
                      title: (index, item) => item['title'],
                      group: (index, item) => item['department'],
                    ),
                    onChange: (state) {
                      setState(() {
                        _subjectcode = state.value;
                        _subjectcode.sort();
                        backlognumber = _subjectcode.length;
                        print(backlognumber);
                      });
                    },
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
                          title: const Text('Choose Subject'),
                          trailing: const Icon(Icons.add_circle_outline),
                          body: S2TileChips(
                            chipLength: state.valueObject.length,
                            chipLabelBuilder: (context, i) {
                              return Text(state.valueObject[i].title);
                            },
                            chipOnDelete: (i) {
                              setState(() {
                                _subjectcode.remove(state.valueObject[i].value);
                                _subjectcode.sort();
                                backlognumber = _subjectcode.length - 1;
                                print(backlognumber);
                              });
                            },
                            chipColor: Colors.deepPurple[200],
                            chipRaised: true,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
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
              onChange: (state) => setState(() {
                _classid = state.value;
                _classid.sort();
                print(_classid);
              }),
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
                        setState(() {
                          _classid.remove(state.valueObject[i].value);
                          _classid.sort();
                          print(_classid);
                        });
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
                    subtitle:
                        Text('to students with backlogs in chosen subjects'),
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
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 20.0, vertical: 0),
                  //   child: Row(
                  //     children: [
                  //       Checkbox(
                  //         value: this.allStuOption,
                  //         onChanged: (bool value) {
                  //           setState(() {
                  //             this.allStuOption = value;
                  //           });
                  //         },
                  //       ),
                  //       Text('Send to all students'),
                  //     ],
                  //   ),
                  // ),
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
                              if (Department != null &&
                                  Semester != null &&
                                  _subjectcode.length != 0) {
                                if (_classid.length != 0) {
                                  if (MessageContent != null) {
                                    String staffID = _auth.currentUser.uid;
                                    String staffMail = _auth.currentUser.email;
                                    String selectedDepartment = Department;
                                    String selectedSemester = Semester;
                                    String messageContent = MessageContent;
                                    String time = now.toString();
                                    _store.collection('notifyStudents').add({
                                      'email': staffMail,
                                      'department': selectedDepartment,
                                      'semester': selectedSemester,
                                      "backlogsubs": _subjectcode,
                                      "classID": _classid,
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
                                          }),
                                    );
                                    setState(() {
                                      // _textEditingController.clear();
                                      showSpinner = false;
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
                                            contentPadding: EdgeInsets.all(20),
                                            title:
                                                Text('Message cannot be empty'),
                                            // content: Text(
                                            //     'You must include the message with '),
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
                                        content: Text(
                                            'Please choose Department, Semester and respective subject code'),
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
                              }
                            } catch (e) {
                              return showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
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
                                                      BorderRadius.circular(10),
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
    );
  }
}
