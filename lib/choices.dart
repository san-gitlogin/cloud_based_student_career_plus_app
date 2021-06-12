import 'package:smart_select/smart_select.dart' show S2Choice;

List<S2Choice<String>> semester = [
  S2Choice<String>(value: '1', title: 'One'),
  S2Choice<String>(value: '2', title: 'Two'),
  S2Choice<String>(value: '3', title: 'Three'),
  S2Choice<String>(value: '4', title: 'Four'),
  S2Choice<String>(value: '5', title: 'Five'),
  S2Choice<String>(value: '6', title: 'Six'),
  S2Choice<String>(value: '7', title: 'Seven'),
  S2Choice<String>(value: '8', title: 'Eight'),
];

List<S2Choice<String>> year = [
  S2Choice<String>(value: '1', title: 'One'),
  S2Choice<String>(value: '2', title: 'Two'),
  S2Choice<String>(value: '3', title: 'Three'),
  S2Choice<String>(value: '4', title: 'Four'),
];

List<S2Choice<String>> department = [
  S2Choice<String>(value: 'CSE', title: 'CSE'),
  S2Choice<String>(value: 'ECE', title: 'ECE'),
  S2Choice<String>(value: 'EEE', title: 'EEE'),
  S2Choice<String>(value: 'MECH', title: 'MECH'),
  S2Choice<String>(value: 'EIE', title: 'EIE'),
];

List<Map<String, dynamic>> classid = [
  {'value': '17CSEA', 'title': '17CSEA', 'department': 'CSE'},
  {'value': '17CSEB', 'title': '17CSEB', 'department': 'CSE'},
  {'value': '17CSEC', 'title': '17CSEC', 'department': 'CSE'},
  {'value': '17CSED', 'title': '17CSED', 'department': 'CSE'},
  {'value': '17CSEE', 'title': '17CSEE', 'department': 'CSE'},
  {'value': '17CSEF', 'title': '17CSEF', 'department': 'CSE'},
  {'value': '18CSEA', 'title': '18CSEA', 'department': 'CSE'},
  {'value': '18CSEB', 'title': '18CSEB', 'department': 'CSE'},
  {'value': '18CSEC', 'title': '18CSEC', 'department': 'CSE'},
  {'value': '18CSED', 'title': '18CSED', 'department': 'CSE'},
  {'value': '18CSEE', 'title': '18CSEE', 'department': 'CSE'},
  {'value': '18CSEF', 'title': '18CSEF', 'department': 'CSE'},
];

List<Map<String, dynamic>> subjectcode = [
  {'value': 'CS0000', 'title': 'Programming in C', 'department': 'CSE'},
  {'value': 'CS0001', 'title': 'Programming in Python', 'department': 'CSE'},
  {'value': 'CS0002', 'title': 'Programming in Java', 'department': 'CSE'},
  {'value': 'CS0003', 'title': 'Flutter programming', 'department': 'CSE'},
];
