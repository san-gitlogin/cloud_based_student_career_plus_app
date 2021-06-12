import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';
import 'package:student_app/choices.dart' as choices;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_app/notes_screen/notes_content.dart';

final _auth = FirebaseAuth.instance;
final _store = FirebaseFirestore.instance;
User loggedInUser;

class BacklogContent extends StatefulWidget {
  @override
  _BacklogContentState createState() => _BacklogContentState();
}

class _BacklogContentState extends State<BacklogContent> {
  String studentID;
  bool Backlogs;
  List<String> BackLogSubjects;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getCurrentUser();
    });
  }

  void getCurrentUser() async {
    setState(() async {
      try {
        final student = await _auth.currentUser;
        if (student != null) {
          loggedInUser = student;
          studentID = loggedInUser.email;
          print(loggedInUser.email);
          final students = await _store.collection('students').get();
          for (var details in students.docs) {
            final email = details.data()['email'];
            final backlog = details.data()['backlogs'];
            List<String> backlogsubjects =
                List.castFrom(details.data()['backlogsubs'] as List ?? []);
            if (studentID == email) {
              setState(() {
                Backlogs = backlog;
                print(Backlogs);
                BackLogSubjects = backlogsubjects;
                print(BackLogSubjects);
              });
            }
          }
        }
      } catch (e) {
        print(e);
      }
    });
  }

  ListView GetDetails() {
    int i, j;
    int allSubLength = choices.subjectcode.toList().length;
    List<BacklogCard> backlogCards = [];
    if (BackLogSubjects?.isNotEmpty ?? false) {
      for (j = 0; j < BackLogSubjects.length; j++) {
        String CurrentSub = BackLogSubjects[j];
        for (i = 0; i < allSubLength; i++) {
          S2Choice.listFrom<String, Map>(
            source: choices.subjectcode,
            value: (index, item) => item['value'],
            title: (index, item) => item['title'],
          );
          String checkSubCode =
              choices.subjectcode.elementAt(i)["value"].toString();
          if (CurrentSub == checkSubCode) {
            print(checkSubCode);
            String subName =
                choices.subjectcode.elementAt(i)["title"].toString();
            print(subName);
            final backlogCardAdd = BacklogCard(
              subjectCode: checkSubCode,
              subjectName: subName,
              subNum: (j + 1).toString(),
            );
            backlogCards.add(backlogCardAdd);
            // setState(() {
            //   BuildCard(CurrentSub, subName);
            // });
          }
        }
      }
      return ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        //reverse: true,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        children: backlogCards,
      );
    } else {
      final backlogCardAddNull = BacklogCard(
        subjectCode: 'NIL',
        subjectName: 'NIL',
        subNum: 'NIL',
      );
      backlogCards.add(backlogCardAddNull);
      return ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        //reverse: true,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        children: backlogCards,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 7),
        GetDetails(),
      ],
    );
  }
}

class BacklogCard extends StatelessWidget {
  BacklogCard({this.subjectCode, this.subjectName, this.subNum});
  final String subjectCode;
  final String subjectName;
  final String subNum;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: ListTile(
                  leading: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    child: Text(
                      subNum,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        fontSize: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  title: Text(
                    subjectName != null ? subjectName : 'NIL',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                  subtitle: Text(
                    subjectCode != null ? subjectCode : 'NIL',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      fontSize: 35,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const SizedBox(width: 8),
                  TextButton(
                    child: const Text('View Notes'),
                    onPressed: () {
                      DefaultTabController.of(context).animateTo(4);
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
