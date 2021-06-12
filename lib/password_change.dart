import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:student_app/Animation/FadeAnimation.dart';
import 'package:student_app/password_change_function.dart';

// String currentEmail;
String currentRecoveryEmail;
// String checkedRecoveryMail;
bool showSpinner = false;

final _auth = FirebaseAuth.instance;
// final _store = FirebaseFirestore.instance;

class PasswordChangeScreen extends StatefulWidget {
  @override
  _PasswordChangeScreenState createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  Future sendResetMail(String recoverymail) async {
    print('send reset called');
    try {
      await _auth.sendPasswordResetEmail(email: recoverymail);
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: EdgeInsets.all(20),
              title: Text('Mail sent!'),
              content: Text(
                  'Check your inbox , you would have received a mail from our support team. If not please wait until the mail is received'),
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
    } catch (e) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: EdgeInsets.all(20),
              title: Text('Error sending mail'),
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
                    FadeAnimation(
                      0.8,
                      Container(
                        margin: EdgeInsets.all(5.0),
                        child: Text(
                          'PASSWORD RESET',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20.0,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Column(
                        children: <Widget>[
                          FadeAnimation(
                              0.8,
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Color.fromRGBO(143, 148, 251, .2),
                                          blurRadius: 20.0,
                                          offset: Offset(0, 10))
                                    ]),
                                child: Column(
                                  children: <Widget>[
                                    // Container(
                                    //   padding: EdgeInsets.all(8.0),
                                    //   decoration: BoxDecoration(
                                    //       border: Border(
                                    //           bottom: BorderSide(
                                    //               color: Colors.grey[100]))),
                                    //   child: TextField(
                                    //     // controller: emailController,
                                    //     keyboardType:
                                    //         TextInputType.emailAddress,
                                    //     onChanged: (value) {
                                    //       setState(() {
                                    //         currentEmail = value;
                                    //       });
                                    //
                                    //       // value != null
                                    //       //     ? email = value
                                    //       //     : email = emailController.text;
                                    //       //Do something with the user input.
                                    //     },
                                    //     decoration: InputDecoration(
                                    //         labelText: "Login mail",
                                    //         labelStyle: TextStyle(
                                    //             color: Colors.deepPurple[200]),
                                    //         border: InputBorder.none,
                                    //         hintText:
                                    //             'Enter your login mail id',
                                    //         hintStyle: TextStyle(
                                    //             color: Colors.grey[400])),
                                    //   ),
                                    // ),
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[100]))),
                                      child: TextField(
                                        // controller: emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        onChanged: (value) {
                                          setState(() {
                                            currentRecoveryEmail = value;
                                          });

                                          // value != null
                                          //     ? email = value
                                          //     : email = emailController.text;
                                          //Do something with the user input.
                                        },
                                        decoration: InputDecoration(
                                            labelText: "Recovery mail",
                                            labelStyle: TextStyle(
                                                color: Colors.deepPurple[200]),
                                            border: InputBorder.none,
                                            hintText:
                                                'Enter your recovery mail id',
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400])),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          FadeAnimation(
                              2,
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    // showSpinner = true;

                                    // if (currentEmail != null &&
                                    //     currentRecoveryEmail != null) {
                                    // if (currentEmail
                                    //             .split('')
                                    //             .reversed
                                    //             .join()
                                    //             .substring(0, 13) ==
                                    //         'moc.ffatscep@' ||
                                    //     currentEmail
                                    //             .split('')
                                    //             .reversed
                                    //             .join()
                                    //             .substring(0, 15) ==
                                    //         'moc.tnedutscep@') {
                                    //   if (currentEmail
                                    //           .split('')
                                    //           .reversed
                                    //           .join()
                                    //           .substring(0, 13) ==
                                    //       'moc.ffatscep@') {
                                    //     print('staff mail');
                                    //     Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //         builder: (context) {
                                    //           return validateRecoveryMail(
                                    //             studentOrStaff: 'staffs',
                                    //             currentRecoveryMail:
                                    //                 currentRecoveryEmail,
                                    //             currentEmail: currentEmail,
                                    //           ); //StaffChoose();
                                    //         },
                                    //       ),
                                    //     );
                                    //     // validateRecoveryMail(
                                    //     //     studentOrStaff: 'staffs');
                                    //   } else if (currentEmail
                                    //           .split('')
                                    //           .reversed
                                    //           .join()
                                    //           .substring(0, 15) ==
                                    //       'moc.tnedutscep@') {
                                    //     print('student mail');
                                    //     Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //         builder: (context) {
                                    //           return validateRecoveryMail(
                                    //             studentOrStaff: 'students',
                                    //             currentEmail: currentEmail,
                                    //             currentRecoveryMail:
                                    //                 currentRecoveryEmail,
                                    //           ); //StaffChoose();
                                    //         },
                                    //       ),
                                    //     );
                                    //     //
                                    //     // validateRecoveryMail(
                                    //     //     studentOrStaff: 'students');
                                    //   }
                                    // } else {
                                    //   return showDialog(
                                    //       context: context,
                                    //       builder: (BuildContext context) {
                                    //         return AlertDialog(
                                    //           shape: RoundedRectangleBorder(
                                    //             borderRadius:
                                    //                 BorderRadius.circular(10),
                                    //           ),
                                    //           contentPadding:
                                    //               EdgeInsets.all(20),
                                    //           title: Text(
                                    //               'Please check your email'),
                                    //           content: Text(
                                    //               'You must include @pecstaff.com / @pecstudent.com'),
                                    //           actions: [
                                    //             Padding(
                                    //               padding:
                                    //                   const EdgeInsets.all(
                                    //                       8.0),
                                    //               child: Row(
                                    //                 children: [
                                    //                   RaisedButton(
                                    //                     padding: EdgeInsets
                                    //                         .symmetric(
                                    //                             vertical:
                                    //                                 10.0,
                                    //                             horizontal:
                                    //                                 20.0),
                                    //                     color:
                                    //                         Color(0xFFFFFFFF),
                                    //                     shape:
                                    //                         RoundedRectangleBorder(
                                    //                       borderRadius:
                                    //                           BorderRadius
                                    //                               .circular(
                                    //                                   10),
                                    //                     ),
                                    //                     onPressed: () {
                                    //                       Navigator.of(
                                    //                               context)
                                    //                           .pop(false);
                                    //                       setState(() {
                                    //                         showSpinner =
                                    //                             false;
                                    //                       });
                                    //                     },
                                    //                     child: Text(
                                    //                       "OK",
                                    //                       style: TextStyle(
                                    //                         fontFamily:
                                    //                             'Roboto',
                                    //                         fontSize: 17.0,
                                    //                         color: Color(
                                    //                             0xFFEE6666),
                                    //                       ),
                                    //                     ),
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //             )
                                    //           ],
                                    //         );
                                    //       });
                                    // }
                                    if (currentRecoveryEmail != null) {
                                      sendResetMail(currentRecoveryEmail);
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
                                                  'Please enter valid details'),
                                              content: Text(
                                                  'Enter the recovery mail that you entered during registration.'),
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
                                  });
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
                                      "Request password change",
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
                        ],
                      ),
                    ),
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
