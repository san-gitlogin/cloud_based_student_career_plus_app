import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';
import 'package:student_app/notes_screen/pdfViewer.dart';
import '../choices.dart' as choices;

String Department;
bool showSpinner = false;
List<String> _uploadedFilesURL;
List<String> filePathLists;
final _auth = FirebaseAuth.instance;
final _store = FirebaseFirestore.instance;
List<String> _classid = [];
List<String> _subjectcode = [];
String staffMail;
String fbFilePath;
String fbFileURL;
String fbFileName;
String fbFileData;
List<String> _docList = [];

class FeaturesTilePdf extends StatefulWidget {
  @override
  _FeaturesTilePdfState createState() => _FeaturesTilePdfState();
}

class _FeaturesTilePdfState extends State<FeaturesTilePdf> {
  @override
  void initState() {
    super.initState();
    setState(() {
      staffMail = _auth.currentUser.email;
    });
  }

  int SubjectNumber;
  List<String> _categories = [];
  String _sort = 'department';

  Color get primaryColor => Theme.of(context).primaryColor;

  Future choosepdfAndUpload() async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      for (int j = 0; j < result.count; j++) {
        PlatformFile chosenPdf = result.files[j];
        String fileName = chosenPdf.name;
        File chosenFile = File(chosenPdf.path);
        setState(() {
          uploadPdf(chosenFile, fileName).whenComplete(
            () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: EdgeInsets.all(20),
                    title: Text('Uploaded successfully'),
                    content: Text(
                        'Please wait until the pdf files you have uploaded is been previewed'),
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
                }),
          );
        });
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: EdgeInsets.all(20),
              title: Text('No file is choosen'),
              content: Text('Please select atleast one file to be uploaded'),
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
                          // setState(() {
                          //   showSpinner = false;
                          // });
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
  }

  Future uploadPdf(getChosenPDF, getChosenPdfName) async {
    showSpinner = true;
    String filePath =
        'notes/${Department}/${_subjectcode[0]}/${_classid.toString()}/${getChosenPdfName}';
    FirebaseStorage storageReference = FirebaseStorage.instance;
    Reference ref = storageReference.ref().child(filePath);
    UploadTask uploadTask = ref.putFile(getChosenPDF);

    await uploadTask.whenComplete(() {
      showSpinner = false;
      ref.getDownloadURL().then((fileURL) {
        setState(() {
          // _uploadedFilesURL.add(fileURL);
          // filePathLists.add(filePath);
          String selectedDepartment = Department;
          _store
              .collection('notesSection')
              .doc(_subjectcode[0])
              .collection(staffMail)
              .add({
            'filename': getChosenPdfName,
            'uploadedBy': staffMail,
            'department': selectedDepartment,
            "classID": _classid,
            "notesURL": fileURL,
            "notesPath": filePath,
            "subject": _subjectcode[0],
            //"sendToAll": allStuOption,
          });
          print(_uploadedFilesURL);
        });
      });
    });
  }
  // print('File Uploaded'));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SmartSelect<String>.single(
            title: 'Department',
            value: Department,
            choiceItems: choices.department,
            onChange: (state) => setState(() => Department = state.value),
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
                                      return Text(state.valueObject[i].title);
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
          Card(
            elevation: 3,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const ListTile(
                  leading: Icon(Icons.upload_file),
                  title: Text('Upload PDF file'),
                  subtitle:
                      Text('Choose pdf files for chosen subject and class'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    const SizedBox(width: 8),
                    TextButton(
                      child: const Text('CHOOSE PDF'),
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          if (Department != null &&
                              _classid.length >= 1 &&
                              _subjectcode.length > 0) {
                            if (_subjectcode.length == 1) {
                              String staffID = _auth.currentUser.email;
                              if (staffID != null) {
                                await choosepdfAndUpload();
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
                                            Text('Please enter valid details'),
                                        content: Text(
                                            'Specify the Event Name, Location and Date in respective fields'),
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
                            } else {
                              return showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      contentPadding: EdgeInsets.all(20),
                                      title: Text('Check Subjects'),
                                      content: Text(
                                          'Please choose only one subject'),
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
                            }
                          } else {
                            return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    contentPadding: EdgeInsets.all(20),
                                    title: Text('Choose valid details'),
                                    content: Text(
                                        'Please choose department , classID and atleast one subject'),
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
                                  content:
                                      Text('Check if all details are correct'),
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
                          // print(e);
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
          Flexible(
            child: _subjectcode.isNotEmpty
                ? uploadedPdfFiles()
                : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('Please choose a subject to view its files'),
                  ),
          ),
        ],
      ),
    );
  }
}

class uploadedPdfFiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _store
            .collection('notesSection')
            .doc(_subjectcode[0])
            .collection(staffMail)
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
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                        backgroundColor: Colors.lightBlueAccent,
                        // ignore: missing_return
                      ),
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
            .collection(staffMail)
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
                TextButton(
                  child: Text('DELETE FILE',
                      style: TextStyle(
                        color: Colors.red,
                      )),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: EdgeInsets.all(20),
                            title: Text('Are you sure willing to delete?'),
                            content: Text(
                                'You are about to delete the file from database'),
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
                                      },
                                      child: Text(
                                        "NO",
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 17.0,
                                          color: Color(0xFFEE6666),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    RaisedButton(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 20.0),
                                      color: Color(0xFFEE6666),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      onPressed: () async {
                                        Navigator.of(context).pop(false);
                                        await removeUploadedPDF(
                                            widget.path, widget.doc);
                                      },
                                      child: Text(
                                        "YES",
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 17.0,
                                          color: Color(0xFFFFFFFF),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        });
                  },
                ),
                TextButton(
                  child: Text('VIEW FILE'),
                  onPressed: () {
                    print(widget.url);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WillPopScope(
                                onWillPop: _onBackPressed,
                                child: ViewPdf(
                                    pdfURL: widget.url, pdfName: widget.name)),
                            settings: RouteSettings()));
                  },
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
