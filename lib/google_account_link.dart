import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:student_app/Animation/FadeAnimation.dart';
import 'package:student_app/password_change_function.dart';
import 'package:student_app/staff_main_screen.dart';
import 'package:student_app/student_main_screen.dart';

bool showSpinner = false;
UserCredential linkauthresult;
User existingUser;
bool linkedSuccess;
final _auth = FirebaseAuth.instance;

class GoogleAccountLink extends StatefulWidget {
  GoogleAccountLink({
    this.studentOrStaff,
  });
  final String studentOrStaff;
  @override
  _GoogleAccountLinkState createState() => _GoogleAccountLinkState();
}

class _GoogleAccountLinkState extends State<GoogleAccountLink> {
  Future linkEmailGoogle() async {
    // showSpinner = true;
    //get currently logged in user
    existingUser = _auth.currentUser;

    //get the credentials of the new linking account
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential gcredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    //now link these credentials with the existing user
    try {
      linkauthresult = await existingUser.linkWithCredential(gcredential);
      linkedSuccess = true;
    } catch (e) {
      linkedSuccess = false;
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: EdgeInsets.all(20),
              title: Text('Error Linking !'),
              content: Text(e.toString()),
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
    }
    // existingUser.updateEmail(googleUser.email);
  }

  Future<bool> _onBackPressed() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SingleChildScrollView(
            child: SafeArea(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeAnimation(
                      0.8,
                      Container(
                        height: 100.0,
                        width: 100.0,
                        margin: EdgeInsets.all(10.0),
                        child: Image(
                          image: AssetImage('images/panimalar_logo.png'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    FadeAnimation(
                      0.8,
                      Container(
                        margin: EdgeInsets.all(5.0),
                        child: Text(
                          'PANIMALAR ENGINEERING COLLEGE',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 10.0,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    // FadeAnimation(
                    //   0.8,
                    //   Container(
                    //     margin: EdgeInsets.all(5.0),
                    //     child: Center(
                    //       child: Text(
                    //         'LINK GMAIL ACCOUNT',
                    //         style: TextStyle(
                    //           fontFamily: 'Montserrat',
                    //           fontSize: 20.0,
                    //           color: Colors.black54,
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                //height: 100,
                                width: 100,
                                margin: EdgeInsets.all(10.0),
                                child: Image(
                                  image: AssetImage('images/google_logo.png'),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: <Widget>[
                                  Center(
                                    child: Text(
                                      "Make sure the account you link is same as your recovery email",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color:
                                              Color.fromRGBO(143, 148, 251, 1)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  FadeAnimation(
                                      2,
                                      GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            showSpinner = true;
                                            linkEmailGoogle().whenComplete(() {
                                              setState(() {
                                                showSpinner = false;
                                              });
                                              print(linkauthresult);
                                              print(existingUser.email);
                                              if (linkedSuccess) {
                                                if (widget.studentOrStaff ==
                                                    'student') {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return StudentMainScreen(); //StaffChoose();
                                                      },
                                                    ),
                                                  );
                                                }
                                                if (widget.studentOrStaff ==
                                                    'staff') {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return StaffMainScreen(); //StaffChoose();
                                                      },
                                                    ),
                                                  );
                                                }
                                              }
                                            });
                                          });
                                        },
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              gradient: LinearGradient(colors: [
                                                Color.fromRGBO(
                                                    143, 148, 251, 1),
                                                Color.fromRGBO(
                                                    143, 148, 251, .6),
                                              ])),
                                          child: Center(
                                            child: Text(
                                              "Link google account",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  FadeAnimation(
                                      2,
                                      GestureDetector(
                                        onTap: () {
                                          _onBackPressed();
                                        },
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              gradient: LinearGradient(colors: [
                                                Color.fromRGBO(
                                                    238, 71, 130, 1.0),
                                                Color.fromRGBO(
                                                    243, 147, 171, 1.0),
                                              ])),
                                          child: Center(
                                            child: Text(
                                              "Go back",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      )),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
