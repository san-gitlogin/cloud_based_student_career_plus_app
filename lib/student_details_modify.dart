import 'package:flutter/material.dart';
import 'choices.dart' as choices;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_select/smart_select.dart';

final _store = FirebaseFirestore.instance;
String stuName;
String stuRoll;
String stuReg;
String stuClass;
String stuMail;

List<String> _subjectcode = [];
List<dynamic> alreadySub = [];
int SubjectNumber;
bool isLoaded = false;
bool updatedData = false;

class StudentDetailsModify extends StatefulWidget {
  StudentDetailsModify({
    this.stuDocReceived,
  });

  final String stuDocReceived;

  @override
  _StudentDetailsModifyState createState() => _StudentDetailsModifyState();
}

class _StudentDetailsModifyState extends State<StudentDetailsModify> {
  @override
  void initState() {
    super.initState();
    getStudentDetails().whenComplete(() {
      print(alreadySub);
      setState(() {
        isLoaded = true;
      });
    });
  }

  Future getStudentDetails() async {
    try {
      final student =
          await _store.collection('students').doc(widget.stuDocReceived).get();
      stuName = student.data()['name'];
      alreadySub = student.data()['backlogsubs'];
      for (int i = 0; i < alreadySub.length; i++) {
        _subjectcode.add(alreadySub[i].toString());
      }
      stuRoll = student.data()['rollno'];
      stuReg = student.data()['regno'];
      stuClass = student.data()['classID'];
      stuMail = student.data()['recoveryMail'];
    } catch (e) {
      print(e);
    }
  }

  Future updateStudentDetails() async {
    try {
      await _store.collection('students').doc(widget.stuDocReceived).set(
          {"backlogsubs": _subjectcode},
          SetOptions(merge: true)).whenComplete(() {
        setState(() {
          updatedData = true;
        });
      });
    } catch (e) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.all(20),
        title: Text('Error Updating data!'),
        content: Text(
            'It seems the process of updating student details did not go well. Please try again.'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                RaisedButton(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  color: Color(0xFFFFFFFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoaded
          ? Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        isLoaded = false;
                        _subjectcode.clear();
                      });
                    }),
                title: Text("Modify Student details"),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Flexible(
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Color(0x00000000),
                                radius: 25,
                                backgroundImage:
                                    AssetImage('images/panimalar_logo.png'),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name: ' + stuName != null
                                        ? stuName
                                        : 'NIL',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Roll No: ' + stuRoll != null
                                        ? stuRoll
                                        : 'NIL',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Column(
                            children: [
                              Card(
                                elevation: 3,
                                margin: const EdgeInsets.all(5),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: SmartSelect<String>.multiple(
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
                                      SubjectNumber = _subjectcode.length;
                                      print(SubjectNumber);
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                      ),
                                      child: S2Tile.fromState(
                                        state,
                                        hideValue: true,
                                        title: const Text('Choose Subject'),
                                        trailing: const Icon(
                                            Icons.add_circle_outline),
                                        body: Column(
                                          children: [
                                            S2TileChips(
                                              chipLength:
                                                  state.valueObject.length,
                                              chipLabelBuilder: (context, i) {
                                                return Text(state
                                                        .valueObject[i].value +
                                                    ' ' +
                                                    '-' +
                                                    ' ' +
                                                    state.valueObject[i].title);
                                              },
                                              chipOnDelete: (i) {
                                                setState(() {
                                                  _subjectcode.remove(state
                                                      .valueObject[i].value);
                                                  SubjectNumber =
                                                      _subjectcode.length - 1;
                                                  print(SubjectNumber);
                                                });
                                              },
                                              chipColor: Colors.deepPurple[200],
                                              chipRaised: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.info_outline_rounded,
                                          color:
                                              Color.fromRGBO(143, 148, 251, 1)),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: Text(
                                          "The selected student's backlogs will be shown here. You can add or remove subjects based on your needs. Click on update details for every modification you do.",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Color.fromRGBO(
                                                  143, 148, 251, 1)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: GestureDetector(
                                  onTap: () {
                                    updateStudentDetails();
                                    updatedData
                                        ? showDialog(
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
                                                    'Student details updated'),
                                                content: Text(
                                                    'Update process for selected student finished successfully'),
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
                                            })
                                        : Container(
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                backgroundColor:
                                                    Colors.lightBlueAccent,
                                                // ignore: missing_return
                                              ),
                                            ),
                                          );
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(colors: [
                                          Color.fromRGBO(143, 148, 251, 1),
                                          Color.fromRGBO(143, 148, 251, .6),
                                        ])),
                                    child: Center(
                                      child: Text(
                                        "Update details",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
          : Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent,
                  // ignore: missing_return
                ),
              ),
            ),
    );
  }
}
