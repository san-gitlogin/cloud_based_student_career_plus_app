import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';
import 'package:student_app/student_details_modify.dart';
import '../choices.dart' as choices;
import 'package:cloud_firestore/cloud_firestore.dart';

final _store = FirebaseFirestore.instance;
List<String> _classid = [];
String Department;
String stuDocumentID;
String stuMail;
String stuName;
String stuRoll;
String stuReg;
String stuClassID;
String stuBatch;
String stuBacklogNum;

class FeaturesTileStudent extends StatefulWidget {
  @override
  _FeaturesTileStudentState createState() => _FeaturesTileStudentState();
}

class _FeaturesTileStudentState extends State<FeaturesTileStudent> {
  final dataKey = new GlobalKey();

  @override
  void initState() {
    super.initState();

    setState(() {
      StudentStream();
      ChosenStudentStream();
      StudentSearchCard();
    });
  }

  Color get primaryColor => Theme.of(context).primaryColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 7),
          Card(
            key: dataKey,
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
                  title: const Text('Search Department/Class'),
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
          Flexible(
            child: _classid.isNotEmpty
                ? StudentStream(
                    classID: _classid,
                  )
                : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('Please choose a class to view students'),
                  ),
          ),
        ],
      ),
    );
  }
}

class StudentStream extends StatefulWidget {
  StudentStream({
    this.classID,
  });
  List<String> classID = [];
  @override
  _StudentStreamState createState() => _StudentStreamState();
}

class _StudentStreamState extends State<StudentStream> {
  List<String> chosenStuRoll = [];
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.collection('students').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot?.hasData ?? true) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
              // ignore: missing_return
            ),
          );
        }
        final studentDetails = snapshot.data.docs;
        List<Map<String, dynamic>> stuChoiceDetails = [];
        for (var students in studentDetails) {
          final studName = students.data()['name'];
          final rollNum = students.data()['rollno'];
          final department = students.data()['department'];
          final ClassID = students.data()['classID'];
          for (var classes in widget.classID) {
            if (classes == ClassID) {
              Department = department;
              print(Department);
              stuName = studName;
              stuRoll = rollNum;
              Map<String, dynamic> studentChoiceString = ({
                'value': stuRoll,
                'title': stuName,
                'department': Department
              });
              stuChoiceDetails.add(studentChoiceString);
            }

            final ids =
                stuChoiceDetails.map((e) => e.values.toString()).toSet();
            stuChoiceDetails
                .retainWhere((x) => ids.remove(x.values.toString()));
          }
        }
        return ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          reverse: false,
          children: [
            SmartSelect<String>.multiple(
              title: 'Choose student',
              value: chosenStuRoll,
              choiceItems: S2Choice.listFrom<String, Map>(
                source: stuChoiceDetails,
                value: (index, item) => item['value'],
                title: (index, item) => item['value'],
                group: (index, item) => item['department'],
              ),
              onChange: (state) {
                setState(() {
                  chosenStuRoll = state.value;
                  StudentStream();
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
                    title: const Text('Choose Student'),
                    trailing: const Icon(Icons.add_circle_outline),
                    body: Column(
                      children: [
                        S2TileChips(
                          chipLength: state.valueObject.length,
                          chipLabelBuilder: (context, i) {
                            return Text(state.valueObject[i].title);
                          },
                          chipOnDelete: (i) {
                            setState(() {
                              chosenStuRoll.remove(state.valueObject[i].value);
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
            chosenStuRoll != null
                ? ChosenStudentStream(
                    chosenStuRollList: chosenStuRoll,
                  )
                : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('Please select atleast one student'),
                  ),
          ],
        );
      },
    );
  }
}

class ChosenStudentStream extends StatefulWidget {
  ChosenStudentStream({
    this.chosenStuRollList,
  });

  List<String> chosenStuRollList = [];

  @override
  _ChosenStudentStreamState createState() => _ChosenStudentStreamState();
}

class _ChosenStudentStreamState extends State<ChosenStudentStream> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    print(widget.chosenStuRollList);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.collection('students').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot?.hasData ?? true) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
              // ignore: missing_return
            ),
          );
        }
        final ChosenStudentDetails = snapshot.data.docs;
        List<StudentSearchCard> displayCards = [];
        for (var chosenStudent in ChosenStudentDetails) {
          final chosenStudName = chosenStudent.data()['name'];
          final chosenStudentEmail = chosenStudent.data()['email'];
          final chosenRollNum = chosenStudent.data()['rollno'];
          final chosenDepartment = chosenStudent.data()['department'];
          final chosenRegNum = chosenStudent.data()['regno'];
          final chosenClassID = chosenStudent.data()['classID'];
          List<String> chosenBacklogsubjects =
              List.castFrom(chosenStudent.data()['backlogsubs'] as List ?? []);
          for (var stuRollNum in widget.chosenStuRollList) {
            if (stuRollNum == chosenRollNum) {
              final stuDocID = chosenStudent.id;
              stuDocumentID = stuDocID;
              Department = chosenDepartment;
              print(Department);
              stuName = chosenStudName;
              stuMail = chosenStudentEmail;
              stuRoll = chosenRollNum;
              print(chosenRollNum);
              stuReg = chosenRegNum;
              stuBacklogNum = chosenBacklogsubjects.length.toString();
              stuClassID = chosenClassID;
              stuBatch = stuClassID.substring(0, 2);
              final studentBubble = StudentSearchCard(
                studentName: stuName,
                studentMail: stuMail,
                studentBatch: stuBatch,
                //studentEvents: ,
                studentReg: stuReg,
                studentRoll: stuRoll,
                classID: stuClassID,
                backlogNum: stuBacklogNum,
                department: Department,
                stuDoc: stuDocumentID,
              );
              displayCards.add(studentBubble);
            }
          }
        }
        return Scrollbar(
          // isAlwaysShown: true,
          controller: _scrollController,
          child: ListView(
            controller: _scrollController,
            shrinkWrap: true,
            reverse: false,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: displayCards != null
                ? displayCards
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
          ),
        );
      },
    );
  }
}

class StudentSearchCard extends StatefulWidget {
  StudentSearchCard({
    this.studentName,
    this.studentMail,
    this.studentReg,
    this.studentRoll,
    this.studentBatch,
    this.department,
    this.classID,
    //this.studentEvents,
    this.backlogNum,
    this.stuDoc,
    //this.rollNumber,
  });
  final String studentMail;
  final String studentName;
  final String studentRoll;
  final String studentReg;
  final String department;
  final String studentBatch;
  final String classID;
  final String backlogNum;
  final String stuDoc;
  //final String studentEvents;
  @override
  _StudentSearchCardState createState() =>
      _StudentSearchCardState(mailCheck: studentMail);
}

class _StudentSearchCardState extends State<StudentSearchCard>
    with SingleTickerProviderStateMixin {
  bool isActive = false;
  AnimationController _animationController;
  _StudentSearchCardState({
    this.mailCheck,
  });
  final String mailCheck;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    // TODO: implement initState
    super.initState();
    // setState(() {
    //   EventStream();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      Flexible(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name ',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                            Text(widget.studentName != Null
                                ? widget.studentName
                                : 'NIL'),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Roll No ',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                            Text(widget.studentRoll != Null
                                ? widget.studentRoll
                                : 'NIL'),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Register No ',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                            Text(widget.studentReg != Null
                                ? widget.studentReg
                                : 'NIL'),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Department ',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                            Text(widget.department != Null
                                ? widget.department
                                : 'NIL'),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'ClassID ',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                            Text(widget.classID != Null
                                ? widget.classID
                                : 'NIL'),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Batch ',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                            Text(widget.studentBatch != Null
                                ? widget.studentBatch
                                : 'NIL'),
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   width: 20,
                      // ),
                      Flexible(
                        flex: 2,
                        child: Container(
                          width: 90,
                          child: Card(
                            elevation: 5,
                            color: Colors.deepPurple[200],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          'Backlogs',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  widget.backlogNum != Null
                                      ? widget.backlogNum
                                      : 'NIL',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto',
                                    fontSize: 50,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          icon: AnimatedIcon(
                            icon: AnimatedIcons.list_view,
                            progress: _animationController,
                          ),
                          onPressed: () {
                            setState(() {
                              isActive = !isActive;
                              isActive
                                  ? _animationController.forward()
                                  : _animationController.reverse();
                            });
                          }),
                      Text('EVENTS'),
                    ],
                  ),
                  Flexible(
                    child: Container(
                        height: 120,
                        child: mailCheck.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: EventStream(
                                  MailCheck: mailCheck,
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                    'Please wait until all events get loaded'),
                              )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text("Modify backlog"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return StudentDetailsModify(
                                  stuDocReceived: widget.stuDoc,
                                );
                              },
                            ),
                          );
                        },
                      ),
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

class EventStream extends StatefulWidget {
  EventStream({this.MailCheck});
  final String MailCheck;

  @override
  _EventStreamState createState() => _EventStreamState();
}

class _EventStreamState extends State<EventStream> {
  String semNumber;

  String Title;

  String Location;

  String Date;

  List<Widget> nilEvents = [
    ListView(
      children: [
        Center(
            child: Text(
                'Student has not attended/requested for OD on any events yet')),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.collection('odRequests').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot?.hasData ?? true) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
              // ignore: missing_return
            ),
          );
        }
        final eventDetails = snapshot.data.docs;
        List<EventCards> eventDetailsList = [];
        print(widget.MailCheck);
        for (var details in eventDetails) {
          final studentEmail = details.data()['email'];
          final semesterNumber = details.data()['semester'];
          final titleEvent = details.data()['eventTitle'];
          final locationEvent = details.data()['eventLocation'];
          final dateEvent = details.data()['date'];
          final ODApproval = details.data()['ODApproval'];
          if (widget.MailCheck == studentEmail) {
            if (ODApproval == true) {
              semNumber = semesterNumber;
              print(semNumber);
              Title = titleEvent;
              print(Title);
              Location = locationEvent;
              print(Location);
              Date = dateEvent;
              print(Date);
              final eventBubble = EventCards(
                semNum: semNumber,
                title: Title,
                location: Location,
                date: Date,
              );
              eventBubble != Null
                  ? eventDetailsList.add(eventBubble)
                  : print('NULL');
            }
          }
        }
        return Container(
          height: 120,
          child: eventDetailsList.length > 1
              ? CarouselSlider(
                  options: CarouselOptions(
                    height: 400,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    // enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: eventDetailsList.length > 1 ? true : false,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    // onPageChanged: callbackFunction,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: eventDetailsList != null
                      ? eventDetailsList
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
                )
              : Container(
                  height: 100,
                  child: ListWheelScrollView(
                      physics: BouncingScrollPhysics(),
                      itemExtent: 100,
                      diameterRatio: 2,
                      children: eventDetailsList.length == 1
                          ? eventDetailsList
                          : nilEvents),
                ),
        );
      },
    );
  }
}

class EventCards extends StatefulWidget {
  EventCards({
    this.semNum,
    this.title,
    this.location,
    this.date,
  });
  final String semNum;
  final String title;
  final String location;
  final String date;

  @override
  _EventCardsState createState() => _EventCardsState();
}

class _EventCardsState extends State<EventCards> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ListTile(
                leading: Column(
                  children: [
                    Text(
                      'SEM',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      widget.semNum != null ? widget.semNum : 'NIL',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        fontSize: 35,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                title: Text(
                  widget.title != null ? widget.title : 'NIL',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    // fontSize: 20,
                  ),
                ),
                subtitle: Text(
                  widget.location != null
                      ? widget.location +
                          ' ' +
                          'on ' +
                          widget.date.substring(8, 10) +
                          '-' +
                          widget.date.substring(5, 7) +
                          '-' +
                          widget.date.substring(0, 4)
                      : 'NIL',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                    // fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
