import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theme_patrol/theme_patrol.dart';
import 'tabs_staff.dart';

class StaffMainScreen extends StatefulWidget {
  @override
  _StaffMainScreenState createState() => _StaffMainScreenState();
}

class _StaffMainScreenState extends State<StaffMainScreen> {
  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.all(20),
            title: Text('Are you sure willing to exit?'),
            content: Text('You are about to close the application.'),
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
                      onPressed: () {
                        SystemNavigator.pop();
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
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: ThemePatrol(
        light: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.deepPurple,
            primaryColor: Colors.deepPurple,
            accentColor: Colors.deepPurple,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            useTextSelectionTheme: true),
        dark: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.deepPurple,
            primaryColor: Colors.deepPurple,
            accentColor: Colors.deepPurple,
            toggleableActiveColor: Colors.deepPurple,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            useTextSelectionTheme: true),
        mode: ThemeMode.system,
        builder: (context, theme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Panimalar Student App',
            theme: theme.light,
            darkTheme: theme.dark,
            themeMode: theme.mode,
            home: StaffTab(),
          );
        },
      ),
    );
  }
}
