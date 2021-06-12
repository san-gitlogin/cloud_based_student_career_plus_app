import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ViewPdf extends StatefulWidget {
  ViewPdf({this.pdfURL, this.pdfName});
  final String pdfURL;
  final String pdfName;

  @override
  _ViewPdfState createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  Color get primaryColor => Theme.of(context).primaryColor;
  PDFDocument doc;
  @override
  Widget build(BuildContext context) {
    ViewNow() async {
      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          msg: "To go back use the top left navigation icon",
          backgroundColor: Colors.black,
          textColor: Colors.white);
      print(widget.pdfURL);
      doc = await PDFDocument.fromURL(widget.pdfURL);
      setState(() {});
    }

    Widget Loading() {
      try {
        ViewNow().whenComplete(() {
          if (doc == null) {
            return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: EdgeInsets.all(20),
                    title: Text('Oops! your file cannot be loaded'),
                    content: Text(
                        'Please check your internet connectivity and try again'),
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
        });
      } catch (e) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.all(20),
                title: Text('Unable to fetch data !'),
                content: Text(e),
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

    Future<bool> _onBackPressed() {
      Navigator.of(context).pop(false);
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(widget.pdfName != null ? widget.pdfName : 'View file'),
        ),
        body: doc == null ? Loading() : PDFViewer(document: doc),
      ),
    );
  }
}
