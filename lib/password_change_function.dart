// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';
//
// bool showSpinner = false;
// bool mailSent = false;
// final _auth = FirebaseAuth.instance;
// final _store = FirebaseFirestore.instance;
// String checkedRecoveryMail;
//
// class validateRecoveryMail extends StatefulWidget {
//   validateRecoveryMail(
//       {this.studentOrStaff, this.currentRecoveryMail, this.currentEmail});
//   final String studentOrStaff;
//   final String currentEmail;
//   final String currentRecoveryMail;
//
//   @override
//   _validateRecoveryMailState createState() => _validateRecoveryMailState();
// }
//
// class _validateRecoveryMailState extends State<validateRecoveryMail> {
//   Future sendResetMail(String recoverymail) async {
//     print('send reset called');
//     await _auth.sendPasswordResetEmail(email: recoverymail).whenComplete(() {
//       print("Email sent successfully");
//       // mailSent = true;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print(widget.studentOrStaff);
//     return ModalProgressHUD(
//       inAsyncCall: showSpinner,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: StreamBuilder<QuerySnapshot>(
//             stream: _store.collection(widget.studentOrStaff).snapshots(),
//             builder: (context, snapshot) {
//               if (!snapshot?.hasData ?? true) {
//                 return Center(
//                   child: CircularProgressIndicator(
//                     backgroundColor: Colors.lightBlueAccent,
//                     // ignore: missing_return
//                   ),
//                 );
//               }
//               final fetchedDetails = snapshot.data.docs;
//               for (var details in fetchedDetails) {
//                 final fetchedCurrentEmail = details.data()['email'];
//                 print(fetchedCurrentEmail);
//                 final fetchedRecoveryEmail = details.data()['recoveryMail'];
//                 print(fetchedRecoveryEmail);
//
//                 if (widget.currentEmail == fetchedCurrentEmail &&
//                     widget.currentRecoveryMail == fetchedRecoveryEmail) {
//                   checkedRecoveryMail = fetchedRecoveryEmail;
//                   print(checkedRecoveryMail);
//                 }
//               }
//               try {
//                 sendResetMail(checkedRecoveryMail).whenComplete(() {
//                   setState(() {
//                     showSpinner = false;
//                     mailSent = true;
//                   });
//                 });
//               } catch (e) {
//                 return AlertDialog(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   contentPadding: EdgeInsets.all(20),
//                   title: Text('Server Error'),
//                   content: Text(e.toString()),
//                   actions: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         children: [
//                           RaisedButton(
//                             padding: EdgeInsets.symmetric(
//                                 vertical: 10.0, horizontal: 20.0),
//                             color: Color(0xFFFFFFFF),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             onPressed: () {
//                               Navigator.of(context).pop(false);
//                               setState(() {
//                                 showSpinner = false;
//                               });
//                             },
//                             child: Text(
//                               "OK",
//                               style: TextStyle(
//                                 fontFamily: 'Roboto',
//                                 fontSize: 17.0,
//                                 color: Color(0xFFEE6666),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 );
//               }
//
//               return mailSent
//                   ? AlertDialog(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       contentPadding: EdgeInsets.all(20),
//                       title: Text('Check your email'),
//                       content: Text(
//                           'A password reset link has been sent to your email.'),
//                       actions: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               RaisedButton(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 10.0, horizontal: 20.0),
//                                 color: Color(0xFFFFFFFF),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 onPressed: () {
//                                   Navigator.of(context).pop(false);
//                                   setState(() {
//                                     showSpinner = false;
//                                   });
//                                 },
//                                 child: Text(
//                                   "OK",
//                                   style: TextStyle(
//                                     fontFamily: 'Roboto',
//                                     fontSize: 17.0,
//                                     color: Color(0xFFEE6666),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     )
//                   : AlertDialog(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       contentPadding: EdgeInsets.all(20),
//                       title: Text('Please check both email'),
//                       content: Text(
//                           'It seems the both the emails does not match with each other'),
//                       actions: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               RaisedButton(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 10.0, horizontal: 20.0),
//                                 color: Color(0xFFFFFFFF),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 onPressed: () {
//                                   Navigator.of(context).pop(false);
//                                   setState(() {
//                                     showSpinner = false;
//                                   });
//                                 },
//                                 child: Text(
//                                   "OK",
//                                   style: TextStyle(
//                                     fontFamily: 'Roboto',
//                                     fontSize: 17.0,
//                                     color: Color(0xFFEE6666),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     );
//             }),
//       ),
//     );
//   }
// }
