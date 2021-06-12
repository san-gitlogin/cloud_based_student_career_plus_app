import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';
import 'package:student_app/notes_screen/pdfViewer.dart';
import '../choices.dart' as choices;

bool showSpinner = false;
List<String> filePathLists;
final _auth = FirebaseAuth.instance;
final _store = FirebaseFirestore.instance;
List<String> _classid = [];
List<String> _subjectcode = [];
String studentMail;
String fbFilePath;
String fbFileURL;
String fbFileName;
String fbFileData;
String staffMail;
String staffDepartment;
String studentDepartment;
String studentDoc;
List<String> chosenStaffMail = [];
String staffName;
List<String> _docList = [];
// List<staffViewCards> staffCards = [];
List<Map<String, dynamic>> staffChoiceDetails = [];

class NotesContent extends StatefulWidget {
  @override
  _NotesContentState createState() => _NotesContentState();
}

class _NotesContentState extends State<NotesContent> {
  void stuDetailFetch() async {
    var stuDetails = await _store.collection('students').doc(studentDoc).get();
    studentDepartment = stuDetails.data()['department'];
  }

  @override
  void initState() {
    super.initState();
    stuDetailFetch();
    setState(() {
      studentMail = _auth.currentUser.email;
      studentDoc = _auth.currentUser.uid;
    });
  }

  int SubjectNumber;
  List<String> _categories = [];
  String _sort = 'department';

  Color get primaryColor => Theme.of(context).primaryColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 7),
          StaffDetails(),
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
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: S2Tile.fromState(
                        state,
                        hideValue: true,
                        title: const Text('Choose Subject'),
                        trailing: const Icon(Icons.add_circle_outline),
                        body: Column(
                          children: [
                            _subjectcode.length > 1
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0, vertical: 10.0),
                                    child: Text(
                                        'Please choose only one subject',
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 16)),
                                  )
                                : S2TileChips(
                                    chipLength: state.valueObject.length,
                                    chipLabelBuilder: (context, i) {
                                      return Text(state.valueObject[i].value +
                                          ' ' +
                                          '-' +
                                          ' ' +
                                          state.valueObject[i].title);
                                    },
                                    chipOnDelete: (i) {
                                      setState(() {
                                        _subjectcode
                                            .remove(state.valueObject[i].value);
                                        SubjectNumber = _subjectcode.length - 1;
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
              ],
            ),
          ),
          const SizedBox(height: 7),
          Flexible(
            child: Container(
                height: 600,
                child: _subjectcode.isNotEmpty &&
                        chosenStaffMail.isNotEmpty &&
                        _classid.isNotEmpty
                    ? uploadedPdfFiles()
                    : Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text('Please choose all required fields'),
                      )),
          ),
        ],
      ),
    );
  }
}

class StaffDetails extends StatefulWidget {
  @override
  _StaffDetailsState createState() => _StaffDetailsState();
}

class _StaffDetailsState extends State<StaffDetails> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _store.collection('staffs').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot?.hasData ?? true) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
                // ignore: missing_return
              ),
            );
          }
          final staffDetails = snapshot.data.docs;
          for (var staffDetailsSingle in staffDetails) {
            final staffname = staffDetailsSingle.data()['Name'];
            final staffdepartment = staffDetailsSingle.data()['department'];
            final staffEmail = staffDetailsSingle.data()['email'];
            final staffDocID = staffDetailsSingle.id;
            staffMail = staffEmail;
            staffName = staffname;
            staffDepartment = staffdepartment;
            Map<String, dynamic> staffChoiceString = ({
              'value': staffMail,
              'title': staffName,
              'department': staffDepartment
            });
            staffChoiceDetails.add(staffChoiceString);
          }
          final ids =
              staffChoiceDetails.map((e) => e.values.toString()).toSet();
          staffChoiceDetails
              .retainWhere((x) => ids.remove(x.values.toString()));
          return SmartSelect<String>.multiple(
            title: 'Choose staff',
            value: chosenStaffMail,
            choiceItems: S2Choice.listFrom<String, Map>(
              source: staffChoiceDetails,
              value: (index, item) => item['value'],
              title: (index, item) => item['title'],
              group: (index, item) => item['department'],
            ),
            onChange: (state) {
              setState(() {
                chosenStaffMail = state.value;
                // SubjectNumber = _subjectcode.length;
                // print(SubjectNumber);
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
                  title: const Text('Choose Staff'),
                  trailing: const Icon(Icons.add_circle_outline),
                  body: Column(
                    children: [
                      chosenStaffMail.length > 1
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 10.0),
                              child: Text('Please choose only one staff',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16)),
                            )
                          : S2TileChips(
                              chipLength: state.valueObject.length,
                              chipLabelBuilder: (context, i) {
                                return Text(state.valueObject[i].title);
                              },
                              chipOnDelete: (i) {
                                setState(() {
                                  chosenStaffMail
                                      .remove(state.valueObject[i].value);
                                  // SubjectNumber = _subjectcode.length - 1;
                                  // print(SubjectNumber);
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
          );
          // return SmartSelect<String>.single(
          //   title: 'Choose staff',
          //   value: chosenStaffMail,
          //   choiceItems: staffChoiceDetails,
          //   onChange: (state) => setState(() => chosenStaffMail = state.value),
          // );
        });
  }
}

class uploadedPdfFiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _store
            .collection('notesSection')
            .doc(_subjectcode[0])
            .collection(chosenStaffMail[0])
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot?.hasData ?? true) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
                // ignore: missing_return
              ),
            );
          }
          final uploadedPDF = snapshot.data.docs;
          List<pdfViewCard> pdfCards = [];
          for (var pdfFiles in uploadedPDF) {
            final ClassID = pdfFiles.data()['classID'];
            final forDepartment = pdfFiles.data()['department'];
            final filePath = pdfFiles.data()['notesPath'];
            final fileURL = pdfFiles.data()['notesURL'];
            final fileName = pdfFiles.data()['filename'];
            final forSubject = pdfFiles.data()['subject'];
            final fromStaff = pdfFiles.data()['uploadedBy'];
            for (int a = 0; a < ClassID.length; a++) {
              for (int b = 0; b < _classid.length; b++) {
                if (ClassID[a] == _classid[b]) {
                  if (forSubject == _subjectcode[0]) {
                    final docID = pdfFiles.id;
                    _docList.add(docID);
                    fbFileData = docID;
                    fbFilePath = filePath;
                    fbFileURL = fileURL;
                    fbFileName = fileName;
                    final pdfBubble = pdfViewCard(
                        url: fbFileURL,
                        path: fbFilePath,
                        name: fbFileName,
                        doc: fbFileData);
                    pdfCards.add(pdfBubble);
                    // pdfCards.isEmpty
                    //     ? pdfCards.add(pdfBubble)
                    //     : pdfCards[b].name != pdfBubble.name
                    //         ? pdfCards.add(pdfBubble)
                    //         : print('duplicate');
                  }
                }
              }
            }
            final ids = pdfCards.map((e) => e.path).toSet();
            pdfCards.retainWhere((x) => ids.remove(x.path));
          }
          return ListView(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            reverse: false,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: pdfCards != null
                ? pdfCards
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text('There is no files found'),
                        ),
                        Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                            backgroundColor: Colors.lightBlueAccent,
                            // ignore: missing_return
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        });
  }
}

class pdfViewCard extends StatefulWidget {
  pdfViewCard({
    this.url,
    this.path,
    this.name,
    this.doc,
  });
  final String url;
  final String path;
  final String name;
  final String doc;
  @override
  _pdfViewCardState createState() => _pdfViewCardState();
}

class _pdfViewCardState extends State<pdfViewCard> {
  Future<bool> _onBackPressed() {
    Navigator.of(context).pop(false);
  }

  Future removeUploadedPDF(pdfPath, docID) async {
    showSpinner = true;
    if (pdfPath != null) {
      print(pdfPath);
      FirebaseStorage storageReference = FirebaseStorage.instance;
      Reference ref = storageReference.ref().child(pdfPath);
      await ref.delete().whenComplete(() {
        _store
            .collection('notesSection')
            .doc(_subjectcode[0])
            .collection(studentMail)
            .doc(docID)
            .delete();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.all(20),
                title: Text('File deleted successfully'),
                // content: Text(
                //     'Specify the Event Name, Location and Date in respective fields'),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        RaisedButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          color: Color(0xFFFFFFFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(false);
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
        showSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Icon(Icons.article),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(
                      widget.name,
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    child: Text('VIEW FILE'),
                    onPressed: () {
                      print(widget.url);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WillPopScope(
                                  onWillPop: _onBackPressed,
                                  child: ViewPdf(
                                      pdfURL: widget.url,
                                      pdfName: widget.name)),
                              settings: RouteSettings()));
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class UnitButton extends StatelessWidget {
  UnitButton(this.unitNumber);

  final int unitNumber;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: StadiumBorder(),
      onPressed: () {},
      child: Text("Unit $unitNumber"),
    );
  }
}
