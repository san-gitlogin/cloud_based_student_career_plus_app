import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:smart_select/smart_select.dart';
import '../choices.dart' as choices;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

String Date;
String studentMail;
String studentDoc;
String studentClassID;
String studentDepartment;

TextEditingController _textEditingController;

class FeaturesTileODRequest extends StatefulWidget {
  @override
  _FeaturesTileODRequestState createState() => _FeaturesTileODRequestState();
}

class _FeaturesTileODRequestState extends State<FeaturesTileODRequest> {
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;

  bool showSpinner = false;
  List<String> _classid = [];
  List<String> _categories = [];
  String _sort = 'popular';
  String _class = '';
  String Department;
  String Semester;
  String EventName;
  String EventLocation;
  int backlognumber;
  bool approvalOD = false;

  File _image;

  String _uploadedFileURL;
  String imagePath;
  Color get primaryColor => Theme.of(context).primaryColor;

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      image != null
          ? setState(() {
              _image = image;
              uploadFile();
            })
          : showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: EdgeInsets.all(20),
                  title: Text('No valid file is chosen'),
                  content: Text('Please choose a image file from your device'),
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
    });
  }

  Future uploadFile() async {
    showSpinner = true;

    String senderMail = _auth.currentUser.email;
    imagePath = 'certificates/${senderMail}_${Path.basename(_image.path)}';
    FirebaseStorage storageReference = FirebaseStorage.instance;

    Reference ref = storageReference.ref().child(imagePath);
    UploadTask uploadTask = ref.putFile(_image);
    await uploadTask.whenComplete(() => showSpinner = false);
    // print('File Uploaded'));
    ref.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
        print(_uploadedFileURL);
      });
    });
  }

  Future removeUploadedFile() async {
    showSpinner = true;

    if (_uploadedFileURL != null) {
      print(_uploadedFileURL);
      FirebaseStorage storageReference = FirebaseStorage.instance;
      Reference ref = storageReference.ref().child(imagePath);

      await ref.delete().whenComplete(() {
        setState(() {
          _uploadedFileURL = null;
          showSpinner = false;
        });
      });
    }
  }

  void stuDetailFetch() async {
    var stuDetails = await _store.collection('students').doc(studentDoc).get();
    studentClassID = stuDetails.data()['classID'];
    studentDepartment = stuDetails.data()['department'];
  }

  @override
  void initState() {
    super.initState();
    studentMail = _auth.currentUser.email;
    studentDoc = _auth.currentUser.uid;
    stuDetailFetch();
  }

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
                    body: Column(
                      children: [
                        _classid.length > 1
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0, vertical: 10.0),
                                child: Text('Please choose only one class',
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
                                    _classid.remove(state.valueObject[i].value);
                                    _classid.sort();
                                    print(_classid);
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
            const SizedBox(height: 7),
            Card(
              elevation: 3,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const ListTile(
                    //leading: Icon(Icons.account_circle),
                    title: Text('Request for OD'),
                    subtitle: Text('Upload certificate photocopy'),
                  ),
                  DateTimeWidget(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                    child: TextFormField(
                      controller: _textEditingController,
                      decoration: new InputDecoration(
                        labelText: "Event name",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(),
                        ),
//fillColor: Colors.green
                      ),
                      onChanged: (value) {
                        if (value.length != 0) {
                          EventName = value;
                        }
                      },
                      style: new TextStyle(
                        fontFamily: "Roboto",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                    child: TextFormField(
                      controller: _textEditingController,
                      decoration: new InputDecoration(
                        labelText: "Location",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(),
                        ),
//fillColor: Colors.green
                      ),
                      onChanged: (value) {
                        if (value.length != 0) {
                          EventLocation = value;
                        }
                      },
                      style: new TextStyle(
                        fontFamily: "Roboto",
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Material(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            elevation: 5,
                            // color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'UPLOAD CERTIFICATE',
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  _uploadedFileURL != null
                                      ? Image.network(
                                          _uploadedFileURL,
                                          //height: 150,
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1,
                                              backgroundColor:
                                                  Colors.lightBlueAccent,
                                              // ignore: missing_return
                                            ),
                                          ),
                                        ),
                                  Row(
                                    children: [
                                      _image == null
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 15, 15, 15),
                                              child: RaisedButton(
                                                textColor: Colors.white,
                                                color: Colors.red,
                                                shape: StadiumBorder(),
                                                onPressed: () {
                                                  chooseFile();
                                                },
                                                child: Text("Upload Image"),
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 15, 15, 15),
                                              child: RaisedButton(
                                                textColor: Colors.white,
                                                color: Colors.green,
                                                shape: StadiumBorder(),
                                                onPressed: () {
                                                  removeUploadedFile()
                                                      .whenComplete(
                                                          () => chooseFile());
                                                },
                                                child: Text("Uploaded"),
                                              ),
                                            ),
                                      _image == null
                                          ? Flexible(
                                              flex: 8,
                                              child: Text(
                                                'Click on Upload Image to select the file from your device',
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.grey,
                                                  fontFamily: "Roboto",
                                                ),
                                              ),
                                            )
                                          : Flexible(
                                              flex: 8,
                                              child: Text(
                                                'Click on Uploaded to select different file from your device.',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                  fontFamily: "Roboto",
                                                ),
                                              ),
                                            )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Please wait until the image preview is shown',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontFamily: "Roboto",
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 1, 15, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            const SizedBox(width: 8),
                            // TextButton(
                            //   child: const Text('View Certificate'),
                            //   onPressed: () {
                            //     CertificateListScreen();
                            //   },
                            // ),
                            const SizedBox(width: 8),

                            // TextButton(
                            //   child: const Text('UPLOAD CERTIFICATE'),
                            //   onPressed: () {
                            //     uploadFile();
                            //   },
                            // ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 20, 10),
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Colors.green,
                          shape: StadiumBorder(),
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              if (Department != null &&
                                  Department == studentDepartment &&
                                  Semester != null &&
                                  _classid[0] != null &&
                                  _classid[0] == studentClassID) {
                                if (_uploadedFileURL != null) {
                                  if (EventName != null &&
                                      EventLocation != null &&
                                      Date != null) {
                                    String staffID = _auth.currentUser.uid;
                                    String classID = _classid[0];
                                    String studentMail =
                                        _auth.currentUser.email;
                                    String selectedDepartment = Department;
                                    String selectedSemester = Semester;
                                    String date = Date;
                                    String eventName = EventName;
                                    String eventLocation = EventLocation;
                                    String certificateURL = _uploadedFileURL;
                                    bool ODApproval = approvalOD;
                                    _store.collection('odRequests').add({
                                      'email': studentMail,
                                      'department': selectedDepartment,
                                      'semester': selectedSemester,
                                      "classID": classID,
                                      "date": date,
                                      "eventTitle": eventName,
                                      "eventLocation": eventLocation,
                                      "certificateURL": certificateURL,
                                      "certificatePath": imagePath,
                                      "ODApproval": ODApproval,
                                      //"sendToAll": allStuOption,
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
                                                  'OD requested successfully'),
                                              content: Text(
                                                  'Please check your request details under View Requests tab.'),
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
                                                            // _textEditingController
                                                            //     .clear();
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
                                      _uploadedFileURL = null;
                                      // _image.delete();
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
                                            title: Text(
                                                'Please enter valid details'),
                                            content: Text(
                                                'Specify the Event Name, Location and Date in respective fields'),
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
                                          title: Text('File upload error'),
                                          content: Text(
                                              'Please wait until the image preview is shown or upload a valid image file '),
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
                                            'Please choose your respective Department, Current Semester and your ClassID'),
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
                                      content: Text(
                                          'Check if all details are correct'),
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
                          child: Text("REQUEST OD"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DateTimeWidget extends StatefulWidget {
  @override
  _DateTimeWidgetState createState() => _DateTimeWidgetState();
}

class _DateTimeWidgetState extends State<DateTimeWidget> {
  DateTime _dateTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 15, 15, 15),
          child: RaisedButton(
            textColor: Colors.white,
            color: Colors.red,
            shape: StadiumBorder(),
            onPressed: () {
              showDatePicker(
                      context: context,
                      initialDate:
                          _dateTime == null ? DateTime.now() : _dateTime,
                      firstDate: DateTime(2017),
                      lastDate: DateTime(2050))
                  .then((date) {
                setState(() {
                  _dateTime = date;
                  Date = _dateTime.toString().substring(0, 11);
                });
              });
            },
            child: Text("PICK A DATE"),
          ),
        ),
        Flexible(
          child: Text(
            _dateTime == null
                ? 'Nothing has been picked yet'
                : _dateTime.toString().substring(0, 11),
            style: TextStyle(
              fontFamily: "Roboto",
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
